-- ============================================================
-- Migration 002 — Expand User Profile
-- Adds adaptive coaching fields to users table.
-- All columns are nullable or have safe defaults — existing rows unaffected.
-- ============================================================

-- Body composition
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS height_inches           INTEGER,
  ADD COLUMN IF NOT EXISTS current_weight_lbs      NUMERIC(6,1),
  ADD COLUMN IF NOT EXISTS target_weight_lbs       NUMERIC(6,1),
  ADD COLUMN IF NOT EXISTS body_build              TEXT CHECK (body_build IN ('lean','average','high_fat')),
  ADD COLUMN IF NOT EXISTS fat_distribution        TEXT CHECK (fat_distribution IN ('central','lower','balanced'));

-- Training preferences
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS training_experience     TEXT CHECK (training_experience IN ('beginner','intermediate','advanced')),
  ADD COLUMN IF NOT EXISTS workout_environment     TEXT CHECK (workout_environment IN ('gym','home')) DEFAULT 'gym',
  ADD COLUMN IF NOT EXISTS equipment_level         TEXT CHECK (equipment_level IN ('full_gym','dumbbells','bands','bodyweight')) DEFAULT 'full_gym',
  ADD COLUMN IF NOT EXISTS workout_days_per_week   INTEGER CHECK (workout_days_per_week BETWEEN 1 AND 7),
  ADD COLUMN IF NOT EXISTS session_length_minutes  INTEGER;

-- Nutrition preferences
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS nutrition_preference    TEXT CHECK (nutrition_preference IN ('balanced','high_protein','low_carb','fasting')),
  ADD COLUMN IF NOT EXISTS dietary_restrictions    TEXT[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS food_allergies          TEXT[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS disliked_foods          TEXT[] DEFAULT '{}';

-- Lifestyle signals
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS activity_level          TEXT CHECK (activity_level IN ('sedentary','light','moderate','active','very_active')),
  ADD COLUMN IF NOT EXISTS sleep_hours_avg         NUMERIC(3,1),
  ADD COLUMN IF NOT EXISTS stress_level            TEXT CHECK (stress_level IN ('low','moderate','high'));

-- System fields
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS profile_complete        BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS adaptation_mode         TEXT CHECK (adaptation_mode IN ('auto','guided')) DEFAULT 'auto';
