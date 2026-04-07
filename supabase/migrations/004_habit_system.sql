-- ============================================================
-- Migration 004 — Habit System
-- Creates habit_templates, user_habits (with streaks), user_habit_logs.
-- Existing habits + habit_logs tables are preserved untouched.
-- ============================================================

-- ============================================================
-- 1. HABIT TEMPLATES (reference — seeded externally)
-- Multi-signal: archetype + goal + fat_distribution + environment
-- NULL in any signal = applies to all values of that signal
-- ============================================================
CREATE TABLE IF NOT EXISTS habit_templates (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  archetype           TEXT REFERENCES archetypes(id),           -- null = all archetypes
  goal                TEXT CHECK (goal IN ('fat_loss','muscle_gain','performance','general','longevity')),
  fat_distribution    TEXT CHECK (fat_distribution IN ('central','lower','balanced')),  -- null = all
  workout_environment TEXT CHECK (workout_environment IN ('gym','home')),               -- null = all
  habit_name          TEXT NOT NULL,
  habit_type          TEXT NOT NULL CHECK (habit_type IN ('daily','weekly')),
  target_type         TEXT NOT NULL CHECK (target_type IN ('binary','count','duration','amount')),
  target_value        NUMERIC,
  target_unit         TEXT,
  description         TEXT,
  sort_order          INTEGER DEFAULT 0,
  is_active           BOOLEAN DEFAULT TRUE
);
ALTER TABLE habit_templates ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read habit_templates" ON habit_templates;
CREATE POLICY "Public read habit_templates" ON habit_templates FOR SELECT USING (true);

-- ============================================================
-- 2. USER HABITS (assigned habits per user)
-- Includes streak tracking per habit
-- ============================================================
CREATE TABLE IF NOT EXISTS user_habits (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  habit_template_id   UUID NOT NULL REFERENCES habit_templates(id),
  is_active           BOOLEAN DEFAULT TRUE,
  assigned_at         TIMESTAMPTZ DEFAULT NOW(),
  -- Streak tracking
  current_streak      INTEGER DEFAULT 0,
  longest_streak      INTEGER DEFAULT 0,
  last_completed_date DATE,
  UNIQUE(user_id, habit_template_id)
);
ALTER TABLE user_habits ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users own their habits" ON user_habits;
CREATE POLICY "Users own their habits" ON user_habits FOR ALL USING (auth.uid() = user_id);
CREATE INDEX IF NOT EXISTS idx_user_habits_active ON user_habits(user_id, is_active);

-- ============================================================
-- 3. USER HABIT LOGS (daily completion log)
-- ============================================================
CREATE TABLE IF NOT EXISTS user_habit_logs (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  user_habit_id   UUID NOT NULL REFERENCES user_habits(id) ON DELETE CASCADE,
  log_date        DATE NOT NULL DEFAULT CURRENT_DATE,
  completed       BOOLEAN DEFAULT FALSE,
  value_logged    NUMERIC,
  notes           TEXT,
  logged_at       TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_habit_id, log_date)
);
ALTER TABLE user_habit_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users own habit logs" ON user_habit_logs;
CREATE POLICY "Users own habit logs" ON user_habit_logs FOR ALL USING (auth.uid() = user_id);
CREATE INDEX IF NOT EXISTS idx_user_habit_logs ON user_habit_logs(user_id, log_date);
