-- ============================================================
-- Migration 005 — Adaptation Engine Tables
-- Creates user_checkins, user_progress_logs, adaptation_events.
-- ============================================================

-- ============================================================
-- 1. USER CHECK-INS (weekly user-submitted signals)
-- ============================================================
CREATE TABLE IF NOT EXISTS user_checkins (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  checkin_date    DATE NOT NULL DEFAULT CURRENT_DATE,
  weight_lbs      NUMERIC(6,1),
  energy_level    INTEGER CHECK (energy_level BETWEEN 1 AND 5),
  sleep_quality   INTEGER CHECK (sleep_quality BETWEEN 1 AND 5),
  stress_level    INTEGER CHECK (stress_level BETWEEN 1 AND 5),
  soreness_level  INTEGER CHECK (soreness_level BETWEEN 1 AND 5),
  hunger_level    INTEGER CHECK (hunger_level BETWEEN 1 AND 5),
  notes           TEXT,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, checkin_date)
);
ALTER TABLE user_checkins ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users own checkins" ON user_checkins;
CREATE POLICY "Users own checkins" ON user_checkins FOR ALL USING (auth.uid() = user_id);
CREATE INDEX IF NOT EXISTS idx_user_checkins ON user_checkins(user_id, checkin_date DESC);

-- ============================================================
-- 2. USER PROGRESS LOGS (computed weekly summaries)
-- Written by the adaptation engine after each check-in.
-- ============================================================
CREATE TABLE IF NOT EXISTS user_progress_logs (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  week_start            DATE NOT NULL,
  workouts_completed    INTEGER DEFAULT 0,
  workouts_scheduled    INTEGER DEFAULT 0,
  habits_completed_rate NUMERIC(4,2),   -- 0.00 to 1.00
  avg_energy            NUMERIC(3,1),
  avg_sleep_quality     NUMERIC(3,1),
  avg_stress            NUMERIC(3,1),
  weight_change_lbs     NUMERIC(4,1),
  confidence_score      INTEGER DEFAULT 0,  -- 0–100 signal reliability score
  notes                 TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, week_start)
);
ALTER TABLE user_progress_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users own progress logs" ON user_progress_logs;
CREATE POLICY "Users own progress logs" ON user_progress_logs FOR ALL USING (auth.uid() = user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_logs ON user_progress_logs(user_id, week_start DESC);

-- ============================================================
-- 3. ADAPTATION EVENTS (log of all adaptation decisions)
-- In guided mode: status='pending_approval' until user approves.
-- In auto mode:   status='active' immediately.
-- ============================================================
CREATE TABLE IF NOT EXISTS adaptation_events (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  event_date      DATE NOT NULL DEFAULT CURRENT_DATE,
  event_type      TEXT NOT NULL,   -- 'habits_simplified' | 'session_shortened' | 'volume_reduced' | 'deload_recommended' | 'calories_adjusted'
  priority_tier   INTEGER NOT NULL CHECK (priority_tier IN (1,2,3)),  -- 1=habits, 2=training, 3=nutrition
  old_value       TEXT,
  new_value       TEXT,
  reason          TEXT NOT NULL,           -- Human-readable explanation (shown in UI)
  reinforcement   TEXT,                    -- Positive framing message (shown alongside reason)
  confidence_score INTEGER DEFAULT 0,      -- Score that triggered this event
  week_start      DATE,
  status          TEXT DEFAULT 'active' CHECK (status IN ('active','pending_approval','approved','dismissed')),
  dismissed_at    TIMESTAMPTZ,
  approved_at     TIMESTAMPTZ,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE adaptation_events ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users own adaptation events" ON adaptation_events;
CREATE POLICY "Users own adaptation events" ON adaptation_events FOR ALL USING (auth.uid() = user_id);
CREATE INDEX IF NOT EXISTS idx_adaptation_events ON adaptation_events(user_id, event_date DESC);
CREATE INDEX IF NOT EXISTS idx_adaptation_active ON adaptation_events(user_id, status) WHERE status IN ('active','pending_approval');
