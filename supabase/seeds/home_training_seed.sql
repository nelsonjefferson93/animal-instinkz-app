-- ============================================================
-- Home Training Plans Seed
-- 3 goals × 4 days = 12 training days, ~60 exercises
-- archetype = 'home' is a universal home plan (not archetype-specific)
-- Requires migration 006 to have been run first.
-- ============================================================

-- ── TRAINING PLANS ──────────────────────────────────────────

INSERT INTO training_plans (id, archetype, goal, week_number, name, description, environment)
VALUES
  ('00000000-0000-0000-0010-000000000001', 'home', 'fat_loss',    1, 'Home Fat Loss — Week 1',    'Bodyweight circuits designed to burn fat and build conditioning from home.', 'home'),
  ('00000000-0000-0000-0010-000000000002', 'home', 'muscle_gain', 1, 'Home Muscle Gain — Week 1', 'Push/pull/legs split using bodyweight and dumbbells for progressive overload.', 'home'),
  ('00000000-0000-0000-0010-000000000003', 'home', 'general',     1, 'Home General — Week 1',     'Full-body home sessions for overall fitness, strength, and conditioning.', 'home')
ON CONFLICT (archetype, goal, week_number) DO NOTHING;


-- ── FAT LOSS — TRAINING DAYS ────────────────────────────────

INSERT INTO training_days (id, training_plan_id, day_number, day_name, focus, notes)
VALUES
  ('00000000-0000-0000-0011-000000000001', '00000000-0000-0000-0010-000000000001', 1, 'Day 1', 'Upper Body Burn',      'Push volume with short rest. Control every rep.'),
  ('00000000-0000-0000-0011-000000000002', '00000000-0000-0000-0010-000000000001', 2, 'Day 2', 'Lower Body Circuit',   'Legs and glutes. Move with intention.'),
  ('00000000-0000-0000-0011-000000000003', '00000000-0000-0000-0010-000000000001', 3, 'Day 3', 'HIIT Conditioning',    'High intensity. Short rest. No excuses.'),
  ('00000000-0000-0000-0011-000000000004', '00000000-0000-0000-0010-000000000001', 4, 'Day 4', 'Full Body Finisher',   'End the week strong. Full body, max effort.')
ON CONFLICT DO NOTHING;

-- Fat Loss Day 1 — Upper Body Burn
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000001', 1,  'Push-Up',                  '4', '15',     45,  'moderate', 'Full range — chest to floor. No half reps.'),
  ('00000000-0000-0000-0011-000000000001', 2,  'Pike Push-Up',             '3', '12',     45,  'moderate', 'Hips high, elbows out — targets shoulders.'),
  ('00000000-0000-0000-0011-000000000001', 3,  'Tricep Dip (Chair)',       '3', '12',     45,  'moderate', 'Use a sturdy chair. Elbows straight back.'),
  ('00000000-0000-0000-0011-000000000001', 4,  'Wide Push-Up',             '3', '12',     45,  'moderate', 'Hands wider than shoulder-width — chest emphasis.'),
  ('00000000-0000-0000-0011-000000000001', 5,  'Mountain Climbers',        '3', '30 sec', 30,  'high',     'Drive knees fast. Keep hips level.'),
  ('00000000-0000-0000-0011-000000000001', 6,  'Plank',                    '3', '45 sec', 30,  'moderate', 'Squeeze everything. Breathe steadily.');

-- Fat Loss Day 2 — Lower Body Circuit
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000002', 1,  'Bodyweight Squat',         '4', '20',     45,  'moderate', 'Chest tall, drive knees out, full depth.'),
  ('00000000-0000-0000-0011-000000000002', 2,  'Walking Lunge',            '3', '16',     45,  'moderate', '8 each leg. Long stride, tall posture.'),
  ('00000000-0000-0000-0011-000000000002', 3,  'Glute Bridge',             '4', '20',     30,  'moderate', 'Drive through heels, squeeze hard at top.'),
  ('00000000-0000-0000-0011-000000000002', 4,  'Lateral Lunge',            '3', '12',     45,  'moderate', '6 each side. Sit into the hip, tall chest.'),
  ('00000000-0000-0000-0011-000000000002', 5,  'Jump Squat',               '3', '10',     60,  'high',     'Soft landing — absorb through your hips and knees.'),
  ('00000000-0000-0000-0011-000000000002', 6,  'Wall Sit',                 '3', '45 sec', 45,  'high',     'Thighs parallel. Burn through it.');

-- Fat Loss Day 3 — HIIT Conditioning
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000003', 1,  'Burpee',                   '4', '10',     30,  'high',     'Explosive jump. Chest to floor. No pace — full effort.'),
  ('00000000-0000-0000-0011-000000000003', 2,  'High Knees',               '4', '30 sec', 20,  'high',     'Drive knees to waist height. Arms pump.'),
  ('00000000-0000-0000-0011-000000000003', 3,  'Jump Jack',                '3', '30 sec', 20,  'moderate', 'Steady rhythm. Stay light on your feet.'),
  ('00000000-0000-0000-0011-000000000003', 4,  'Push-Up to T Rotation',    '3', '10',     30,  'moderate', '5 each side. Push-up then rotate, arm to sky.'),
  ('00000000-0000-0000-0011-000000000003', 5,  'Squat Jump',               '3', '12',     45,  'high',     'Full squat depth, explode up.'),
  ('00000000-0000-0000-0011-000000000003', 6,  'Plank to Push-Up',         '3', '8',      30,  'moderate', 'Down to elbows and back up. Control every transition.');

-- Fat Loss Day 4 — Full Body Finisher
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000004', 1,  'Push-Up',                  '3', '15',     30,  'moderate', NULL),
  ('00000000-0000-0000-0011-000000000004', 2,  'Bodyweight Squat',         '3', '20',     30,  'moderate', NULL),
  ('00000000-0000-0000-0011-000000000004', 3,  'Burpee',                   '3', '10',     45,  'high',     NULL),
  ('00000000-0000-0000-0011-000000000004', 4,  'Walking Lunge',            '3', '16',     30,  'moderate', NULL),
  ('00000000-0000-0000-0011-000000000004', 5,  'Mountain Climbers',        '3', '30 sec', 30,  'high',     NULL),
  ('00000000-0000-0000-0011-000000000004', 6,  'Plank',                    '3', '60 sec', 30,  'moderate', 'Hold the final set until failure.');


-- ── MUSCLE GAIN — TRAINING DAYS ─────────────────────────────

INSERT INTO training_days (id, training_plan_id, day_number, day_name, focus, notes)
VALUES
  ('00000000-0000-0000-0011-000000000005', '00000000-0000-0000-0010-000000000002', 1, 'Day 1', 'Push (Chest / Shoulders / Triceps)', 'Control the eccentric. Slow down builds more muscle.'),
  ('00000000-0000-0000-0011-000000000006', '00000000-0000-0000-0010-000000000002', 2, 'Day 2', 'Pull (Back / Biceps)',               'Every pull is an opportunity to build thickness.'),
  ('00000000-0000-0000-0011-000000000007', '00000000-0000-0000-0010-000000000002', 3, 'Day 3', 'Legs',                               'Legs grow from volume. Do not short-change this day.'),
  ('00000000-0000-0000-0011-000000000008', '00000000-0000-0000-0010-000000000002', 4, 'Day 4', 'Arms and Core',                      'Finish the week. Isolate, build, recover.')
ON CONFLICT DO NOTHING;

-- Muscle Gain Day 1 — Push
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000005', 1,  'Push-Up',                  '4', '15–20',  60,  'moderate', '3-second descent. Control builds muscle.'),
  ('00000000-0000-0000-0011-000000000005', 2,  'Pike Push-Up',             '4', '12',     60,  'moderate', 'Shoulders and upper chest. Hips high.'),
  ('00000000-0000-0000-0011-000000000005', 3,  'Diamond Push-Up',          '3', '10',     60,  'moderate', 'Hands form a diamond. Triceps primary.'),
  ('00000000-0000-0000-0011-000000000005', 4,  'Tricep Dip (Chair)',       '3', '12–15',  60,  'moderate', 'Full range of motion. No half reps.'),
  ('00000000-0000-0000-0011-000000000005', 5,  'Incline Push-Up',          '3', '15',     45,  'moderate', 'Hands on an elevated surface — lower chest focus.'),
  ('00000000-0000-0000-0011-000000000005', 6,  'Shoulder Tap Plank',       '3', '20',     45,  'low',      '10 each side. Keep hips square.');

-- Muscle Gain Day 2 — Pull
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000006', 1,  'Pull-Up',                  '4', 'max',    90,  'high',     'Full hang start. Pull elbows to floor. If no bar: use a doorframe bar.'),
  ('00000000-0000-0000-0011-000000000006', 2,  'Inverted Row (Table)',     '4', '12',     60,  'moderate', 'Lie under a table, pull chest to edge. Keep body rigid.'),
  ('00000000-0000-0000-0011-000000000006', 3,  'Dumbbell Row',             '3', '12',     60,  'moderate', 'Each arm. Elbow drives back and up. No swinging.'),
  ('00000000-0000-0000-0011-000000000006', 4,  'Dumbbell Bicep Curl',      '3', '12',     60,  'moderate', 'Supinate at the top. Controlled negative.'),
  ('00000000-0000-0000-0011-000000000006', 5,  'Superman Hold',            '3', '30 sec', 30,  'low',      'Arms and legs off the floor. Squeeze through the whole hold.'),
  ('00000000-0000-0000-0011-000000000006', 6,  'Chin-Up',                  '3', 'max',    90,  'high',     'Underhand grip. Biceps and lats. Full range.');

-- Muscle Gain Day 3 — Legs
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000007', 1,  'Bulgarian Split Squat',    '4', '10',     75,  'high',     '5 each leg. Back foot elevated. Knee tracks toe.'),
  ('00000000-0000-0000-0011-000000000007', 2,  'Romanian Deadlift (DB)',   '4', '12',     60,  'moderate', 'Hinge at hips, soft knees. Feel the hamstring stretch.'),
  ('00000000-0000-0000-0011-000000000007', 3,  'Goblet Squat (DB)',        '3', '15',     60,  'moderate', 'Chest tall. Elbows inside knees. Full depth.'),
  ('00000000-0000-0000-0011-000000000007', 4,  'Glute Bridge',             '4', '20',     45,  'moderate', 'Drive through heels. Hard squeeze at top. Add dumbbell for load.'),
  ('00000000-0000-0000-0011-000000000007', 5,  'Step-Up (Chair)',          '3', '16',     45,  'moderate', '8 each leg. Drive through the heel of the working leg.'),
  ('00000000-0000-0000-0011-000000000007', 6,  'Calf Raise',               '3', '20',     30,  'low',      'Single leg if possible. Full range — heels drop below level.');

-- Muscle Gain Day 4 — Arms and Core
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000008', 1,  'Dumbbell Bicep Curl',      '4', '12',     45,  'moderate', 'Slow negative — 3 seconds down. Squeeze at top.'),
  ('00000000-0000-0000-0011-000000000008', 2,  'Overhead Tricep Extension (DB)', '4', '12', 45, 'moderate', 'Both hands on one dumbbell. Full range overhead.'),
  ('00000000-0000-0000-0011-000000000008', 3,  'Diamond Push-Up',          '3', '10',     45,  'moderate', NULL),
  ('00000000-0000-0000-0011-000000000008', 4,  'Plank',                    '3', '60 sec', 30,  'moderate', 'Squeeze abs and glutes throughout.'),
  ('00000000-0000-0000-0011-000000000008', 5,  'Hollow Body Hold',         '3', '30 sec', 30,  'moderate', 'Lower back pressed to floor. Arms overhead, legs extended.'),
  ('00000000-0000-0000-0011-000000000008', 6,  'Hammer Curl',              '3', '12',     45,  'moderate', 'Neutral grip. Targets brachialis and forearms.');


-- ── GENERAL — TRAINING DAYS ─────────────────────────────────

INSERT INTO training_days (id, training_plan_id, day_number, day_name, focus, notes)
VALUES
  ('00000000-0000-0000-0011-000000000009',  '00000000-0000-0000-0010-000000000003', 1, 'Day 1', 'Full Body A',         'Foundational strength. Execute with intention.'),
  ('00000000-0000-0000-0011-000000000010', '00000000-0000-0000-0010-000000000003', 2, 'Day 2', 'Cardio and Core',     'Keep moving. Build your engine.'),
  ('00000000-0000-0000-0011-000000000011', '00000000-0000-0000-0010-000000000003', 3, 'Day 3', 'Full Body B',         'More volume. Build on Day 1.'),
  ('00000000-0000-0000-0011-000000000012', '00000000-0000-0000-0010-000000000003', 4, 'Day 4', 'Mobility and Recovery', 'Earn your recovery. Move well, restore fully.')
ON CONFLICT DO NOTHING;

-- General Day 1 — Full Body A
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000009',  1,  'Push-Up',                  '3', '12',     45,  'moderate', NULL),
  ('00000000-0000-0000-0011-000000000009',  2,  'Bodyweight Squat',         '3', '15',     45,  'moderate', NULL),
  ('00000000-0000-0000-0011-000000000009',  3,  'Pull-Up',                  '3', 'max',    60,  'moderate', 'Or inverted row if no pull-up bar.'),
  ('00000000-0000-0000-0011-000000000009',  4,  'Walking Lunge',            '3', '16',     45,  'moderate', '8 each leg.'),
  ('00000000-0000-0000-0011-000000000009',  5,  'Plank',                    '3', '45 sec', 30,  'moderate', NULL),
  ('00000000-0000-0000-0011-000000000009',  6,  'Glute Bridge',             '3', '15',     30,  'low',      NULL);

-- General Day 2 — Cardio and Core
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000010', 1,  'Burpee',                   '3', '10',     45,  'high',     NULL),
  ('00000000-0000-0000-0011-000000000010', 2,  'Mountain Climbers',        '3', '30 sec', 30,  'high',     NULL),
  ('00000000-0000-0000-0011-000000000010', 3,  'High Knees',               '3', '30 sec', 30,  'high',     NULL),
  ('00000000-0000-0000-0011-000000000010', 4,  'Plank',                    '3', '45 sec', 30,  'moderate', NULL),
  ('00000000-0000-0000-0011-000000000010', 5,  'Bicycle Crunch',           '3', '20',     30,  'moderate', '10 each side. Elbow to opposite knee.'),
  ('00000000-0000-0000-0011-000000000010', 6,  'Dead Bug',                 '3', '10',     30,  'low',      '5 each side. Lower back stays pressed to floor.');

-- General Day 3 — Full Body B
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000011', 1,  'Pike Push-Up',             '3', '10',     45,  'moderate', NULL),
  ('00000000-0000-0000-0011-000000000011', 2,  'Bulgarian Split Squat',    '3', '8',      60,  'moderate', '4 each leg.'),
  ('00000000-0000-0000-0011-000000000011', 3,  'Inverted Row (Table)',     '3', '10',     45,  'moderate', NULL),
  ('00000000-0000-0000-0011-000000000011', 4,  'Goblet Squat (DB)',        '3', '12',     45,  'moderate', 'Or bodyweight squat if no dumbbells.'),
  ('00000000-0000-0000-0011-000000000011', 5,  'Tricep Dip (Chair)',       '3', '12',     45,  'moderate', NULL),
  ('00000000-0000-0000-0011-000000000011', 6,  'Superman Hold',            '3', '30 sec', 30,  'low',      NULL);

-- General Day 4 — Mobility and Recovery
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes)
VALUES
  ('00000000-0000-0000-0011-000000000012', 1,  'Hip Flexor Stretch',       '2', '60 sec', 15,  'low',      '30 sec each side. Breathe into the stretch.'),
  ('00000000-0000-0000-0011-000000000012', 2,  'Thoracic Rotation',        '2', '10',     15,  'low',      '5 each side. Slow and deliberate.'),
  ('00000000-0000-0000-0011-000000000012', 3,  'World''s Greatest Stretch', '2', '6',     15,  'low',      '3 each side. Lunge + rotation + reach.'),
  ('00000000-0000-0000-0011-000000000012', 4,  'Pigeon Pose',              '2', '60 sec', 15,  'low',      '30 sec each side. Breathe through the tightness.'),
  ('00000000-0000-0000-0011-000000000012', 5,  'Cat-Cow',                  '2', '10',     15,  'low',      'Slow and smooth. Full range each direction.'),
  ('00000000-0000-0000-0011-000000000012', 6,  'Child''s Pose',            '2', '60 sec', 0,   'low',      'Final reset. Breathe, let go, recover.');
