-- ============================================================
-- Migration 006 — Add environment column to training_plans
-- Allows separate gym vs home workout plans.
-- All existing plans default to 'gym'.
-- ============================================================

ALTER TABLE training_plans
  ADD COLUMN IF NOT EXISTS environment TEXT DEFAULT 'gym';

-- Backfill existing rows
UPDATE training_plans SET environment = 'gym' WHERE environment IS NULL;
