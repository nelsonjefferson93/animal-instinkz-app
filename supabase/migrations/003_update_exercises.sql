-- ============================================================
-- Migration 003 — Update Exercises for Gym/Home System
-- Adds is_home_compatible and exercise_substitution_group columns.
-- Backfills based on existing seeded exercise data.
-- ============================================================

ALTER TABLE exercises
  ADD COLUMN IF NOT EXISTS is_home_compatible          BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS exercise_substitution_group TEXT;

-- ============================================================
-- Backfill: is_home_compatible
-- True if exercise requires no gym-only equipment
-- ============================================================

-- All bodyweight exercises are home-compatible
UPDATE exercises SET is_home_compatible = TRUE
WHERE category = 'bodyweight';

-- Mobility exercises are home-compatible
UPDATE exercises SET is_home_compatible = TRUE
WHERE category = 'mobility';

-- Kettlebell exercises are home-compatible (dumbbells can sub for KB)
UPDATE exercises SET is_home_compatible = TRUE
WHERE category = 'kettlebell';

-- Conditioning: jump rope is home-compatible
UPDATE exercises SET is_home_compatible = TRUE
WHERE id = '00000000-0000-0000-0001-000000000025'; -- Jump Rope

-- ============================================================
-- Backfill: exercise_substitution_group
-- Exercises with the same group can substitute for each other
-- based on movement pattern + primary muscles
-- ============================================================

-- Horizontal push
UPDATE exercises SET exercise_substitution_group = 'horizontal_push'
WHERE id IN (
  '00000000-0000-0000-0001-000000000003', -- Bench Press
  '00000000-0000-0000-0001-000000000009', -- Push-Up
  '00000000-0000-0000-0001-000000000021'  -- Chest Press Machine
);

-- Vertical push
UPDATE exercises SET exercise_substitution_group = 'vertical_push'
WHERE id IN (
  '00000000-0000-0000-0001-000000000004', -- Overhead Press
  '00000000-0000-0000-0001-000000000024'  -- KB Clean and Press
);

-- Tricep/dip push
UPDATE exercises SET exercise_substitution_group = 'tricep_push'
WHERE id IN (
  '00000000-0000-0000-0001-000000000011'  -- Dip
);

-- Vertical pull
UPDATE exercises SET exercise_substitution_group = 'vertical_pull'
WHERE id IN (
  '00000000-0000-0000-0001-000000000010', -- Pull-Up
  '00000000-0000-0000-0001-000000000018'  -- Lat Pulldown
);

-- Horizontal pull
UPDATE exercises SET exercise_substitution_group = 'horizontal_pull'
WHERE id IN (
  '00000000-0000-0000-0001-000000000005', -- Barbell Row
  '00000000-0000-0000-0001-000000000019'  -- Cable Row
);

-- Hip hinge (heavy)
UPDATE exercises SET exercise_substitution_group = 'hip_hinge_heavy'
WHERE id IN (
  '00000000-0000-0000-0001-000000000002', -- Deadlift
  '00000000-0000-0000-0001-000000000006', -- Romanian Deadlift
  '00000000-0000-0000-0001-000000000020'  -- Leg Curl
);

-- Hip hinge (glute-focused)
UPDATE exercises SET exercise_substitution_group = 'hip_hinge_glute'
WHERE id IN (
  '00000000-0000-0000-0001-000000000007', -- Hip Thrust
  '00000000-0000-0000-0001-000000000022'  -- Kettlebell Swing
);

-- Squat (bilateral)
UPDATE exercises SET exercise_substitution_group = 'squat_bilateral'
WHERE id IN (
  '00000000-0000-0000-0001-000000000001', -- Back Squat
  '00000000-0000-0000-0001-000000000008', -- Front Squat
  '00000000-0000-0000-0001-000000000016', -- Bodyweight Squat
  '00000000-0000-0000-0001-000000000017', -- Leg Press
  '00000000-0000-0000-0001-000000000023'  -- Goblet Squat
);

-- Squat (unilateral / lunge)
UPDATE exercises SET exercise_substitution_group = 'squat_unilateral'
WHERE id IN (
  '00000000-0000-0000-0001-000000000014', -- Box Jump
  '00000000-0000-0000-0001-000000000015'  -- Walking Lunge
);

-- Core / carry
UPDATE exercises SET exercise_substitution_group = 'core_carry'
WHERE id IN (
  '00000000-0000-0000-0001-000000000012'  -- Plank
);

-- Conditioning / locomotion
UPDATE exercises SET exercise_substitution_group = 'conditioning_full_body'
WHERE id IN (
  '00000000-0000-0000-0001-000000000013', -- Burpee
  '00000000-0000-0000-0001-000000000025', -- Jump Rope
  '00000000-0000-0000-0001-000000000026', -- Rowing Machine
  '00000000-0000-0000-0001-000000000027', -- Assault Bike
  '00000000-0000-0000-0001-000000000028'  -- Battle Ropes
);

-- Mobility
UPDATE exercises SET exercise_substitution_group = 'mobility_lower'
WHERE id = '00000000-0000-0000-0001-000000000029'; -- Hip Flexor Stretch

UPDATE exercises SET exercise_substitution_group = 'mobility_upper'
WHERE id = '00000000-0000-0000-0001-000000000030'; -- Thoracic Rotation
