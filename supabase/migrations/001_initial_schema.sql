-- ============================================================
-- Animal Instinkz — Initial Schema
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard
-- ============================================================

-- 1. ARCHETYPES (reference table — seed after creation)
CREATE TABLE archetypes (
  id                  TEXT PRIMARY KEY,
  display_name        TEXT NOT NULL,
  headline            TEXT NOT NULL,
  description         TEXT NOT NULL,
  traits              TEXT[] NOT NULL DEFAULT '{}',
  strengths           TEXT[] NOT NULL DEFAULT '{}',
  blind_spots         TEXT[] NOT NULL DEFAULT '{}',
  training_style      TEXT NOT NULL,
  nutrition_style     TEXT NOT NULL,
  coaching_tone       TEXT NOT NULL,
  illustration_url    TEXT,
  color_accent        TEXT,
  created_at          TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE archetypes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read archetypes" ON archetypes FOR SELECT USING (true);

-- 2. USERS (extends Supabase auth.users)
CREATE TABLE users (
  id                  UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email               TEXT NOT NULL UNIQUE,
  display_name        TEXT,
  avatar_url          TEXT,
  training_mode       TEXT CHECK (training_mode IN ('fat_loss', 'muscle_gain', 'performance', 'general')) DEFAULT 'general',
  subscription_tier   TEXT CHECK (subscription_tier IN ('free', 'premium')) DEFAULT 'free',
  subscription_status TEXT CHECK (subscription_status IN ('active', 'cancelled', 'past_due')) DEFAULT 'active',
  stripe_customer_id  TEXT UNIQUE,
  onboarding_complete BOOLEAN DEFAULT FALSE,
  created_at          TIMESTAMPTZ DEFAULT NOW(),
  updated_at          TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view and update own profile" ON users FOR ALL USING (auth.uid() = id);

-- Auto-create user row on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, display_name)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'display_name'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- 3. USER ARCHETYPES
CREATE TABLE user_archetypes (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  primary_archetype   TEXT NOT NULL REFERENCES archetypes(id),
  secondary_archetype TEXT REFERENCES archetypes(id),
  scores              JSONB NOT NULL DEFAULT '{}',
  is_active           BOOLEAN DEFAULT TRUE,
  assigned_at         TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE user_archetypes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users own their archetype" ON user_archetypes FOR ALL USING (auth.uid() = user_id);
CREATE INDEX idx_user_archetypes_active ON user_archetypes(user_id, is_active);

-- 4. ASSESSMENT RESPONSES
CREATE TABLE assessment_responses (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  answers       JSONB NOT NULL DEFAULT '{}',
  result_scores JSONB NOT NULL DEFAULT '{}',
  primary_result TEXT NOT NULL REFERENCES archetypes(id),
  attempt_number INTEGER DEFAULT 1,
  completed_at  TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE assessment_responses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users own assessment responses" ON assessment_responses FOR ALL USING (auth.uid() = user_id);
CREATE INDEX idx_assessment_user ON assessment_responses(user_id, completed_at DESC);

-- 5. EXERCISES
CREATE TABLE exercises (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name                    TEXT NOT NULL,
  category                TEXT NOT NULL CHECK (category IN ('compound_lift', 'bodyweight', 'machine', 'kettlebell', 'conditioning', 'mobility', 'hundred_series')),
  equipment               TEXT[] DEFAULT '{}',
  movement_pattern        TEXT CHECK (movement_pattern IN ('push', 'pull', 'hinge', 'squat', 'carry', 'rotation', 'locomotion')),
  muscle_primary          TEXT[] DEFAULT '{}',
  muscle_secondary        TEXT[] DEFAULT '{}',
  difficulty              TEXT CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')) DEFAULT 'intermediate',
  hundred_series_approved BOOLEAN DEFAULT FALSE,
  coaching_cues           TEXT[] DEFAULT '{}',
  archetype_affinity      TEXT[] DEFAULT '{}',
  video_url               TEXT,
  created_at              TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read exercises" ON exercises FOR SELECT USING (true);
CREATE INDEX idx_exercises_hundred ON exercises(hundred_series_approved) WHERE hundred_series_approved = TRUE;

-- 6. WORKOUT TEMPLATES
CREATE TABLE workout_templates (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  archetype_id            TEXT REFERENCES archetypes(id),
  training_mode           TEXT NOT NULL CHECK (training_mode IN ('fat_loss', 'muscle_gain', 'performance', 'general')),
  week_number             INTEGER NOT NULL CHECK (week_number BETWEEN 1 AND 4),
  day_label               TEXT NOT NULL,
  day_number              INTEGER NOT NULL,
  estimated_duration_min  INTEGER,
  notes                   TEXT,
  created_at              TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE workout_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read workout templates" ON workout_templates FOR SELECT USING (true);
CREATE INDEX idx_templates_archetype_mode ON workout_templates(archetype_id, training_mode, week_number, day_number);

-- 7. WORKOUT TEMPLATE EXERCISES
CREATE TABLE workout_template_exercises (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id     UUID NOT NULL REFERENCES workout_templates(id) ON DELETE CASCADE,
  exercise_id     UUID NOT NULL REFERENCES exercises(id),
  exercise_order  INTEGER NOT NULL,
  block           TEXT CHECK (block IN ('activation', 'primary', 'accessory', 'finisher', 'cooldown')),
  sets            INTEGER NOT NULL,
  reps_min        INTEGER,
  reps_max        INTEGER,
  rpe_target      NUMERIC(3,1),
  rest_seconds    INTEGER DEFAULT 120,
  coaching_note   TEXT
);
ALTER TABLE workout_template_exercises ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read template exercises" ON workout_template_exercises FOR SELECT USING (true);
CREATE INDEX idx_template_exercises ON workout_template_exercises(template_id, exercise_order);

-- 8. WORKOUT LOGS
CREATE TABLE workout_logs (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  template_id           UUID REFERENCES workout_templates(id),
  archetype_id          TEXT REFERENCES archetypes(id),
  training_mode         TEXT,
  completed_at          TIMESTAMPTZ DEFAULT NOW(),
  duration_actual_min   INTEGER,
  perceived_difficulty  INTEGER CHECK (perceived_difficulty BETWEEN 1 AND 5),
  notes                 TEXT
);
ALTER TABLE workout_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users own workout logs" ON workout_logs FOR ALL USING (auth.uid() = user_id);
CREATE INDEX idx_workout_logs_user ON workout_logs(user_id, completed_at DESC);

-- 9. WORKOUT LOG SETS
CREATE TABLE workout_log_sets (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workout_log_id  UUID NOT NULL REFERENCES workout_logs(id) ON DELETE CASCADE,
  exercise_id     UUID NOT NULL REFERENCES exercises(id),
  set_number      INTEGER NOT NULL,
  reps_completed  INTEGER,
  weight_lbs      NUMERIC(6,2),
  rpe_actual      NUMERIC(3,1),
  notes           TEXT
);
ALTER TABLE workout_log_sets ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users own log sets" ON workout_log_sets FOR ALL
  USING (auth.uid() = (SELECT user_id FROM workout_logs WHERE id = workout_log_id));
CREATE INDEX idx_log_sets_workout ON workout_log_sets(workout_log_id);

-- 10. HUNDRED SERIES LOGS
CREATE TABLE hundred_series_logs (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  exercise_id       UUID REFERENCES exercises(id),
  archetype_id      TEXT REFERENCES archetypes(id),
  level_attempted   INTEGER NOT NULL CHECK (level_attempted IN (20, 40, 60, 80, 100)),
  reps_completed    INTEGER NOT NULL,
  level_completed   BOOLEAN GENERATED ALWAYS AS (reps_completed >= level_attempted) STORED,
  duration_seconds  INTEGER,
  rest_count        INTEGER DEFAULT 0,
  attempted_at      TIMESTAMPTZ DEFAULT NOW(),
  notes             TEXT
);
ALTER TABLE hundred_series_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users own 100 Series logs" ON hundred_series_logs FOR ALL USING (auth.uid() = user_id);
CREATE INDEX idx_hundred_user ON hundred_series_logs(user_id, attempted_at DESC);

-- 11. USER HUNDRED SERIES PROGRESS
CREATE TABLE user_hundred_series_progress (
  user_id           UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  current_level     INTEGER DEFAULT 20 CHECK (current_level IN (20, 40, 60, 80, 100)),
  exercise_id       UUID REFERENCES exercises(id),
  best_reps         INTEGER DEFAULT 0,
  total_attempts    INTEGER DEFAULT 0,
  last_attempted_at TIMESTAMPTZ,
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE user_hundred_series_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users own hundred progress" ON user_hundred_series_progress FOR ALL USING (auth.uid() = user_id);

-- 12. HABITS
CREATE TABLE habits (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  archetype_id  TEXT NOT NULL REFERENCES archetypes(id),
  habit_name    TEXT NOT NULL,
  description   TEXT,
  habit_order   INTEGER DEFAULT 1,
  icon          TEXT
);
ALTER TABLE habits ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read habits" ON habits FOR SELECT USING (true);

-- 13. HABIT LOGS
CREATE TABLE habit_logs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  habit_id    UUID NOT NULL REFERENCES habits(id),
  logged_date DATE NOT NULL DEFAULT CURRENT_DATE,
  completed   BOOLEAN DEFAULT TRUE,
  logged_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, habit_id, logged_date)
);
ALTER TABLE habit_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users own habit logs" ON habit_logs FOR ALL USING (auth.uid() = user_id);
CREATE INDEX idx_habit_logs_user_date ON habit_logs(user_id, logged_date);

-- 14. STREAKS
CREATE TABLE streaks (
  user_id            UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  current_streak     INTEGER DEFAULT 0,
  longest_streak     INTEGER DEFAULT 0,
  last_activity_date DATE,
  streak_type        TEXT DEFAULT 'combined',
  updated_at         TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users own streaks" ON streaks FOR ALL USING (auth.uid() = user_id);
