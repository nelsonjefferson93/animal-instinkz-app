-- ============================================================
-- Migration 007 — Update training_plans unique constraint
-- Adds environment to the unique key so archetype-specific
-- gym and home plans can coexist for the same archetype+goal.
-- ============================================================

-- Drop the old constraint (created in mvp_seed.sql)
ALTER TABLE training_plans
  DROP CONSTRAINT IF EXISTS training_plans_archetype_goal_week_number_key;

-- Add new constraint that includes environment
ALTER TABLE training_plans
  ADD CONSTRAINT training_plans_archetype_goal_week_number_env_key
  UNIQUE (archetype, goal, week_number, environment);
