-- ============================================================
-- Home Training Plans Seed — Archetype-Specific
-- 8 archetypes × 3 goals × 4 days = 96 days, ~576 exercises
-- Based on The 8-Archetype Home Training System research doc.
-- Requires migration 006 + 007 to have been run first.
-- ============================================================
-- UUID scheme:
--   Plans : 00000000-0000-0000-0020-{AA}{GG}00000000
--   Days  : 00000000-0000-0000-0021-{AA}{GG}0000000{D}
--   AA = archetype (01=lion 02=gorilla 03=hawk 04=wolf
--                   05=panther 06=bear 07=fox 08=stallion)
--   GG = goal      (01=fat_loss 02=muscle_gain 03=general)
--   D  = day number (1-4)
-- ============================================================


-- ════════════════════════════════════════════════════════════
-- 1. LION — Power + Explosive
--    Split: Lower Power | Upper Power | Conditioning + Core | Full Body Carries
-- ════════════════════════════════════════════════════════════

INSERT INTO training_plans (id, archetype, goal, week_number, name, description, environment) VALUES
  ('00000000-0000-0000-0020-010100000000', 'lion', 'fat_loss',    1, 'Lion Home Fat Loss — Week 1',    'Explosive circuits that torch fat while keeping power output high.', 'home'),
  ('00000000-0000-0000-0020-010200000000', 'lion', 'muscle_gain', 1, 'Lion Home Muscle — Week 1',      'Power-based hypertrophy: compound movements, loaded carries, heavy patterns.', 'home'),
  ('00000000-0000-0000-0020-010300000000', 'lion', 'general',     1, 'Lion Home General — Week 1',     'Balanced power and conditioning. Move fast, recover well.', 'home')
ON CONFLICT ON CONSTRAINT training_plans_archetype_goal_week_number_env_key DO NOTHING;

-- Lion training days
INSERT INTO training_days (id, training_plan_id, day_number, day_name, focus, notes) VALUES
  -- fat_loss
  ('00000000-0000-0000-0021-010100000001', '00000000-0000-0000-0020-010100000000', 1, 'Day 1', 'Lower Power + Explosive',    'Plyometrics drive EPOC. Land soft, reset fast.'),
  ('00000000-0000-0000-0021-010100000002', '00000000-0000-0000-0020-010100000000', 2, 'Day 2', 'Upper Power + Conditioning', 'Push speed and max effort reps. Short rest keeps HR elevated.'),
  ('00000000-0000-0000-0021-010100000003', '00000000-0000-0000-0020-010100000000', 3, 'Day 3', 'Metabolic Circuit',          'No rest between exercises. Lions do not coast.'),
  ('00000000-0000-0000-0021-010100000004', '00000000-0000-0000-0020-010100000000', 4, 'Day 4', 'Full Body Finisher',         'Power output meets endurance. Finish the week on fire.'),
  -- muscle_gain
  ('00000000-0000-0000-0021-010200000001', '00000000-0000-0000-0020-010200000000', 1, 'Day 1', 'Lower Power Strength',       'Heavy unilateral legs + loaded carries. Build base power.'),
  ('00000000-0000-0000-0021-010200000002', '00000000-0000-0000-0020-010200000000', 2, 'Day 2', 'Upper Power Strength',       'Explosive push + controlled pull. Build athletic upper body.'),
  ('00000000-0000-0000-0021-010200000003', '00000000-0000-0000-0020-010200000000', 3, 'Day 3', 'Posterior Chain + Core',     'RDL, hip hinge, anti-rotation. The engine behind the lion.'),
  ('00000000-0000-0000-0021-010200000004', '00000000-0000-0000-0020-010200000000', 4, 'Day 4', 'Full Body Carries + Power',  'Suitcase and rack carries + full-body power combos.'),
  -- general
  ('00000000-0000-0000-0021-010300000001', '00000000-0000-0000-0020-010300000000', 1, 'Day 1', 'Lower Power',                'Explosive lower body. Drive from the ground up.'),
  ('00000000-0000-0000-0021-010300000002', '00000000-0000-0000-0020-010300000000', 2, 'Day 2', 'Upper Power',                'Speed reps + controlled strength. Balanced upper.'),
  ('00000000-0000-0000-0021-010300000003', '00000000-0000-0000-0020-010300000000', 3, 'Day 3', 'Conditioning + Core',        'Intervals and core. Keep the engine clean.'),
  ('00000000-0000-0000-0021-010300000004', '00000000-0000-0000-0020-010300000000', 4, 'Day 4', 'Full Body + Mobility',       'End of week reset. Power, then unwind.')
ON CONFLICT DO NOTHING;

-- Lion Fat Loss Day 1 — Lower Power + Explosive
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010100000001', 1, 'Split Squat Jump',       '4', '8',      40, 'high',     'Target RPE 9 — 1 rep left. Explode up, land quiet. Alternate legs.'),
  ('00000000-0000-0000-0021-010100000001', 2, 'Bulgarian Split Squat',  '3', '10',     45, 'high',     'Target RPE 8 — 2 reps left. Back foot elevated, full depth.'),
  ('00000000-0000-0000-0021-010100000001', 3, 'Squat Jump',             '3', '10',     40, 'high',     'Full depth, max height. Absorb landing through hips.'),
  ('00000000-0000-0000-0021-010100000001', 4, 'DB Romanian Deadlift',   '3', '12',     45, 'moderate', 'Target RPE 8. Hinge deep, feel hamstring load.'),
  ('00000000-0000-0000-0021-010100000001', 5, 'Lateral Bound',          '3', '10',     30, 'high',     '5 each side. Drive off one leg, stick the landing.'),
  ('00000000-0000-0000-0021-010100000001', 6, 'Pallof Press',           '3', '12',     30, 'moderate', 'Band or cable. Press and hold 2s. No rotation. Anti-rotation core.');

-- Lion Fat Loss Day 2 — Upper Power + Conditioning
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010100000002', 1, 'Explosive Push-Up',      '4', '8',      40, 'high',     'Target RPE 9. Chest to floor, push hands off ground. Max speed.'),
  ('00000000-0000-0000-0021-010100000002', 2, 'DB Push Press',          '4', '8',      45, 'high',     'Target RPE 8–9. Leg drive to launch DBs. Lock out overhead.'),
  ('00000000-0000-0000-0021-010100000002', 3, '1-Arm DB Row',           '3', '10',     45, 'moderate', 'Target RPE 8. Drive elbow back and up. No hip rotation.'),
  ('00000000-0000-0000-0021-010100000002', 4, 'Push-Up to T Rotation',  '3', '10',     30, 'moderate', '5 each side. Push-up then rotate, stack feet, arm to ceiling.'),
  ('00000000-0000-0000-0021-010100000002', 5, 'Mountain Climbers',      '3', '30 sec', 20, 'high',     'Drive knees fast. Hip level. Keep breathing.'),
  ('00000000-0000-0000-0021-010100000002', 6, 'DB Farmers Carry',       '3', '30m',    45, 'moderate', 'Heavy as possible. Tight grip, tall posture. Walk 15m out, 15m back.');

-- Lion Fat Loss Day 3 — Metabolic Circuit
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010100000003', 1, 'Burpee',                 '4', '10',     20, 'high',     'No rest between reps. Chest to floor every time.'),
  ('00000000-0000-0000-0021-010100000003', 2, 'Split Squat Jump',       '4', '8',      20, 'high',     'No stopping. Alternate legs continuously.'),
  ('00000000-0000-0000-0021-010100000003', 3, 'Push-Up',                '4', '15',     20, 'high',     'Full range every rep. Target RPE 9 — 1 rep left.'),
  ('00000000-0000-0000-0021-010100000003', 4, 'High Knees',             '4', '30 sec', 15, 'high',     'Drive knees to hip height. Arms pump.'),
  ('00000000-0000-0000-0021-010100000003', 5, 'DB Swing',               '3', '15',     30, 'high',     'Hip hinge drives the swing. Not a squat. Glutes snap at top.'),
  ('00000000-0000-0000-0021-010100000003', 6, 'Plank',                  '3', '45 sec', 30, 'moderate', 'Rigid body. Squeeze glutes and abs together.');

-- Lion Fat Loss Day 4 — Full Body Finisher
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010100000004', 1, 'Squat Jump',             '3', '10',     30, 'high',     'Open the session with power. Max height every rep.'),
  ('00000000-0000-0000-0021-010100000004', 2, 'Explosive Push-Up',      '3', '8',      30, 'high',     'Speed off the floor. Full ROM.'),
  ('00000000-0000-0000-0021-010100000004', 3, 'Bulgarian Split Squat',  '3', '10',     45, 'high',     '5 each leg. Loaded if possible. RPE 8.'),
  ('00000000-0000-0000-0021-010100000004', 4, 'DB Push Press',          '3', '8',      45, 'high',     'Drive legs into every rep.'),
  ('00000000-0000-0000-0021-010100000004', 5, 'Burpee to Jump',         '3', '8',      30, 'high',     'Full burpee with tuck jump at top. Max effort.'),
  ('00000000-0000-0000-0021-010100000004', 6, 'Pallof Press',           '2', '12',     30, 'moderate', 'Cool down the CNS. Anti-rotation. Hold 2s each rep.');

-- Lion Muscle Gain Day 1 — Lower Power Strength
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010200000001', 1, 'Bulgarian Split Squat',  '4', '8',      75, 'high',     'Target RPE 8–9. Heaviest load you can control. 4 each leg.'),
  ('00000000-0000-0000-0021-010200000001', 2, 'DB Romanian Deadlift',   '4', '10',     75, 'high',     'Target RPE 8. Max stretch at bottom, drive hips through.'),
  ('00000000-0000-0000-0021-010200000001', 3, 'Split Squat Jump',       '3', '6',      60, 'high',     'Speed reps after heavy strength. CNS activation.'),
  ('00000000-0000-0000-0021-010200000001', 4, 'DB Hip Thrust',          '3', '12',     60, 'moderate', 'Back on bench or couch. DB on hips. Hard squeeze at top.'),
  ('00000000-0000-0000-0021-010200000001', 5, 'DB Suitcase Carry',      '3', '30m',    60, 'moderate', 'One DB, walk tall. Resist lateral lean. Switch hands each set.'),
  ('00000000-0000-0000-0021-010200000001', 6, 'Pallof Press',           '3', '12',     45, 'moderate', 'Anti-rotation. Brace hard, press and hold 2s.');

-- Lion Muscle Gain Day 2 — Upper Power Strength
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010200000002', 1, 'DB Push Press',          '4', '8',      75, 'high',     'Target RPE 8–9. Leg drive into every rep. Lock out overhead.'),
  ('00000000-0000-0000-0021-010200000002', 2, 'Explosive Push-Up',      '4', '8',      60, 'high',     'Hands leave floor each rep. Max intent.'),
  ('00000000-0000-0000-0021-010200000002', 3, '1-Arm DB Row',           '4', '10',     75, 'high',     'Target RPE 8. Elbow drives back and up. Pause 1s at top.'),
  ('00000000-0000-0000-0021-010200000002', 4, 'DB Floor Press',         '3', '12',     60, 'moderate', 'Lie on floor. Press to lockout. 3s eccentric. RPE 8.'),
  ('00000000-0000-0000-0021-010200000002', 5, 'DB Overhead Press',      '3', '10',     60, 'moderate', 'Standing. Brace core. Press straight up, elbows slightly forward.'),
  ('00000000-0000-0000-0021-010200000002', 6, 'DB Farmers Carry',       '3', '30m',    60, 'moderate', 'Grip strength and posture. Go heavy.');

-- Lion Muscle Gain Day 3 — Posterior Chain + Core
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010200000003', 1, 'DB Romanian Deadlift',   '4', '10',     75, 'high',     'Target RPE 8–9. Max hamstring stretch. Hip drive at top.'),
  ('00000000-0000-0000-0021-010200000003', 2, 'DB Hip Thrust',          '4', '12',     60, 'high',     'Load as heavy as possible. 2s hold at top.'),
  ('00000000-0000-0000-0021-010200000003', 3, 'Single-Leg DB RDL',      '3', '10',     60, 'moderate', '5 each leg. Slow and controlled. Feel the balance challenge.'),
  ('00000000-0000-0000-0021-010200000003', 4, 'Pallof Press',           '3', '12',     45, 'moderate', 'Band at hip height. Press to full extension, 2s hold.'),
  ('00000000-0000-0000-0021-010200000003', 5, 'Dead Bug',               '3', '10',     30, 'moderate', '5 each side. Lower back pressed to floor. Slow and deliberate.'),
  ('00000000-0000-0000-0021-010200000003', 6, 'Superman Hold',          '3', '30 sec', 30, 'low',      'Arms and legs extended. Squeeze glutes and lats throughout.');

-- Lion Muscle Gain Day 4 — Full Body Carries + Power
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010200000004', 1, 'DB Goblet Squat',        '4', '10',     60, 'high',     'Target RPE 8. Elbows inside knees. Full depth. Chest tall.'),
  ('00000000-0000-0000-0021-010200000004', 2, 'DB Push Press',          '4', '8',      75, 'high',     'Max leg drive. Finish week with power output.'),
  ('00000000-0000-0000-0021-010200000004', 3, 'DB Suitcase Carry',      '3', '30m',    60, 'moderate', 'One heavy DB. Walk 15m, switch, 15m back.'),
  ('00000000-0000-0000-0021-010200000004', 4, 'DB Front Rack Carry',    '3', '30m',    60, 'moderate', 'DBs at shoulder height. Core braced. Walk tall.'),
  ('00000000-0000-0000-0021-010200000004', 5, 'Squat Jump',             '3', '6',      45, 'high',     'Speed reps. Full depth, explode up.'),
  ('00000000-0000-0000-0021-010200000004', 6, 'Plank',                  '3', '60 sec', 30, 'moderate', 'Tight finish. Ribs down, glutes squeezed.');

-- Lion General Day 1 — Lower Power
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010300000001', 1, 'Split Squat Jump',       '4', '8',      45, 'high',     'Explosive start. Alternate legs. Soft landing.'),
  ('00000000-0000-0000-0021-010300000001', 2, 'Bulgarian Split Squat',  '3', '10',     60, 'high',     'Loaded or bodyweight. RPE 8. Controlled descent.'),
  ('00000000-0000-0000-0021-010300000001', 3, 'DB Romanian Deadlift',   '3', '12',     60, 'moderate', 'Full hip hinge. Hamstrings loaded throughout.'),
  ('00000000-0000-0000-0021-010300000001', 4, 'Squat Jump',             '3', '8',      45, 'high',     'Power output. Max height. Quiet landing.'),
  ('00000000-0000-0000-0021-010300000001', 5, 'DB Hip Thrust',          '3', '12',     45, 'moderate', 'Squeeze hard at top. 2s hold. Glutes are power.'),
  ('00000000-0000-0000-0021-010300000001', 6, 'Pallof Press',           '3', '10',     30, 'moderate', 'Anti-rotation core. Brace and press.');

-- Lion General Day 2 — Upper Power
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010300000002', 1, 'Explosive Push-Up',      '4', '8',      45, 'high',     'Push off floor every rep. Max speed intent.'),
  ('00000000-0000-0000-0021-010300000002', 2, 'DB Push Press',          '3', '8',      60, 'high',     'Leg drive + press. Lockout each rep.'),
  ('00000000-0000-0000-0021-010300000002', 3, '1-Arm DB Row',           '3', '10',     60, 'moderate', 'Control the pull. Elbow back and up.'),
  ('00000000-0000-0000-0021-010300000002', 4, 'DB Floor Press',         '3', '12',     60, 'moderate', '3s eccentric. Full lockout. RPE 8.'),
  ('00000000-0000-0000-0021-010300000002', 5, 'Push-Up to T Rotation',  '3', '10',     30, 'moderate', '5 each side. Rotate fully, arm to sky.'),
  ('00000000-0000-0000-0021-010300000002', 6, 'DB Farmers Carry',       '2', '30m',    45, 'moderate', 'Grip and grit. Walk tall and fast.');

-- Lion General Day 3 — Conditioning + Core
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010300000003', 1, 'Burpee',                 '4', '8',      30, 'high',     'Full effort every rep. Chest to floor.'),
  ('00000000-0000-0000-0021-010300000003', 2, 'Mountain Climbers',      '3', '30 sec', 20, 'high',     'Fast knees. Hips level.'),
  ('00000000-0000-0000-0021-010300000003', 3, 'Split Squat Jump',       '3', '8',      30, 'high',     'Metabolic finisher. No coasting.'),
  ('00000000-0000-0000-0021-010300000003', 4, 'Dead Bug',               '3', '10',     30, 'moderate', '5 each side. Control the lower back.'),
  ('00000000-0000-0000-0021-010300000003', 5, 'Pallof Press',           '3', '12',     30, 'moderate', 'Breath out on press. Hold 2s.'),
  ('00000000-0000-0000-0021-010300000003', 6, 'Plank',                  '3', '45 sec', 30, 'moderate', 'Steady. Breathe. Hold the tension.');

-- Lion General Day 4 — Full Body + Mobility
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-010300000004', 1, 'DB Goblet Squat',        '3', '12',     45, 'moderate', 'Full depth. Chest tall. Controlled.'),
  ('00000000-0000-0000-0021-010300000004', 2, 'Explosive Push-Up',      '3', '8',      45, 'high',     'Close the week with power.'),
  ('00000000-0000-0000-0021-010300000004', 3, 'DB Romanian Deadlift',   '3', '10',     45, 'moderate', 'Hamstring focus. Slow and loaded.'),
  ('00000000-0000-0000-0021-010300000004', 4, 'World''s Greatest Stretch', '2', '6',  15, 'low',      '3 each side. Lunge, rotate, reach.'),
  ('00000000-0000-0000-0021-010300000004', 5, 'Hip Flexor Stretch',     '2', '60 sec', 15, 'low',      '30s each side. Breathe into the stretch.'),
  ('00000000-0000-0000-0021-010300000004', 6, 'Child''s Pose',          '2', '60 sec', 0,  'low',      'Final reset. Let go.');


-- ════════════════════════════════════════════════════════════
-- 2. GORILLA — Hypertrophy First
--    Split: Upper A (Push) | Lower A | Upper B (Pull) | Lower B
-- ════════════════════════════════════════════════════════════

INSERT INTO training_plans (id, archetype, goal, week_number, name, description, environment) VALUES
  ('00000000-0000-0000-0020-020100000000', 'gorilla', 'fat_loss',    1, 'Gorilla Home Fat Loss — Week 1',    'High-volume upper/lower with short rest. Muscle fuels the furnace.', 'home'),
  ('00000000-0000-0000-0020-020200000000', 'gorilla', 'muscle_gain', 1, 'Gorilla Home Muscle — Week 1',      'Classic upper/lower hypertrophy. Volume, tension, and mechanical drops.', 'home'),
  ('00000000-0000-0000-0020-020300000000', 'gorilla', 'general',     1, 'Gorilla Home General — Week 1',     'Size and strength. Upper/lower structure with balanced intensity.', 'home')
ON CONFLICT ON CONSTRAINT training_plans_archetype_goal_week_number_env_key DO NOTHING;

INSERT INTO training_days (id, training_plan_id, day_number, day_name, focus, notes) VALUES
  ('00000000-0000-0000-0021-020100000001', '00000000-0000-0000-0020-020100000000', 1, 'Day 1', 'Upper Push — Fat Loss',   'Volume push. Short rest = conditioning bonus.'),
  ('00000000-0000-0000-0021-020100000002', '00000000-0000-0000-0020-020100000000', 2, 'Day 2', 'Lower — Fat Loss',        'High-rep legs. Circuit pacing. Burn clean.'),
  ('00000000-0000-0000-0021-020100000003', '00000000-0000-0000-0020-020100000000', 3, 'Day 3', 'Upper Pull — Fat Loss',   'Pull volume + rear delt work. Back builds the physique.'),
  ('00000000-0000-0000-0021-020100000004', '00000000-0000-0000-0020-020100000000', 4, 'Day 4', 'Lower Finisher',          'High-rep lower body. Glutes and hamstrings. Finish strong.'),
  ('00000000-0000-0000-0021-020200000001', '00000000-0000-0000-0020-020200000000', 1, 'Day 1', 'Upper A — Push Strength', 'Mechanical drop sets. Push past failure with form.'),
  ('00000000-0000-0000-0021-020200000002', '00000000-0000-0000-0020-020200000000', 2, 'Day 2', 'Lower A — Squat Pattern', 'Goblet, Bulgarian, hip thrust. Full leg stimulus.'),
  ('00000000-0000-0000-0021-020200000003', '00000000-0000-0000-0020-020200000000', 3, 'Day 3', 'Upper B — Pull Strength', 'Rows, pullover, rear delts. Build the back.'),
  ('00000000-0000-0000-0021-020200000004', '00000000-0000-0000-0020-020200000000', 4, 'Day 4', 'Lower B — Hinge Pattern', 'RDL, split squat, hip thrust variation. Hamstring and glute focus.'),
  ('00000000-0000-0000-0021-020300000001', '00000000-0000-0000-0020-020300000000', 1, 'Day 1', 'Upper Push',              'Compound push volume. Control every rep.'),
  ('00000000-0000-0000-0021-020300000002', '00000000-0000-0000-0020-020300000000', 2, 'Day 2', 'Lower',                   'Squat-dominant lower. Drive volume.'),
  ('00000000-0000-0000-0021-020300000003', '00000000-0000-0000-0020-020300000000', 3, 'Day 3', 'Upper Pull',              'Row and rear delt focus. Build width and thickness.'),
  ('00000000-0000-0000-0021-020300000004', '00000000-0000-0000-0020-020300000000', 4, 'Day 4', 'Lower + Glutes',          'Hip hinge and glute emphasis. Close the week.')
ON CONFLICT DO NOTHING;

-- Gorilla Fat Loss Day 1 — Upper Push
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020100000001', 1, 'Push-Up',                '4', '20',     30, 'high',     'RPE 9 — 1 rep left. Full chest-to-floor range.'),
  ('00000000-0000-0000-0021-020100000001', 2, 'DB Floor Press',         '3', '15',     30, 'high',     'Upper back on floor. 2s eccentric. Short rest = high HR.'),
  ('00000000-0000-0000-0021-020100000001', 3, 'DB Overhead Press',      '3', '12',     30, 'moderate', 'Standing. Brace core. Control descent.'),
  ('00000000-0000-0000-0021-020100000001', 4, 'Diamond Push-Up',        '3', '15',     30, 'moderate', 'Tricep isolation. Elbows track back.'),
  ('00000000-0000-0000-0021-020100000001', 5, 'Pike Push-Up',           '3', '12',     30, 'moderate', 'Hips high. Shoulder press movement pattern.'),
  ('00000000-0000-0000-0021-020100000001', 6, 'Mountain Climbers',      '3', '30 sec', 20, 'high',     'Active rest between sets. HR stays elevated.');

-- Gorilla Fat Loss Day 2 — Lower
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020100000002', 1, 'DB Goblet Squat',        '4', '20',     30, 'high',     'RPE 9. High rep, full depth. Chest tall throughout.'),
  ('00000000-0000-0000-0021-020100000002', 2, 'Bulgarian Split Squat',  '3', '12',     30, 'high',     '6 each leg. Short rest, high burn.'),
  ('00000000-0000-0000-0021-020100000002', 3, 'DB Romanian Deadlift',   '3', '15',     30, 'moderate', 'Full hamstring stretch. Hip hinge controlled.'),
  ('00000000-0000-0000-0021-020100000002', 4, 'DB Hip Thrust',          '3', '20',     30, 'moderate', 'Squeeze hard at top. 2s hold. No rest between sides.'),
  ('00000000-0000-0000-0021-020100000002', 5, 'Walking Lunge',          '3', '20',     30, 'moderate', '10 each leg. Long stride. Knee hovers at floor.'),
  ('00000000-0000-0000-0021-020100000002', 6, 'Jump Squat',             '3', '12',     30, 'high',     'Metabolic finisher. Absorb landing. Full squat depth.');

-- Gorilla Fat Loss Day 3 — Upper Pull
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020100000003', 1, '1-Arm DB Row',           '4', '15',     30, 'high',     'RPE 9. High reps. Elbow drives back and up.'),
  ('00000000-0000-0000-0021-020100000003', 2, 'DB Pullover',            '3', '15',     30, 'moderate', 'Lie on floor. Arms extended overhead, pull to hips. Lats stretch.'),
  ('00000000-0000-0000-0021-020100000003', 3, 'Rear Delt DB Row',       '3', '15',     30, 'moderate', 'Bent over, elbows flare wide. Rear delt target. 2s squeeze.'),
  ('00000000-0000-0000-0021-020100000003', 4, 'DB Bicep Curl',          '3', '15',     30, 'moderate', 'Supinate at top. 2s squeeze. Controlled negative.'),
  ('00000000-0000-0000-0021-020100000003', 5, 'Inverted Row (Table)',   '3', '15',     30, 'moderate', 'Body rigid. Pull chest to table edge. Shoulders packed.'),
  ('00000000-0000-0000-0021-020100000003', 6, 'Superman Hold',          '3', '30 sec', 20, 'low',      'Active recovery. Posterior chain activation.');

-- Gorilla Fat Loss Day 4 — Lower Finisher
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020100000004', 1, 'DB Romanian Deadlift',   '3', '15',     30, 'high',     'High rep hinge. Feel that hamstring stretch.'),
  ('00000000-0000-0000-0021-020100000004', 2, 'DB Hip Thrust',          '3', '20',     30, 'high',     'Glute burnout. 2s squeeze every rep.'),
  ('00000000-0000-0000-0021-020100000004', 3, 'Reverse Lunge',          '3', '16',     30, 'moderate', '8 each leg. Step back, knee hovers, return. Tall posture.'),
  ('00000000-0000-0000-0021-020100000004', 4, 'Glute Bridge',           '3', '25',     20, 'moderate', 'Single leg if possible. Drive through heel.'),
  ('00000000-0000-0000-0021-020100000004', 5, 'Squat Jump',             '3', '10',     30, 'high',     'Finish with explosiveness.'),
  ('00000000-0000-0000-0021-020100000004', 6, 'Plank',                  '3', '45 sec', 30, 'moderate', 'Hold the position. Squeeze abs and glutes.');

-- Gorilla Muscle Gain Day 1 — Upper A Push Strength
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020200000001', 1, 'Push-Up Mechanical Drop Set', '4', '10/10/max', 60, 'high', 'Archer push-up × 10, standard × 10, incline × max. No rest between variations.'),
  ('00000000-0000-0000-0021-020200000001', 2, 'DB Floor Press',         '4', '10',     75, 'high',     'Target RPE 8–9. 3s eccentric. Max load you can control.'),
  ('00000000-0000-0000-0021-020200000001', 3, 'DB Incline Press',       '3', '12',     75, 'moderate', 'Hands on couch or bench angle. Upper chest emphasis.'),
  ('00000000-0000-0000-0021-020200000001', 4, 'DB Overhead Press',      '3', '12',     60, 'moderate', 'Standing or seated. Lock out each rep. RPE 8.'),
  ('00000000-0000-0000-0021-020200000001', 5, 'Diamond Push-Up',        '3', '12',     60, 'moderate', 'Slow negative. Tricep finisher.'),
  ('00000000-0000-0000-0021-020200000001', 6, 'Shoulder Tap Plank',     '3', '20',     45, 'moderate', '10 each side. Hips square. Core anti-rotation.');

-- Gorilla Muscle Gain Day 2 — Lower A Squat Pattern
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020200000002', 1, 'DB Goblet Squat',        '4', '12',     75, 'high',     'Target RPE 8–9. Heaviest DB you have. Full depth, slow up.'),
  ('00000000-0000-0000-0021-020200000002', 2, 'Bulgarian Split Squat',  '4', '10',     75, 'high',     '5 each leg. Add DB weight. Controlled descent.'),
  ('00000000-0000-0000-0021-020200000002', 3, 'DB Hip Thrust',          '3', '12',     60, 'high',     'Load heavy. 2s squeeze at top. Glutes are a muscle — train them.'),
  ('00000000-0000-0000-0021-020200000002', 4, 'Step-Up with DB',        '3', '12',     60, 'moderate', '6 each leg. Drive through heel of top leg. Tall posture.'),
  ('00000000-0000-0000-0021-020200000002', 5, 'Calf Raise',             '3', '20',     30, 'low',      'Single leg if possible. Full ROM. Pause at top.'),
  ('00000000-0000-0000-0021-020200000002', 6, 'Plank',                  '3', '60 sec', 30, 'moderate', 'Core after legs. Ribs down. Full body tension.');

-- Gorilla Muscle Gain Day 3 — Upper B Pull Strength
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020200000003', 1, '1-Arm DB Row',           '4', '10',     75, 'high',     'Target RPE 8–9. Heavy. Elbow to ceiling. 2s hold at top.'),
  ('00000000-0000-0000-0021-020200000003', 2, 'DB Pullover',            '4', '12',     60, 'high',     'Floor lying. Pull through full lat stretch. 3s eccentric.'),
  ('00000000-0000-0000-0021-020200000003', 3, 'Rear Delt DB Row',       '3', '15',     60, 'moderate', 'Elbows wide. 2s squeeze. Rear delts make a back look complete.'),
  ('00000000-0000-0000-0021-020200000003', 4, 'Inverted Row (Table)',   '3', '12',     60, 'moderate', 'Heels on floor or elevated. Body rigid. Pull to chest.'),
  ('00000000-0000-0000-0021-020200000003', 5, 'DB Bicep Curl',          '3', '12',     60, 'moderate', 'Slow descent — 3s. Supinate at top.'),
  ('00000000-0000-0000-0021-020200000003', 6, 'DB Hammer Curl',         '3', '12',     45, 'moderate', 'Neutral grip. Brachialis and forearm development.');

-- Gorilla Muscle Gain Day 4 — Lower B Hinge Pattern
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020200000004', 1, 'DB Romanian Deadlift',   '4', '10',     75, 'high',     'Target RPE 8–9. Max hamstring stretch. Hips drive at top.'),
  ('00000000-0000-0000-0021-020200000004', 2, 'Single-Leg DB RDL',      '3', '10',     60, 'moderate', '5 each leg. Balance challenge + unilateral strength.'),
  ('00000000-0000-0000-0021-020200000004', 3, 'DB Hip Thrust',          '4', '12',     60, 'high',     'Load as heavy as possible. The most effective glute exercise.'),
  ('00000000-0000-0000-0021-020200000004', 4, 'Reverse Lunge with DB',  '3', '12',     60, 'moderate', '6 each leg. Step back controlled. Quad and glute split.'),
  ('00000000-0000-0000-0021-020200000004', 5, 'Glute Bridge',           '3', '20',     30, 'moderate', 'Bodyweight burnout after loaded hip thrust.'),
  ('00000000-0000-0000-0021-020200000004', 6, 'Hollow Body Hold',       '3', '30 sec', 30, 'moderate', 'Core finisher. Lower back to floor. Arms and legs extended.');

-- Gorilla General Days 1–4
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020300000001', 1, 'DB Floor Press',         '4', '12',     60, 'high',     '3s eccentric. RPE 8. Full lockout.'),
  ('00000000-0000-0000-0021-020300000001', 2, 'Push-Up',                '3', '15',     45, 'moderate', 'Volume push after compound. Control the rep.'),
  ('00000000-0000-0000-0021-020300000001', 3, 'DB Overhead Press',      '3', '12',     60, 'moderate', 'Standing. Shoulder stability and strength.'),
  ('00000000-0000-0000-0021-020300000001', 4, 'DB Incline Press',       '3', '12',     60, 'moderate', 'Upper chest. Couch or angled surface.'),
  ('00000000-0000-0000-0021-020300000001', 5, 'Diamond Push-Up',        '3', '12',     45, 'moderate', 'Tricep isolation. Slow negative.'),
  ('00000000-0000-0000-0021-020300000001', 6, 'Plank',                  '3', '45 sec', 30, 'moderate', 'Core after push session. Hold tight.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020300000002', 1, 'DB Goblet Squat',        '4', '15',     60, 'high',     'Deep squat. Heavy. RPE 8.'),
  ('00000000-0000-0000-0021-020300000002', 2, 'Bulgarian Split Squat',  '3', '10',     60, 'high',     '5 each leg. Loaded. Controlled.'),
  ('00000000-0000-0000-0021-020300000002', 3, 'DB Romanian Deadlift',   '3', '12',     60, 'moderate', 'Hip hinge. Feel the stretch.'),
  ('00000000-0000-0000-0021-020300000002', 4, 'DB Hip Thrust',          '3', '15',     45, 'moderate', 'Load it. 2s hold every rep.'),
  ('00000000-0000-0000-0021-020300000002', 5, 'Walking Lunge',          '3', '16',     45, 'moderate', '8 each leg. Knee hovers at floor.'),
  ('00000000-0000-0000-0021-020300000002', 6, 'Glute Bridge',           '3', '20',     30, 'low',      'Bodyweight burnout. Squeeze hard.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020300000003', 1, '1-Arm DB Row',           '4', '12',     60, 'high',     'RPE 8. Pull elbow high. Pause at top.'),
  ('00000000-0000-0000-0021-020300000003', 2, 'DB Pullover',            '3', '12',     60, 'moderate', 'Lat stretch and pull. Full ROM.'),
  ('00000000-0000-0000-0021-020300000003', 3, 'Rear Delt DB Row',       '3', '15',     45, 'moderate', 'Bent over. Elbows wide. 2s squeeze.'),
  ('00000000-0000-0000-0021-020300000003', 4, 'Inverted Row (Table)',   '3', '12',     60, 'moderate', 'Body rigid. Full pull range.'),
  ('00000000-0000-0000-0021-020300000003', 5, 'DB Bicep Curl',          '3', '12',     45, 'moderate', 'Slow negative. Full supination.'),
  ('00000000-0000-0000-0021-020300000003', 6, 'Superman Hold',          '3', '30 sec', 30, 'low',      'Posterior chain. Hold for time.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-020300000004', 1, 'DB Romanian Deadlift',   '4', '12',     60, 'high',     'RPE 8. End the week strong.'),
  ('00000000-0000-0000-0021-020300000004', 2, 'DB Hip Thrust',          '3', '15',     60, 'high',     'Load it. Glutes close the week.'),
  ('00000000-0000-0000-0021-020300000004', 3, 'Reverse Lunge with DB',  '3', '12',     60, 'moderate', '6 each leg. Controlled descent.'),
  ('00000000-0000-0000-0021-020300000004', 4, 'Single-Leg DB RDL',      '3', '10',     45, 'moderate', '5 each leg. Balance and control.'),
  ('00000000-0000-0000-0021-020300000004', 5, 'Glute Bridge',           '3', '20',     30, 'moderate', 'Burnout finish. Hips squeeze at top.'),
  ('00000000-0000-0000-0021-020300000004', 6, 'Hip Flexor Stretch',     '2', '60 sec', 15, 'low',      '30s each side. Earned recovery.');


-- ════════════════════════════════════════════════════════════
-- 3. HAWK — Precision + Unilateral
--    Split: Unilateral Push | Unilateral Lower | Pull + Core | Lower B + Mobility
-- ════════════════════════════════════════════════════════════

INSERT INTO training_plans (id, archetype, goal, week_number, name, description, environment) VALUES
  ('00000000-0000-0000-0020-030100000000', 'hawk', 'fat_loss',    1, 'Hawk Home Fat Loss — Week 1',    'Precise movements + metabolic intervals. No wasted energy.', 'home'),
  ('00000000-0000-0000-0020-030200000000', 'hawk', 'muscle_gain', 1, 'Hawk Home Muscle — Week 1',      'Unilateral hypertrophy. Precision tempo. No imbalances.', 'home'),
  ('00000000-0000-0000-0020-030300000000', 'hawk', 'general',     1, 'Hawk Home General — Week 1',     'Precision movement quality + balanced strength. Skill-based fitness.', 'home')
ON CONFLICT ON CONSTRAINT training_plans_archetype_goal_week_number_env_key DO NOTHING;

INSERT INTO training_days (id, training_plan_id, day_number, day_name, focus, notes) VALUES
  ('00000000-0000-0000-0021-030100000001', '00000000-0000-0000-0020-030100000000', 1, 'Day 1', 'Unilateral Upper Push',     'Tempo push + single-arm press. Quality over quantity.'),
  ('00000000-0000-0000-0021-030100000002', '00000000-0000-0000-0020-030100000000', 2, 'Day 2', 'Unilateral Lower A',        'Step-downs, single-leg hinges. Precision lower body.'),
  ('00000000-0000-0000-0021-030100000003', '00000000-0000-0000-0020-030100000000', 3, 'Day 3', 'Unilateral Upper Pull + Core', 'Single-arm rows and core precision work.'),
  ('00000000-0000-0000-0021-030100000004', '00000000-0000-0000-0020-030100000000', 4, 'Day 4', 'Conditioning + Mobility',   'Interval conditioning meets mobility work.'),
  ('00000000-0000-0000-0021-030200000001', '00000000-0000-0000-0020-030200000000', 1, 'Day 1', 'Unilateral Push Strength',  'Tempo push-ups and half-kneeling press. Perfect reps only.'),
  ('00000000-0000-0000-0021-030200000002', '00000000-0000-0000-0020-030200000000', 2, 'Day 2', 'Unilateral Lower Strength', 'Step-downs, split squat eccentric. Balance and strength.'),
  ('00000000-0000-0000-0021-030200000003', '00000000-0000-0000-0020-030200000000', 3, 'Day 3', 'Unilateral Pull + Core',    '1-arm rows with 2s pause. Anti-rotation core.'),
  ('00000000-0000-0000-0021-030200000004', '00000000-0000-0000-0020-030200000000', 4, 'Day 4', 'Lower B + Mobility',        'Single-leg RDL, hip thrust, mobility circuit.'),
  ('00000000-0000-0000-0021-030300000001', '00000000-0000-0000-0020-030300000000', 1, 'Day 1', 'Upper Push Quality',        'Precision push volume. Every rep has intention.'),
  ('00000000-0000-0000-0021-030300000002', '00000000-0000-0000-0020-030300000000', 2, 'Day 2', 'Lower Precision',           'Unilateral lower body. Balance and control.'),
  ('00000000-0000-0000-0021-030300000003', '00000000-0000-0000-0020-030300000000', 3, 'Day 3', 'Upper Pull + Core',         'Single-arm pull and rotational core.'),
  ('00000000-0000-0000-0021-030300000004', '00000000-0000-0000-0020-030300000000', 4, 'Day 4', 'Full Body + Mobility',      'Balanced full-body session with mobility finisher.')
ON CONFLICT DO NOTHING;

-- Hawk Fat Loss Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030100000001', 1, 'Tempo Push-Up',          '4', '12',     30, 'moderate', '3s down, 1s hold at bottom, 1s up. Every rep counts.'),
  ('00000000-0000-0000-0021-030100000001', 2, 'Half-Kneeling DB Press', '3', '10',     30, 'moderate', 'One knee down. Press one DB. No hip lean. 5 each side.'),
  ('00000000-0000-0000-0021-030100000001', 3, 'Archer Push-Up',         '3', '8',      30, 'moderate', '4 each side. Shift weight to one arm. Full ROM.'),
  ('00000000-0000-0000-0021-030100000001', 4, 'Mountain Climbers',      '3', '30 sec', 20, 'high',     'Controlled speed. Maintain hip level.'),
  ('00000000-0000-0000-0021-030100000001', 5, 'Push-Up to T Rotation',  '3', '10',     30, 'moderate', '5 each side. Rotate fully.'),
  ('00000000-0000-0000-0021-030100000001', 6, 'Plank',                  '3', '45 sec', 30, 'moderate', 'Hawk standard: perfect position or nothing.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030100000002', 1, 'Step-Down (Eccentric)',   '4', '10',     30, 'moderate', '5 each leg. Stand on step, lower heel slowly 5s. Quad control.'),
  ('00000000-0000-0000-0021-030100000002', 2, 'Single-Leg DB RDL',       '3', '10',     30, 'moderate', '5 each leg. Slow hinge. Feel the balance and load.'),
  ('00000000-0000-0000-0021-030100000002', 3, 'Reverse Lunge',           '3', '16',     30, 'moderate', '8 each leg. Controlled descent. Knee hovers.'),
  ('00000000-0000-0000-0021-030100000002', 4, 'DB Hip Thrust',           '3', '15',     30, 'moderate', 'Controlled. 2s hold at top.'),
  ('00000000-0000-0000-0021-030100000002', 5, 'Lateral Lunge',           '3', '12',     30, 'moderate', '6 each side. Sit into the hip. Full range.'),
  ('00000000-0000-0000-0021-030100000002', 6, 'Dead Bug',                '3', '10',     30, 'low',      '5 each side. Lower back to floor. Slow and deliberate.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030100000003', 1, '1-Arm DB Row',            '4', '12',     30, 'moderate', 'Slow pull. 2s hold at top. No swinging.'),
  ('00000000-0000-0000-0021-030100000003', 2, 'Rear Delt DB Row',        '3', '15',     30, 'moderate', 'Bent over. Elbows wide. Precision rearward pull.'),
  ('00000000-0000-0000-0021-030100000003', 3, 'Bird Dog',                '3', '10',     30, 'low',      '5 each side. Opposite arm and leg. Pause 2s at extension.'),
  ('00000000-0000-0000-0021-030100000003', 4, 'Pallof Press',            '3', '12',     30, 'moderate', 'Anti-rotation. Brace, press, hold 2s.'),
  ('00000000-0000-0000-0021-030100000003', 5, 'Dead Bug',                '3', '10',     30, 'low',      '5 each side. Precision core. Low back to floor.'),
  ('00000000-0000-0000-0021-030100000003', 6, 'Side Plank',              '3', '30 sec', 30, 'moderate', 'Lateral chain. Full body alignment. 30s each side.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030100000004', 1, 'Burpee',                  '3', '8',      30, 'high',     'Precise burpee — every rep same form.'),
  ('00000000-0000-0000-0021-030100000004', 2, 'Mountain Climbers',       '3', '30 sec', 20, 'high',     'Keep form tight. No sagging hips.'),
  ('00000000-0000-0000-0021-030100000004', 3, 'High Knees',              '3', '30 sec', 20, 'high',     'Precise knee drive to hip height.'),
  ('00000000-0000-0000-0021-030100000004', 4, 'World''s Greatest Stretch', '2', '8',   15, 'low',      '4 each side. Full reach and rotation.'),
  ('00000000-0000-0000-0021-030100000004', 5, 'Hip Flexor Stretch',      '2', '60 sec', 15, 'low',      '30s each side. Long holds.'),
  ('00000000-0000-0000-0021-030100000004', 6, 'Thoracic Rotation',       '2', '10',     15, 'low',      '5 each side. Seated or lying. Full rotation.');

-- Hawk Muscle Gain Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030200000001', 1, 'Tempo Push-Up',          '4', '10',     75, 'high',     'Target RPE 8. 4s down, 2s pause bottom, 1s up. Perfect every rep.'),
  ('00000000-0000-0000-0021-030200000001', 2, 'Half-Kneeling DB Press', '4', '10',     75, 'moderate', '5 each side. No lateral lean. RPE 8.'),
  ('00000000-0000-0000-0021-030200000001', 3, 'Archer Push-Up',         '3', '8',      60, 'moderate', '4 each side. Shift to near-unilateral. Slow eccentric.'),
  ('00000000-0000-0000-0021-030200000001', 4, 'DB Floor Press',         '3', '12',     60, 'moderate', '3s eccentric. Pause at chest. RPE 8.'),
  ('00000000-0000-0000-0021-030200000001', 5, 'DB Lateral Raise',       '3', '15',     45, 'moderate', 'Controlled. Stop at shoulder height. 2s hold.'),
  ('00000000-0000-0000-0021-030200000001', 6, 'Shoulder Tap Plank',     '3', '20',     45, 'moderate', '10 each side. Perfect hips. No movement compensation.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030200000002', 1, 'Step-Down (Eccentric)',   '4', '10',     75, 'high',     '5 each leg. 5s eccentric. Quad tendon and VMO strength.'),
  ('00000000-0000-0000-0021-030200000002', 2, 'Bulgarian Split Squat',  '4', '8',      75, 'high',     '4 each leg. 3s eccentric. RPE 8–9. Load as able.'),
  ('00000000-0000-0000-0021-030200000002', 3, 'Single-Leg DB RDL',      '3', '10',     60, 'moderate', '5 each leg. Full hip hinge. Balance is the challenge.'),
  ('00000000-0000-0000-0021-030200000002', 4, 'DB Hip Thrust',          '3', '12',     60, 'moderate', 'Load heavy. 2s hold at top.'),
  ('00000000-0000-0000-0021-030200000002', 5, 'Reverse Lunge with DB',  '3', '12',     60, 'moderate', '6 each leg. Full control.'),
  ('00000000-0000-0000-0021-030200000002', 6, 'Dead Bug',               '3', '10',     45, 'low',      'Precision core. Low back flat. 5 each side. Slow.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030200000003', 1, '1-Arm DB Row',           '4', '10',     75, 'high',     'Target RPE 8. Pull with 2s pause at top. No body swing.'),
  ('00000000-0000-0000-0021-030200000003', 2, 'Rear Delt DB Row',       '3', '12',     60, 'moderate', '2s squeeze. Elbows wide. Rear delts balance the shoulder.'),
  ('00000000-0000-0000-0021-030200000003', 3, 'Bird Dog',               '3', '10',     45, 'low',      '5 each side. 3s hold at extension. Perfect alignment.'),
  ('00000000-0000-0000-0021-030200000003', 4, 'Pallof Press',           '3', '12',     45, 'moderate', '2s hold each rep. Brace before you press.'),
  ('00000000-0000-0000-0021-030200000003', 5, 'Side Plank',             '3', '45 sec', 45, 'moderate', 'Full body alignment. Hips up. 45s each side.'),
  ('00000000-0000-0000-0021-030200000003', 6, 'Dead Bug',               '3', '10',     30, 'low',      'Cooldown core. Slow and deliberate.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030200000004', 1, 'Single-Leg DB RDL',      '4', '10',     75, 'moderate', '5 each leg. Balance and load. Control every rep.'),
  ('00000000-0000-0000-0021-030200000004', 2, 'DB Hip Thrust',          '3', '12',     60, 'high',     'Full load. Hip extension at end range.'),
  ('00000000-0000-0000-0021-030200000004', 3, 'Reverse Lunge with DB',  '3', '12',     60, 'moderate', '6 each leg. Precision descent.'),
  ('00000000-0000-0000-0021-030200000004', 4, 'World''s Greatest Stretch', '2', '8',  15, 'low',      '4 each side. Full mobility circuit.'),
  ('00000000-0000-0000-0021-030200000004', 5, 'Pigeon Pose',            '2', '60 sec', 15, 'low',      '30s each side. Hip external rotation.'),
  ('00000000-0000-0000-0021-030200000004', 6, 'Thoracic Rotation',      '2', '10',     15, 'low',      '5 each side. Recover the spine.');

-- Hawk General Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030300000001', 1, 'Tempo Push-Up',          '3', '12',     60, 'moderate', '3s down. RPE 8. Quality reps.'),
  ('00000000-0000-0000-0021-030300000001', 2, 'Half-Kneeling DB Press', '3', '10',     60, 'moderate', '5 each side. Stable base.'),
  ('00000000-0000-0000-0021-030300000001', 3, 'DB Floor Press',         '3', '12',     60, 'moderate', '3s eccentric. Full lockout.'),
  ('00000000-0000-0000-0021-030300000001', 4, 'Push-Up to T Rotation',  '3', '10',     45, 'moderate', '5 each side. Full rotation.'),
  ('00000000-0000-0000-0021-030300000001', 5, 'Shoulder Tap Plank',     '3', '20',     30, 'moderate', '10 each side. Hips square.'),
  ('00000000-0000-0000-0021-030300000001', 6, 'Plank',                  '3', '45 sec', 30, 'moderate', 'Hold. Breathe. Squeeze.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030300000002', 1, 'Step-Down (Eccentric)',   '3', '10',     60, 'moderate', '5 each leg. Slow 5s eccentric.'),
  ('00000000-0000-0000-0021-030300000002', 2, 'Single-Leg DB RDL',       '3', '10',     60, 'moderate', '5 each leg. Control the balance.'),
  ('00000000-0000-0000-0021-030300000002', 3, 'Reverse Lunge',           '3', '16',     45, 'moderate', '8 each leg. Precise.'),
  ('00000000-0000-0000-0021-030300000002', 4, 'DB Hip Thrust',           '3', '12',     45, 'moderate', 'Load and hold 2s.'),
  ('00000000-0000-0000-0021-030300000002', 5, 'Dead Bug',                '3', '10',     30, 'low',      '5 each side. Perfect form.'),
  ('00000000-0000-0000-0021-030300000002', 6, 'Bird Dog',                '3', '10',     30, 'low',      '5 each side. Pause at extension.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030300000003', 1, '1-Arm DB Row',            '3', '12',     60, 'moderate', '2s pause at top. Controlled pull.'),
  ('00000000-0000-0000-0021-030300000003', 2, 'Rear Delt DB Row',        '3', '15',     45, 'moderate', 'Elbows wide. 2s squeeze.'),
  ('00000000-0000-0000-0021-030300000003', 3, 'Pallof Press',            '3', '12',     45, 'moderate', 'Hold 2s. Breath out on press.'),
  ('00000000-0000-0000-0021-030300000003', 4, 'Bird Dog',                '3', '10',     30, 'low',      'Precision. Extend and hold.'),
  ('00000000-0000-0000-0021-030300000003', 5, 'Side Plank',              '3', '30 sec', 30, 'moderate', '30s each side. Hips high.'),
  ('00000000-0000-0000-0021-030300000003', 6, 'Dead Bug',                '3', '10',     30, 'low',      'Cooldown core. Slow.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-030300000004', 1, 'DB Goblet Squat',         '3', '12',     45, 'moderate', 'Full depth. Quality reps.'),
  ('00000000-0000-0000-0021-030300000004', 2, '1-Arm DB Row',            '3', '12',     45, 'moderate', 'Precision pull.'),
  ('00000000-0000-0000-0021-030300000004', 3, 'Tempo Push-Up',           '3', '10',     45, 'moderate', '3s eccentric. Controlled.'),
  ('00000000-0000-0000-0021-030300000004', 4, 'World''s Greatest Stretch', '2', '6',   15, 'low',      '3 each side. Full mobility.'),
  ('00000000-0000-0000-0021-030300000004', 5, 'Hip Flexor Stretch',      '2', '60 sec', 15, 'low',      '30s each side.'),
  ('00000000-0000-0000-0021-030300000004', 6, 'Pigeon Pose',             '2', '60 sec', 0,  'low',      '30s each side. Final reset.');


-- ════════════════════════════════════════════════════════════
-- 4. WOLF — Concurrent Strength + Conditioning
--    Split: Strength Upper | Conditioning Lower | Strength Lower | Conditioning Full
-- ════════════════════════════════════════════════════════════

INSERT INTO training_plans (id, archetype, goal, week_number, name, description, environment) VALUES
  ('00000000-0000-0000-0020-040100000000', 'wolf', 'fat_loss',    1, 'Wolf Home Fat Loss — Week 1',    'Concurrent training: alternating strength and conditioning to burn fat and build capacity.', 'home'),
  ('00000000-0000-0000-0020-040200000000', 'wolf', 'muscle_gain', 1, 'Wolf Home Muscle — Week 1',      'Strength-biased concurrent training. Build muscle while maintaining conditioning.', 'home'),
  ('00000000-0000-0000-0020-040300000000', 'wolf', 'general',     1, 'Wolf Home General — Week 1',     'Strength and conditioning balanced. The Wolf thrives on both.', 'home')
ON CONFLICT ON CONSTRAINT training_plans_archetype_goal_week_number_env_key DO NOTHING;

INSERT INTO training_days (id, training_plan_id, day_number, day_name, focus, notes) VALUES
  ('00000000-0000-0000-0021-040100000001', '00000000-0000-0000-0020-040100000000', 1, 'Day 1', 'Strength Upper',         'Compound push and pull. Strength base with metabolic finish.'),
  ('00000000-0000-0000-0021-040100000002', '00000000-0000-0000-0020-040100000000', 2, 'Day 2', 'Conditioning Lower',     'Lower-body circuit. Metabolic. Short rest. High output.'),
  ('00000000-0000-0000-0021-040100000003', '00000000-0000-0000-0020-040100000000', 3, 'Day 3', 'Strength Lower',         'Loaded lower body. Build base strength.'),
  ('00000000-0000-0000-0021-040100000004', '00000000-0000-0000-0020-040100000000', 4, 'Day 4', 'Full Body Conditioning', 'Full output. Carries, circuits, finisher.'),
  ('00000000-0000-0000-0021-040200000001', '00000000-0000-0000-0020-040200000000', 1, 'Day 1', 'Strength Upper',         'Push and pull compounds. Heavy base.'),
  ('00000000-0000-0000-0021-040200000002', '00000000-0000-0000-0020-040200000000', 2, 'Day 2', 'Conditioning Lower',     'Lower-body conditioning. Capacity building.'),
  ('00000000-0000-0000-0021-040200000003', '00000000-0000-0000-0020-040200000000', 3, 'Day 3', 'Strength Lower',         'Squat and hinge loaded. Muscle over conditioning today.'),
  ('00000000-0000-0000-0021-040200000004', '00000000-0000-0000-0020-040200000000', 4, 'Day 4', 'Full Body + Carries',    'Strength + loaded carries. The Wolf does not have a weak link.'),
  ('00000000-0000-0000-0021-040300000001', '00000000-0000-0000-0020-040300000000', 1, 'Day 1', 'Strength Upper',         'Upper body compound strength. Even balance.'),
  ('00000000-0000-0000-0021-040300000002', '00000000-0000-0000-0020-040300000000', 2, 'Day 2', 'Lower Conditioning',     'Metabolic lower. No stopping.'),
  ('00000000-0000-0000-0021-040300000003', '00000000-0000-0000-0020-040300000000', 3, 'Day 3', 'Strength Lower',         'Loaded lower body. Build strength.'),
  ('00000000-0000-0000-0021-040300000004', '00000000-0000-0000-0020-040300000000', 4, 'Day 4', 'Full Body + Carries',    'End of week full output.')
ON CONFLICT DO NOTHING;

-- Wolf Fat Loss Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040100000001', 1, 'DB Floor Press',         '4', '10',     45, 'high',     'RPE 8. Compound upper push. 3s eccentric.'),
  ('00000000-0000-0000-0021-040100000001', 2, '1-Arm DB Row',           '4', '10',     45, 'high',     'Pair with press. Pull volume matches push.'),
  ('00000000-0000-0000-0021-040100000001', 3, 'DB Overhead Press',      '3', '12',     30, 'moderate', 'Short rest — conditioning element.'),
  ('00000000-0000-0000-0021-040100000001', 4, 'Push-Up',                '3', '15',     30, 'moderate', 'RPE 9. Volume finisher.'),
  ('00000000-0000-0000-0021-040100000001', 5, 'Mountain Climbers',      '3', '30 sec', 20, 'high',     'Conditioning finish. Drive knees.'),
  ('00000000-0000-0000-0021-040100000001', 6, 'Pallof Press',           '3', '12',     30, 'moderate', 'Anti-rotation. Brace and press.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040100000002', 1, 'DB Goblet Squat',        '4', '15',     20, 'high',     'Fast circuit. No long rest. High output.'),
  ('00000000-0000-0000-0021-040100000002', 2, 'Split Squat',            '4', '12',     20, 'high',     '6 each leg. Back foot on ground. Drive up.'),
  ('00000000-0000-0000-0021-040100000002', 3, 'DB Romanian Deadlift',   '3', '12',     20, 'high',     'Hip hinge. Stay smooth under fatigue.'),
  ('00000000-0000-0000-0021-040100000002', 4, 'DB Hip Thrust',          '3', '15',     20, 'moderate', 'Controlled even at high reps.'),
  ('00000000-0000-0000-0021-040100000002', 5, 'Jump Squat',             '3', '10',     30, 'high',     'Explosive finisher. Full depth.'),
  ('00000000-0000-0000-0021-040100000002', 6, 'Band Lateral Walk',      '3', '20 steps', 20, 'moderate', 'Band above knees. Hips level. Glute med activation.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040100000003', 1, 'Bulgarian Split Squat',  '4', '10',     45, 'high',     'RPE 8. Load as able. 4 each leg.'),
  ('00000000-0000-0000-0021-040100000003', 2, 'DB Romanian Deadlift',   '4', '10',     45, 'high',     'RPE 8. Hamstring strength.'),
  ('00000000-0000-0000-0021-040100000003', 3, 'DB Goblet Squat',        '3', '12',     30, 'moderate', 'Metabolic element. Short rest.'),
  ('00000000-0000-0000-0021-040100000003', 4, 'DB Hip Thrust',          '3', '15',     30, 'moderate', 'Glute load.'),
  ('00000000-0000-0000-0021-040100000003', 5, 'DB Suitcase Carry',      '3', '30m',    45, 'moderate', 'Walk tall. Resist lateral lean.'),
  ('00000000-0000-0000-0021-040100000003', 6, 'Pallof Press',           '3', '12',     30, 'moderate', 'Anti-rotation. Core stability.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040100000004', 1, 'Burpee',                 '4', '10',     20, 'high',     'Full body. Full effort. No coasting.'),
  ('00000000-0000-0000-0021-040100000004', 2, 'DB Farmers Carry',       '3', '30m',    45, 'high',     'Go heavy. Grip and posture.'),
  ('00000000-0000-0000-0021-040100000004', 3, 'Push-Up',                '3', '15',     20, 'high',     'RPE 9. No stopping.'),
  ('00000000-0000-0000-0021-040100000004', 4, 'Jump Squat',             '3', '10',     20, 'high',     'Finish strong. Plyometric power.'),
  ('00000000-0000-0000-0021-040100000004', 5, 'Mountain Climbers',      '3', '30 sec', 20, 'high',     'Drive hard. Final conditioning push.'),
  ('00000000-0000-0000-0021-040100000004', 6, 'Plank',                  '3', '60 sec', 30, 'moderate', 'Core cooldown. Tight and controlled.');

-- Wolf Muscle Gain Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040200000001', 1, 'DB Floor Press',         '4', '10',     75, 'high',     'RPE 8–9. 3s eccentric. Heaviest load.'),
  ('00000000-0000-0000-0021-040200000001', 2, '1-Arm DB Row',           '4', '10',     75, 'high',     'Match push volume. Elbow to ceiling.'),
  ('00000000-0000-0000-0021-040200000001', 3, 'DB Overhead Press',      '3', '10',     60, 'moderate', 'Strength-focused press. Controlled.'),
  ('00000000-0000-0000-0021-040200000001', 4, 'Push-Up',                '3', '15',     45, 'moderate', 'Volume add-on. RPE 8.'),
  ('00000000-0000-0000-0021-040200000001', 5, 'Rear Delt DB Row',       '3', '12',     45, 'moderate', 'Elbows wide. 2s squeeze.'),
  ('00000000-0000-0000-0021-040200000001', 6, 'Pallof Press',           '3', '12',     45, 'moderate', 'Core stability.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040200000002', 1, 'DB Goblet Squat',        '4', '15',     30, 'high',     'Conditioning pacing. Short rest throughout.'),
  ('00000000-0000-0000-0021-040200000002', 2, 'Split Squat',            '3', '12',     30, 'high',     '6 each leg. Power through fatigue.'),
  ('00000000-0000-0000-0021-040200000002', 3, 'DB Romanian Deadlift',   '3', '15',     30, 'moderate', 'High rep hinge. Stay smooth.'),
  ('00000000-0000-0000-0021-040200000002', 4, 'Band Lateral Walk',      '3', '20 steps', 20, 'moderate', 'Glute med. Hips level.'),
  ('00000000-0000-0000-0021-040200000002', 5, 'Jump Squat',             '3', '8',      30, 'high',     'Power output.'),
  ('00000000-0000-0000-0021-040200000002', 6, 'DB Suitcase Carry',      '2', '30m',    30, 'moderate', 'Conditioning finisher. Go.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040200000003', 1, 'Bulgarian Split Squat',  '4', '8',      75, 'high',     'RPE 8–9. Strength focus today. Load heavy.'),
  ('00000000-0000-0000-0021-040200000003', 2, 'DB Romanian Deadlift',   '4', '10',     75, 'high',     'Hamstring strength. Max load.'),
  ('00000000-0000-0000-0021-040200000003', 3, 'DB Goblet Squat',        '3', '12',     60, 'high',     'Quad burnout. RPE 8.'),
  ('00000000-0000-0000-0021-040200000003', 4, 'DB Hip Thrust',          '4', '12',     60, 'high',     'Load the glutes. 2s hold.'),
  ('00000000-0000-0000-0021-040200000003', 5, 'Step-Up with DB',        '3', '12',     45, 'moderate', '6 each leg. Drive through heel.'),
  ('00000000-0000-0000-0021-040200000003', 6, 'Pallof Press',           '3', '12',     45, 'moderate', 'Core after legs. Anti-rotation.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040200000004', 1, 'DB Farmers Carry',       '4', '30m',    60, 'high',     'Heavy. Grip + posture. Walk 15m, switch, 15m back.'),
  ('00000000-0000-0000-0021-040200000004', 2, 'DB Front Rack Carry',    '3', '30m',    60, 'high',     'DBs at shoulders. Core braced. Tall.'),
  ('00000000-0000-0000-0021-040200000004', 3, 'DB Goblet Squat',        '3', '12',     60, 'moderate', 'Strength carry finisher.'),
  ('00000000-0000-0000-0021-040200000004', 4, 'Push-Up',                '3', '15',     45, 'moderate', 'Upper body after carries.'),
  ('00000000-0000-0000-0021-040200000004', 5, 'Plank',                  '3', '60 sec', 30, 'moderate', 'Core close.'),
  ('00000000-0000-0000-0021-040200000004', 6, 'Hip Flexor Stretch',     '2', '60 sec', 15, 'low',      'Earned stretch. 30s each side.');

-- Wolf General Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040300000001', 1, 'DB Floor Press',         '4', '12',     60, 'high',     'Strength compound. 3s eccentric.'),
  ('00000000-0000-0000-0021-040300000001', 2, '1-Arm DB Row',           '4', '12',     60, 'high',     'Pull volume matches push.'),
  ('00000000-0000-0000-0021-040300000001', 3, 'DB Overhead Press',      '3', '10',     60, 'moderate', 'Press strong. Control the rep.'),
  ('00000000-0000-0000-0021-040300000001', 4, 'Push-Up',                '3', '15',     30, 'moderate', 'Volume finisher.'),
  ('00000000-0000-0000-0021-040300000001', 5, 'Pallof Press',           '3', '12',     30, 'moderate', 'Anti-rotation core.'),
  ('00000000-0000-0000-0021-040300000001', 6, 'Plank',                  '3', '45 sec', 30, 'moderate', 'Core close.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040300000002', 1, 'DB Goblet Squat',        '4', '15',     30, 'high',     'High output. Short rest.'),
  ('00000000-0000-0000-0021-040300000002', 2, 'Split Squat',            '3', '12',     30, 'high',     '6 each leg. Burn through.'),
  ('00000000-0000-0000-0021-040300000002', 3, 'DB Romanian Deadlift',   '3', '12',     30, 'moderate', 'Hinge. Feel the load.'),
  ('00000000-0000-0000-0021-040300000002', 4, 'DB Hip Thrust',          '3', '15',     30, 'moderate', 'Glutes. 2s hold.'),
  ('00000000-0000-0000-0021-040300000002', 5, 'Band Lateral Walk',      '3', '20 steps', 20, 'moderate', 'Glute med activation.'),
  ('00000000-0000-0000-0021-040300000002', 6, 'Jump Squat',             '3', '8',      30, 'high',     'Explosive finish.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040300000003', 1, 'Bulgarian Split Squat',  '4', '10',     60, 'high',     'Loaded. RPE 8.'),
  ('00000000-0000-0000-0021-040300000003', 2, 'DB Romanian Deadlift',   '4', '12',     60, 'high',     'Hamstring strength.'),
  ('00000000-0000-0000-0021-040300000003', 3, 'DB Goblet Squat',        '3', '12',     45, 'moderate', 'Quad volume.'),
  ('00000000-0000-0000-0021-040300000003', 4, 'DB Hip Thrust',          '3', '15',     45, 'moderate', 'Glute strength.'),
  ('00000000-0000-0000-0021-040300000003', 5, 'DB Suitcase Carry',      '3', '30m',    45, 'moderate', 'Load up. Walk tall.'),
  ('00000000-0000-0000-0021-040300000003', 6, 'Pallof Press',           '3', '12',     30, 'moderate', 'Core close.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-040300000004', 1, 'DB Farmers Carry',       '3', '30m',    60, 'high',     'Go heavy. Full posture.'),
  ('00000000-0000-0000-0021-040300000004', 2, 'DB Front Rack Carry',    '3', '30m',    60, 'high',     'Shoulders. Core. Walk.'),
  ('00000000-0000-0000-0021-040300000004', 3, 'Push-Up',                '3', '15',     30, 'moderate', 'Volume upper finish.'),
  ('00000000-0000-0000-0021-040300000004', 4, 'Mountain Climbers',      '3', '30 sec', 20, 'high',     'Conditioning. Drive.'),
  ('00000000-0000-0000-0021-040300000004', 5, 'Plank',                  '3', '45 sec', 30, 'moderate', 'Core close.'),
  ('00000000-0000-0000-0021-040300000004', 6, 'Hip Flexor Stretch',     '2', '60 sec', 0,  'low',      '30s each side. Recover.');


-- ════════════════════════════════════════════════════════════
-- 5. PANTHER — Tension-Based Hypertrophy
--    Split: Upper A | Lower A | Upper B | Lower B + Glutes
-- ════════════════════════════════════════════════════════════

INSERT INTO training_plans (id, archetype, goal, week_number, name, description, environment) VALUES
  ('00000000-0000-0000-0020-050100000000', 'panther', 'fat_loss',    1, 'Panther Home Fat Loss — Week 1',    'Slow eccentrics and tempo training that maximizes tension and burns fat efficiently.', 'home'),
  ('00000000-0000-0000-0020-050200000000', 'panther', 'muscle_gain', 1, 'Panther Home Muscle — Week 1',      'Tension-based upper/lower hypertrophy. Slow eccentrics, pauses, maximum muscle time under tension.', 'home'),
  ('00000000-0000-0000-0020-050300000000', 'panther', 'general',     1, 'Panther Home General — Week 1',     'Controlled tension-based training. Every rep earns its place.', 'home')
ON CONFLICT ON CONSTRAINT training_plans_archetype_goal_week_number_env_key DO NOTHING;

INSERT INTO training_days (id, training_plan_id, day_number, day_name, focus, notes) VALUES
  ('00000000-0000-0000-0021-050100000001', '00000000-0000-0000-0020-050100000000', 1, 'Day 1', 'Upper Push — Tension',      'Slow eccentrics, pause reps. Short rest to maintain metabolic burn.'),
  ('00000000-0000-0000-0021-050100000002', '00000000-0000-0000-0020-050100000000', 2, 'Day 2', 'Lower — Slow Eccentric',     'Every rep is 3–5 seconds on the way down.'),
  ('00000000-0000-0000-0021-050100000003', '00000000-0000-0000-0020-050100000000', 3, 'Day 3', 'Upper Pull — Isometric Hold', 'Pull and pause. 2s holds build thickness.'),
  ('00000000-0000-0000-0021-050100000004', '00000000-0000-0000-0020-050100000000', 4, 'Day 4', 'Lower B + Glutes',            'Hip dominant lower. Band work and hip thrust to finish.'),
  ('00000000-0000-0000-0021-050200000001', '00000000-0000-0000-0020-050200000000', 1, 'Day 1', 'Upper A — Push Tension',     '4s eccentric. Pause at bottom. Maximum chest and shoulder tension.'),
  ('00000000-0000-0000-0021-050200000002', '00000000-0000-0000-0020-050200000000', 2, 'Day 2', 'Lower A — Slow Eccentric',   '4s eccentric on all lower movements. Feel every degree of range.'),
  ('00000000-0000-0000-0021-050200000003', '00000000-0000-0000-0020-050200000000', 3, 'Day 3', 'Upper B — Isometrics',       'Pause reps throughout. Rear delts, rows, holds.'),
  ('00000000-0000-0000-0021-050200000004', '00000000-0000-0000-0020-050200000000', 4, 'Day 4', 'Lower B + Glutes',           'Hip thrust, band work, single-leg RDL. Complete glute development.'),
  ('00000000-0000-0000-0021-050300000001', '00000000-0000-0000-0020-050300000000', 1, 'Day 1', 'Upper Push Tension',         'Tempo upper push. Earn every rep.'),
  ('00000000-0000-0000-0021-050300000002', '00000000-0000-0000-0020-050300000000', 2, 'Day 2', 'Lower Slow Eccentric',       '3s eccentric on all lower movements.'),
  ('00000000-0000-0000-0021-050300000003', '00000000-0000-0000-0020-050300000000', 3, 'Day 3', 'Upper Pull',                 'Pull with pauses. Rear chain.'),
  ('00000000-0000-0000-0021-050300000004', '00000000-0000-0000-0020-050300000000', 4, 'Day 4', 'Lower B + Glutes + Mobility', 'Hip work, glutes, and mobility close out the week.')
ON CONFLICT DO NOTHING;

-- Panther Fat Loss Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050100000001', 1, 'Tempo Push-Up',              '4', '12', 30, 'high',     '4s down, 1s pause bottom. RPE 9. Short rest.'),
  ('00000000-0000-0000-0021-050100000001', 2, 'DB Floor Press with Pause',  '3', '10', 30, 'high',     '4s eccentric, 2s pause at chest. Maximize tension.'),
  ('00000000-0000-0000-0021-050100000001', 3, 'DB Overhead Press',          '3', '12', 30, 'moderate', 'Controlled descent. No bounce.'),
  ('00000000-0000-0000-0021-050100000001', 4, 'Diamond Push-Up',            '3', '12', 30, 'moderate', '3s eccentric. Tricep tension.'),
  ('00000000-0000-0000-0021-050100000001', 5, 'Hollow Hold',                '3', '30 sec', 20, 'moderate', 'Lower back to floor. Arms and legs extended. Full tension.'),
  ('00000000-0000-0000-0021-050100000001', 6, 'Side Plank',                 '3', '30 sec', 20, 'moderate', '30s each side. Perfect body line.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050100000002', 1, 'Split Squat Eccentric',      '4', '10', 30, 'high',     '5s eccentric each rep. RPE 8. Slow and controlled. 5 each leg.'),
  ('00000000-0000-0000-0021-050100000002', 2, 'Bulgarian Split Squat',      '3', '10', 30, 'high',     '4s eccentric. Loaded if possible. Short rest.'),
  ('00000000-0000-0000-0021-050100000002', 3, 'DB Romanian Deadlift',       '3', '12', 30, 'moderate', '3s eccentric. Full hamstring stretch.'),
  ('00000000-0000-0000-0021-050100000002', 4, 'DB Hip Thrust',              '3', '15', 20, 'moderate', '2s hold at top every rep.'),
  ('00000000-0000-0000-0021-050100000002', 5, 'Band Hip Abduction',         '3', '20', 20, 'moderate', 'Seated or lying. Drive knees out. 2s hold.'),
  ('00000000-0000-0000-0021-050100000002', 6, 'Hollow Hold',                '3', '30 sec', 20, 'moderate', 'Core tension. Hold the position.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050100000003', 1, '1-Arm DB Row',               '4', '12', 30, 'high',     '2s pause at top. Control the pull. No swinging.'),
  ('00000000-0000-0000-0021-050100000003', 2, 'Rear Delt DB Row',           '3', '15', 30, 'moderate', '3s eccentric. 2s squeeze. Elbows wide.'),
  ('00000000-0000-0000-0021-050100000003', 3, 'DB Pullover',                '3', '12', 30, 'moderate', 'Full lat stretch. 3s eccentric.'),
  ('00000000-0000-0000-0021-050100000003', 4, 'Side Plank',                 '3', '30 sec', 20, 'moderate', '30s each side.'),
  ('00000000-0000-0000-0021-050100000003', 5, 'Pallof Press',               '3', '12', 20, 'moderate', '2s hold each rep.'),
  ('00000000-0000-0000-0021-050100000003', 6, 'Hollow Hold',                '3', '25 sec', 20, 'moderate', 'Fatigue-based hold. Hold position as long as form holds.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050100000004', 1, 'DB Hip Thrust',              '4', '15', 20, 'high',     '2s hold at top. High volume for fat loss.'),
  ('00000000-0000-0000-0021-050100000004', 2, 'Band Hip Abduction',         '3', '20', 20, 'moderate', 'Drive knees out. 2s hold.'),
  ('00000000-0000-0000-0021-050100000004', 3, 'Single-Leg DB RDL',          '3', '10', 30, 'moderate', '5 each leg. Slow eccentric.'),
  ('00000000-0000-0000-0021-050100000004', 4, 'Glute Bridge',               '3', '25', 15, 'moderate', 'Burnout. 2s hold each rep.'),
  ('00000000-0000-0000-0021-050100000004', 5, 'Side Plank',                 '3', '30 sec', 20, 'moderate', 'Lateral stability finisher.'),
  ('00000000-0000-0000-0021-050100000004', 6, 'Hollow Hold',                '2', '30 sec', 30, 'moderate', 'Final core hold. Full body tension.');

-- Panther Muscle Gain Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050200000001', 1, 'Tempo Push-Up',              '4', '10', 75, 'high',     'Target RPE 8. 4s down, 2s pause, 1s up. Every rep perfect.'),
  ('00000000-0000-0000-0021-050200000001', 2, 'DB Floor Press with Pause',  '4', '10', 75, 'high',     '4s eccentric, 2s pause at chest. Max time under tension. RPE 8.'),
  ('00000000-0000-0000-0021-050200000001', 3, 'DB Overhead Press',          '3', '12', 60, 'moderate', '3s eccentric. Shoulder stability and strength.'),
  ('00000000-0000-0000-0021-050200000001', 4, 'Diamond Push-Up',            '3', '10', 60, 'moderate', '4s eccentric. Tricep hypertrophy.'),
  ('00000000-0000-0000-0021-050200000001', 5, 'DB Lateral Raise',           '3', '15', 45, 'moderate', '2s hold at shoulder height. Lateral head.'),
  ('00000000-0000-0000-0021-050200000001', 6, 'Hollow Hold',                '3', '30 sec', 45, 'moderate', 'Core hypertrophy. Anterior chain tension.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050200000002', 1, 'Split Squat Eccentric',      '4', '8',  75, 'high',     'Target RPE 8. 5s eccentric. 4 each leg. Load as able.'),
  ('00000000-0000-0000-0021-050200000002', 2, 'Bulgarian Split Squat',      '4', '8',  75, 'high',     '4s eccentric. Heavy. RPE 8–9. 4 each leg.'),
  ('00000000-0000-0000-0021-050200000002', 3, 'DB Romanian Deadlift',       '3', '10', 60, 'high',     '4s eccentric. Max hamstring stretch.'),
  ('00000000-0000-0000-0021-050200000002', 4, 'DB Hip Thrust',              '4', '12', 60, 'high',     'Load heavy. 2s hold every rep.'),
  ('00000000-0000-0000-0021-050200000002', 5, 'Band Hip Abduction',         '3', '20', 45, 'moderate', 'Glute med finisher. 2s hold each rep.'),
  ('00000000-0000-0000-0021-050200000002', 6, 'Side Plank',                 '3', '45 sec', 45, 'moderate', 'Lateral hypertrophy. Hold tight. 45s each side.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050200000003', 1, '1-Arm DB Row',               '4', '10', 75, 'high',     'Target RPE 8. 4s eccentric, 2s hold at top.'),
  ('00000000-0000-0000-0021-050200000003', 2, 'Rear Delt DB Row',           '4', '12', 60, 'moderate', '3s eccentric. 2s squeeze. Rear delt hypertrophy.'),
  ('00000000-0000-0000-0021-050200000003', 3, 'DB Pullover',                '3', '12', 60, 'moderate', '4s eccentric. Full lat stretch. Hypertrophy focus.'),
  ('00000000-0000-0000-0021-050200000003', 4, 'DB Bicep Curl',              '3', '12', 60, 'moderate', '3s eccentric. Full supination. RPE 8.'),
  ('00000000-0000-0000-0021-050200000003', 5, 'Pallof Press',               '3', '12', 45, 'moderate', '2s hold each rep. Lateral chain.'),
  ('00000000-0000-0000-0021-050200000003', 6, 'Side Plank',                 '3', '45 sec', 45, 'moderate', '45s each side. Maximum lateral tension.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050200000004', 1, 'DB Hip Thrust',              '4', '12', 75, 'high',     'Load as heavy as possible. 2s hold. Glutes respond to tension.'),
  ('00000000-0000-0000-0021-050200000004', 2, 'Band Hip Abduction',         '3', '20', 60, 'moderate', '2s hold. Glute med isolation.'),
  ('00000000-0000-0000-0021-050200000004', 3, 'Single-Leg DB RDL',          '4', '10', 60, 'moderate', '5 each leg. 4s eccentric. Balance and tension.'),
  ('00000000-0000-0000-0021-050200000004', 4, 'Reverse Lunge with DB',      '3', '10', 60, 'moderate', '5 each leg. 4s eccentric. Knee hovers.'),
  ('00000000-0000-0000-0021-050200000004', 5, 'Glute Bridge',               '3', '20', 30, 'moderate', '2s hold each rep. Burnout volume.'),
  ('00000000-0000-0000-0021-050200000004', 6, 'Hollow Hold',                '3', '30 sec', 45, 'moderate', 'Core close. Full tension. Breathe through it.');

-- Panther General Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050300000001', 1, 'Tempo Push-Up',              '4', '12', 60, 'high',     '3s eccentric. RPE 8.'),
  ('00000000-0000-0000-0021-050300000001', 2, 'DB Floor Press with Pause',  '3', '10', 60, 'high',     '3s eccentric, 2s pause.'),
  ('00000000-0000-0000-0021-050300000001', 3, 'DB Overhead Press',          '3', '12', 60, 'moderate', 'Controlled descent.'),
  ('00000000-0000-0000-0021-050300000001', 4, 'Diamond Push-Up',            '3', '12', 45, 'moderate', '3s eccentric.'),
  ('00000000-0000-0000-0021-050300000001', 5, 'Hollow Hold',                '3', '30 sec', 30, 'moderate', 'Anterior chain.'),
  ('00000000-0000-0000-0021-050300000001', 6, 'Side Plank',                 '3', '30 sec', 30, 'moderate', '30s each side.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050300000002', 1, 'Split Squat Eccentric',      '4', '10', 60, 'high',     '4s eccentric. 5 each leg.'),
  ('00000000-0000-0000-0021-050300000002', 2, 'DB Romanian Deadlift',       '3', '12', 60, 'high',     '3s eccentric.'),
  ('00000000-0000-0000-0021-050300000002', 3, 'Bulgarian Split Squat',      '3', '10', 60, 'moderate', '5 each leg. Controlled.'),
  ('00000000-0000-0000-0021-050300000002', 4, 'DB Hip Thrust',              '3', '12', 45, 'moderate', '2s hold.'),
  ('00000000-0000-0000-0021-050300000002', 5, 'Band Hip Abduction',         '3', '20', 30, 'moderate', '2s hold each rep.'),
  ('00000000-0000-0000-0021-050300000002', 6, 'Side Plank',                 '3', '30 sec', 30, 'moderate', '30s each side.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050300000003', 1, '1-Arm DB Row',               '4', '12', 60, 'high',     '2s hold at top.'),
  ('00000000-0000-0000-0021-050300000003', 2, 'Rear Delt DB Row',           '3', '15', 45, 'moderate', '2s squeeze.'),
  ('00000000-0000-0000-0021-050300000003', 3, 'DB Pullover',                '3', '12', 45, 'moderate', '3s eccentric.'),
  ('00000000-0000-0000-0021-050300000003', 4, 'DB Bicep Curl',              '3', '12', 45, 'moderate', '3s eccentric.'),
  ('00000000-0000-0000-0021-050300000003', 5, 'Pallof Press',               '3', '12', 30, 'moderate', '2s hold.'),
  ('00000000-0000-0000-0021-050300000003', 6, 'Hollow Hold',                '3', '25 sec', 30, 'moderate', 'Tension hold.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-050300000004', 1, 'DB Hip Thrust',              '4', '12', 60, 'high',     '2s hold. Close the week.'),
  ('00000000-0000-0000-0021-050300000004', 2, 'Single-Leg DB RDL',          '3', '10', 60, 'moderate', '5 each leg. 3s eccentric.'),
  ('00000000-0000-0000-0021-050300000004', 3, 'Band Hip Abduction',         '3', '20', 30, 'moderate', 'Glute med finisher.'),
  ('00000000-0000-0000-0021-050300000004', 4, 'World''s Greatest Stretch',  '2', '6',  15, 'low',      '3 each side.'),
  ('00000000-0000-0000-0021-050300000004', 5, 'Pigeon Pose',                '2', '60 sec', 15, 'low',  '30s each side.'),
  ('00000000-0000-0000-0021-050300000004', 6, 'Child''s Pose',              '2', '60 sec', 0,  'low',  'Final reset.');


-- ════════════════════════════════════════════════════════════
-- 6. BEAR — Endurance Circuits + Carries
--    Split: Circuit A | Strength + Carries | Circuit B | Aerobic Endurance
-- ════════════════════════════════════════════════════════════

INSERT INTO training_plans (id, archetype, goal, week_number, name, description, environment) VALUES
  ('00000000-0000-0000-0020-060100000000', 'bear', 'fat_loss',    1, 'Bear Home Fat Loss — Week 1',    'High-volume circuits and carries. Bears do not stop moving.', 'home'),
  ('00000000-0000-0000-0020-060200000000', 'bear', 'muscle_gain', 1, 'Bear Home Muscle — Week 1',      'Strength circuits with loaded carries. Volume accumulation builds the bear.', 'home'),
  ('00000000-0000-0000-0020-060300000000', 'bear', 'general',     1, 'Bear Home General — Week 1',     'Endurance meets strength. Circuits and carries. Built to last.', 'home')
ON CONFLICT ON CONSTRAINT training_plans_archetype_goal_week_number_env_key DO NOTHING;

INSERT INTO training_days (id, training_plan_id, day_number, day_name, focus, notes) VALUES
  ('00000000-0000-0000-0021-060100000001', '00000000-0000-0000-0020-060100000000', 1, 'Day 1', 'Full Body Circuit A',       'High rep, short rest. Keep the HR up.'),
  ('00000000-0000-0000-0021-060100000002', '00000000-0000-0000-0020-060100000000', 2, 'Day 2', 'Strength + Carries',         'Compound strength then loaded carry finisher.'),
  ('00000000-0000-0000-0021-060100000003', '00000000-0000-0000-0020-060100000000', 3, 'Day 3', 'Full Body Circuit B',        'Different exercise order. Same relentless output.'),
  ('00000000-0000-0000-0021-060100000004', '00000000-0000-0000-0020-060100000000', 4, 'Day 4', 'Aerobic Endurance',          'Steady state plus LISS. Bears are built for long hauls.'),
  ('00000000-0000-0000-0021-060200000001', '00000000-0000-0000-0020-060200000000', 1, 'Day 1', 'Strength Circuit A',         'Loaded circuits. Moderate rest. Volume accumulation.'),
  ('00000000-0000-0000-0021-060200000002', '00000000-0000-0000-0020-060200000000', 2, 'Day 2', 'Heavy Strength + Carries',   'Compound movements. Loaded carries for full chain.'),
  ('00000000-0000-0000-0021-060200000003', '00000000-0000-0000-0020-060200000000', 3, 'Day 3', 'Strength Circuit B',         'Second circuit. Higher reps. Grind through.'),
  ('00000000-0000-0000-0021-060200000004', '00000000-0000-0000-0020-060200000000', 4, 'Day 4', 'Full Body Volume',           'Total volume day. Bears accumulate mass through work.'),
  ('00000000-0000-0000-0021-060300000001', '00000000-0000-0000-0020-060300000000', 1, 'Day 1', 'Circuit A',                  'Full body circuit. Steady pace.'),
  ('00000000-0000-0000-0021-060300000002', '00000000-0000-0000-0020-060300000000', 2, 'Day 2', 'Strength + Carries',         'Compound strength then carries.'),
  ('00000000-0000-0000-0021-060300000003', '00000000-0000-0000-0020-060300000000', 3, 'Day 3', 'Circuit B',                  'Second full body circuit.'),
  ('00000000-0000-0000-0021-060300000004', '00000000-0000-0000-0020-060300000000', 4, 'Day 4', 'Endurance + Mobility',       'Aerobic finish + mobility cooldown.')
ON CONFLICT DO NOTHING;

-- Bear Fat Loss Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060100000001', 1, 'Push-Up',                '4', '20',     20, 'high',     'High rep. Keep moving. RPE 9.'),
  ('00000000-0000-0000-0021-060100000001', 2, 'DB Goblet Squat',        '4', '20',     20, 'high',     'High rep. Short rest. Full depth.'),
  ('00000000-0000-0000-0021-060100000001', 3, '1-Arm DB Row',           '3', '15',     20, 'high',     'Each arm. Continuous. No stopping.'),
  ('00000000-0000-0000-0021-060100000001', 4, 'DB Romanian Deadlift',   '3', '15',     20, 'moderate', 'Hip hinge. Stay smooth under fatigue.'),
  ('00000000-0000-0000-0021-060100000001', 5, 'Mountain Climbers',      '3', '30 sec', 15, 'high',     'Drive knees. HR stays up.'),
  ('00000000-0000-0000-0021-060100000001', 6, 'Plank',                  '3', '45 sec', 15, 'moderate', 'Core hold. Breathe. Finish.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060100000002', 1, 'DB Floor Press',         '4', '12',     30, 'high',     'Compound push. Moderate rest. RPE 8.'),
  ('00000000-0000-0000-0021-060100000002', 2, 'DB Goblet Squat',        '4', '15',     30, 'high',     'Squat compound. Keep moving.'),
  ('00000000-0000-0000-0021-060100000002', 3, 'DB Romanian Deadlift',   '3', '12',     30, 'moderate', 'Hinge strength.'),
  ('00000000-0000-0000-0021-060100000002', 4, 'DB Suitcase Carry',      '3', '30m',    30, 'high',     'One DB. Walk 15m, switch, 15m. Heavy.'),
  ('00000000-0000-0000-0021-060100000002', 5, 'DB Front Rack Carry',    '3', '30m',    30, 'high',     'DBs at shoulders. Brace and walk.'),
  ('00000000-0000-0000-0021-060100000002', 6, 'Pallof Press',           '3', '12',     30, 'moderate', 'Anti-rotation core.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060100000003', 1, 'Reverse Lunge',          '4', '20',     20, 'high',     '10 each leg. No rest between legs.'),
  ('00000000-0000-0000-0021-060100000003', 2, 'DB Hip Thrust',          '3', '20',     20, 'high',     '2s hold. High rep burnout.'),
  ('00000000-0000-0000-0021-060100000003', 3, 'Push-Up',                '3', '15',     20, 'high',     'RPE 9. Full range.'),
  ('00000000-0000-0000-0021-060100000003', 4, 'Step-Up with DB',        '3', '16',     20, 'moderate', '8 each leg. Drive through heel.'),
  ('00000000-0000-0000-0021-060100000003', 5, 'Burpee',                 '3', '10',     20, 'high',     'Full effort. Keep moving.'),
  ('00000000-0000-0000-0021-060100000003', 6, 'Plank',                  '3', '60 sec', 20, 'moderate', 'Circuit close. Hold it.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060100000004', 1, 'Brisk Walk',             '1', '30 min', 0,  'moderate', 'Steady state. 5–6/10 effort. Arms swing. Breathe through the nose.'),
  ('00000000-0000-0000-0021-060100000004', 2, 'Step-Up',                '2', '20',     30, 'moderate', '10 each leg. Bodyweight. Steady pace.'),
  ('00000000-0000-0000-0021-060100000004', 3, 'Mountain Climbers',      '2', '30 sec', 30, 'moderate', 'Controlled. Aerobic pace. Not all-out.'),
  ('00000000-0000-0000-0021-060100000004', 4, 'Hip Flexor Stretch',     '2', '60 sec', 15, 'low',      '30s each side.'),
  ('00000000-0000-0000-0021-060100000004', 5, 'World''s Greatest Stretch', '2', '6',  15, 'low',      '3 each side. End of week mobility.'),
  ('00000000-0000-0000-0021-060100000004', 6, 'Child''s Pose',          '2', '60 sec', 0,  'low',      'Final reset. Breathe.');

-- Bear Muscle Gain Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060200000001', 1, 'DB Floor Press',         '4', '12',     60, 'high',     'RPE 8. Compound push first.'),
  ('00000000-0000-0000-0021-060200000001', 2, 'DB Goblet Squat',        '4', '12',     60, 'high',     'Heavy goblet. Full depth. Circuit style.'),
  ('00000000-0000-0000-0021-060200000001', 3, '1-Arm DB Row',           '3', '12',     45, 'high',     'Pull volume. Elbow high.'),
  ('00000000-0000-0000-0021-060200000001', 4, 'DB Romanian Deadlift',   '3', '12',     45, 'moderate', 'Hinge strength in the circuit.'),
  ('00000000-0000-0000-0021-060200000001', 5, 'Push-Up',                '3', '15',     30, 'moderate', 'Volume add-on.'),
  ('00000000-0000-0000-0021-060200000001', 6, 'Plank',                  '3', '60 sec', 30, 'moderate', 'Core close.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060200000002', 1, 'Bulgarian Split Squat',  '4', '10',     75, 'high',     'RPE 8–9. Heavy. Load every rep.'),
  ('00000000-0000-0000-0021-060200000002', 2, 'DB Romanian Deadlift',   '4', '10',     75, 'high',     'Max hamstring load. Heavy.'),
  ('00000000-0000-0000-0021-060200000002', 3, 'DB Hip Thrust',          '3', '12',     60, 'moderate', '2s hold. Load the glutes.'),
  ('00000000-0000-0000-0021-060200000002', 4, 'DB Suitcase Carry',      '4', '30m',    60, 'high',     'Max load. Walk 15m, switch, 15m. Core stability.'),
  ('00000000-0000-0000-0021-060200000002', 5, 'DB Front Rack Carry',    '3', '30m',    60, 'high',     'DBs at shoulders. Braced core. Tall.'),
  ('00000000-0000-0000-0021-060200000002', 6, 'Pallof Press',           '3', '12',     45, 'moderate', 'Anti-rotation after carries.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060200000003', 1, 'DB Goblet Squat',        '4', '15',     45, 'high',     'Higher rep circuit. Accumulate volume.'),
  ('00000000-0000-0000-0021-060200000003', 2, 'DB Hip Thrust',          '3', '15',     30, 'high',     'High rep glutes. 2s hold.'),
  ('00000000-0000-0000-0021-060200000003', 3, 'Push-Up',                '3', '20',     30, 'high',     'RPE 9. Chest volume.'),
  ('00000000-0000-0000-0021-060200000003', 4, 'Step-Up with DB',        '3', '16',     30, 'moderate', '8 each leg. Drive heel.'),
  ('00000000-0000-0000-0021-060200000003', 5, 'Reverse Lunge with DB',  '3', '16',     30, 'moderate', '8 each leg. Controlled.'),
  ('00000000-0000-0000-0021-060200000003', 6, 'Hollow Body Hold',       '3', '30 sec', 30, 'moderate', 'Core finisher. Lower back flat.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060200000004', 1, 'DB Floor Press',         '3', '15',     45, 'moderate', 'Volume day. Higher rep.'),
  ('00000000-0000-0000-0021-060200000004', 2, '1-Arm DB Row',           '3', '15',     45, 'moderate', 'High rep pull.'),
  ('00000000-0000-0000-0021-060200000004', 3, 'DB Goblet Squat',        '3', '20',     30, 'high',     'High volume squat.'),
  ('00000000-0000-0000-0021-060200000004', 4, 'DB Romanian Deadlift',   '3', '15',     30, 'moderate', 'Higher rep hinge.'),
  ('00000000-0000-0000-0021-060200000004', 5, 'DB Farmers Carry',       '3', '30m',    45, 'high',     'Volume carry. End of week.'),
  ('00000000-0000-0000-0021-060200000004', 6, 'Plank',                  '3', '60 sec', 30, 'moderate', 'Core close. Week done.');

-- Bear General Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060300000001', 1, 'Push-Up',                '4', '15',     30, 'high',     'Full circuit pace.'),
  ('00000000-0000-0000-0021-060300000001', 2, 'DB Goblet Squat',        '4', '15',     30, 'high',     'Short rest. High output.'),
  ('00000000-0000-0000-0021-060300000001', 3, '1-Arm DB Row',           '3', '12',     30, 'moderate', 'Each arm. Pull hard.'),
  ('00000000-0000-0000-0021-060300000001', 4, 'DB Romanian Deadlift',   '3', '12',     30, 'moderate', 'Hip hinge circuit.'),
  ('00000000-0000-0000-0021-060300000001', 5, 'Mountain Climbers',      '3', '30 sec', 20, 'high',     'Conditioning element.'),
  ('00000000-0000-0000-0021-060300000001', 6, 'Plank',                  '3', '45 sec', 20, 'moderate', 'Circuit close.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060300000002', 1, 'DB Floor Press',         '4', '12',     60, 'high',     'Compound push. RPE 8.'),
  ('00000000-0000-0000-0021-060300000002', 2, 'Bulgarian Split Squat',  '3', '10',     60, 'high',     'Loaded. 5 each leg.'),
  ('00000000-0000-0000-0021-060300000002', 3, 'DB Romanian Deadlift',   '3', '12',     60, 'moderate', 'Hinge strength.'),
  ('00000000-0000-0000-0021-060300000002', 4, 'DB Suitcase Carry',      '3', '30m',    45, 'high',     'Heavy. Walk tall.'),
  ('00000000-0000-0000-0021-060300000002', 5, 'DB Front Rack Carry',    '3', '30m',    45, 'high',     'Brace and walk.'),
  ('00000000-0000-0000-0021-060300000002', 6, 'Pallof Press',           '3', '12',     30, 'moderate', 'Anti-rotation.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060300000003', 1, 'Reverse Lunge',          '4', '16',     30, 'high',     '8 each leg. Keep moving.'),
  ('00000000-0000-0000-0021-060300000003', 2, 'DB Hip Thrust',          '3', '15',     30, 'moderate', '2s hold.'),
  ('00000000-0000-0000-0021-060300000003', 3, 'Step-Up with DB',        '3', '16',     30, 'moderate', '8 each leg.'),
  ('00000000-0000-0000-0021-060300000003', 4, 'Push-Up',                '3', '15',     20, 'high',     'Volume push.'),
  ('00000000-0000-0000-0021-060300000003', 5, 'Burpee',                 '3', '8',      30, 'high',     'Circuit finish.'),
  ('00000000-0000-0000-0021-060300000003', 6, 'Plank',                  '3', '45 sec', 20, 'moderate', 'Close the circuit.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-060300000004', 1, 'Brisk Walk',             '1', '20 min', 0,  'moderate', 'Steady pace. 5/10 effort. Aerobic base.'),
  ('00000000-0000-0000-0021-060300000004', 2, 'Step-Up',                '2', '20',     30, 'moderate', '10 each leg. Bodyweight.'),
  ('00000000-0000-0000-0021-060300000004', 3, 'Hip Flexor Stretch',     '2', '60 sec', 15, 'low',      '30s each side.'),
  ('00000000-0000-0000-0021-060300000004', 4, 'World''s Greatest Stretch', '2', '6',  15, 'low',      '3 each side.'),
  ('00000000-0000-0000-0021-060300000004', 5, 'Pigeon Pose',            '2', '60 sec', 15, 'low',      '30s each side. Hip opening.'),
  ('00000000-0000-0000-0021-060300000004', 6, 'Child''s Pose',          '2', '60 sec', 0,  'low',      'Final reset. Week done.');


-- ════════════════════════════════════════════════════════════
-- 7. FOX — Minimum Effective Dose + Supersets
--    Split: Full Body Superset A | Full Body Superset B | Full Body Superset C | Active Recovery
-- ════════════════════════════════════════════════════════════

INSERT INTO training_plans (id, archetype, goal, week_number, name, description, environment) VALUES
  ('00000000-0000-0000-0020-070100000000', 'fox', 'fat_loss',    1, 'Fox Home Fat Loss — Week 1',    'Paired supersets that maximize output in minimum time. Smart, efficient, effective.', 'home'),
  ('00000000-0000-0000-0020-070200000000', 'fox', 'muscle_gain', 1, 'Fox Home Muscle — Week 1',      'Superset hypertrophy. Antagonist pairs for maximum muscle stimulus with less time.', 'home'),
  ('00000000-0000-0000-0020-070300000000', 'fox', 'general',     1, 'Fox Home General — Week 1',     'Full-body supersets 3 days. Smart training. No wasted effort.', 'home')
ON CONFLICT ON CONSTRAINT training_plans_archetype_goal_week_number_env_key DO NOTHING;

INSERT INTO training_days (id, training_plan_id, day_number, day_name, focus, notes) VALUES
  ('00000000-0000-0000-0021-070100000001', '00000000-0000-0000-0020-070100000000', 1, 'Day 1', 'Full Body Superset A',      'Push + Hinge supersets. Efficient fat loss.'),
  ('00000000-0000-0000-0021-070100000002', '00000000-0000-0000-0020-070100000000', 2, 'Day 2', 'Full Body Superset B',      'Pull + Squat supersets. Opposite day to A.'),
  ('00000000-0000-0000-0021-070100000003', '00000000-0000-0000-0020-070100000000', 3, 'Day 3', 'Full Body Superset C',      'Carries + Core + Conditioning. Full system.'),
  ('00000000-0000-0000-0021-070100000004', '00000000-0000-0000-0020-070100000000', 4, 'Day 4', 'Active Recovery',           'Light movement. Mobility. Restore and prepare.'),
  ('00000000-0000-0000-0021-070200000001', '00000000-0000-0000-0020-070200000000', 1, 'Day 1', 'Push + Hinge Superset',     'Antagonist superset. More volume, less time.'),
  ('00000000-0000-0000-0021-070200000002', '00000000-0000-0000-0020-070200000000', 2, 'Day 2', 'Pull + Squat Superset',     'Row paired with squat. Full upper + lower.'),
  ('00000000-0000-0000-0021-070200000003', '00000000-0000-0000-0020-070200000000', 3, 'Day 3', 'Carries + Core Superset',   'Loaded carries and core. Strength from the inside out.'),
  ('00000000-0000-0000-0021-070200000004', '00000000-0000-0000-0020-070200000000', 4, 'Day 4', 'Active Recovery',           'Fox rests smart. Light movement, full recovery.'),
  ('00000000-0000-0000-0021-070300000001', '00000000-0000-0000-0020-070300000000', 1, 'Day 1', 'Full Body A Superset',      'Efficient. Targeted. Done right.'),
  ('00000000-0000-0000-0021-070300000002', '00000000-0000-0000-0020-070300000000', 2, 'Day 2', 'Full Body B Superset',      'Balanced. Effective. In and out.'),
  ('00000000-0000-0000-0021-070300000003', '00000000-0000-0000-0020-070300000000', 3, 'Day 3', 'Full Body C',               'Carries and core. Finish the training week.'),
  ('00000000-0000-0000-0021-070300000004', '00000000-0000-0000-0020-070300000000', 4, 'Day 4', 'Active Recovery + Mobility', 'Smart rest day. Mobility and movement prep.')
ON CONFLICT DO NOTHING;

-- Fox Fat Loss Days — Superset notation: A1/A2 pairs, done back to back
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070100000001', 1, 'Push-Up (A1)',            '4', '15',     5,  'high',     'Superset A1. Immediately do A2 with no rest.'),
  ('00000000-0000-0000-0021-070100000001', 2, 'DB Romanian Deadlift (A2)', '4', '12',   45, 'high',     'Superset A2. After A2, rest 45s before repeating A1.'),
  ('00000000-0000-0000-0021-070100000001', 3, 'DB Floor Press (B1)',     '3', '12',     5,  'high',     'Superset B1. Immediately do B2.'),
  ('00000000-0000-0000-0021-070100000001', 4, 'DB Hip Thrust (B2)',      '3', '15',     45, 'high',     'Superset B2. Rest 45s then repeat B1.'),
  ('00000000-0000-0000-0021-070100000001', 5, 'Mountain Climbers (C1)', '3', '30 sec',  5, 'high',     'Superset C1. Conditioning element.'),
  ('00000000-0000-0000-0021-070100000001', 6, 'Plank (C2)',              '3', '30 sec', 45, 'moderate', 'Superset C2. Core hold pairs with climbers. Rest 45s.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070100000002', 1, '1-Arm DB Row (A1)',       '4', '12',     5,  'high',     'Superset A1. Immediately into A2.'),
  ('00000000-0000-0000-0021-070100000002', 2, 'DB Goblet Squat (A2)',    '4', '15',     45, 'high',     'Superset A2. Rest 45s then repeat A1.'),
  ('00000000-0000-0000-0021-070100000002', 3, 'Rear Delt DB Row (B1)',   '3', '15',     5,  'moderate', 'Superset B1. Into B2 immediately.'),
  ('00000000-0000-0000-0021-070100000002', 4, 'Bulgarian Split Squat (B2)', '3', '10', 45, 'high',     'Superset B2. 5 each leg. Rest 45s.'),
  ('00000000-0000-0000-0021-070100000002', 5, 'Reverse Lunge (C1)',      '3', '16',     5,  'moderate', 'Superset C1. 8 each leg.'),
  ('00000000-0000-0000-0021-070100000002', 6, 'Dead Bug (C2)',           '3', '10',     45, 'moderate', 'Superset C2. Core precision. 5 each side. Rest 45s.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070100000003', 1, 'DB Suitcase Carry',       '3', '30m',    45, 'high',     'Walk 15m, switch hands, 15m back. Heavy as possible.'),
  ('00000000-0000-0000-0021-070100000003', 2, 'Pallof Press',            '3', '12',     45, 'moderate', 'Anti-rotation. Pairs with carries logically.'),
  ('00000000-0000-0000-0021-070100000003', 3, 'Push-Up',                 '3', '15',     30, 'high',     'Quick volume push. Short rest.'),
  ('00000000-0000-0000-0021-070100000003', 4, 'Jump Squat',              '3', '10',     30, 'high',     'Metabolic finisher. Explosive.'),
  ('00000000-0000-0000-0021-070100000003', 5, 'Burpee',                  '3', '8',      30, 'high',     'Full body. Full effort.'),
  ('00000000-0000-0000-0021-070100000003', 6, 'Side Plank',              '2', '30 sec', 30, 'moderate', '30s each side. Lateral chain close.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070100000004', 1, 'Brisk Walk',              '1', '20 min', 0,  'low',      'Light and easy. 4/10 effort. Fox recovers smart.'),
  ('00000000-0000-0000-0021-070100000004', 2, 'World''s Greatest Stretch', '2', '6',   15, 'low',      '3 each side.'),
  ('00000000-0000-0000-0021-070100000004', 3, 'Hip Flexor Stretch',      '2', '60 sec', 15, 'low',      '30s each side.'),
  ('00000000-0000-0000-0021-070100000004', 4, 'Thoracic Rotation',       '2', '10',     15, 'low',      '5 each side.'),
  ('00000000-0000-0000-0021-070100000004', 5, 'Pigeon Pose',             '2', '60 sec', 15, 'low',      '30s each side.'),
  ('00000000-0000-0000-0021-070100000004', 6, 'Child''s Pose',           '2', '60 sec', 0,  'low',      'Final reset.');

-- Fox Muscle Gain Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070200000001', 1, 'DB Floor Press (A1)',     '4', '10',     5,  'high',     'RPE 8. Superset A1. Into A2 immediately.'),
  ('00000000-0000-0000-0021-070200000001', 2, 'DB Romanian Deadlift (A2)', '4', '10',  75, 'high',     'Superset A2. RPE 8. Rest 75s before repeating.'),
  ('00000000-0000-0000-0021-070200000001', 3, 'DB Overhead Press (B1)', '3', '12',     5,  'moderate', 'Superset B1. Into B2.'),
  ('00000000-0000-0000-0021-070200000001', 4, 'DB Hip Thrust (B2)',      '3', '12',     60, 'high',     'Superset B2. 2s hold at top. Rest 60s.'),
  ('00000000-0000-0000-0021-070200000001', 5, 'Push-Up',                 '3', '15',     45, 'moderate', 'Volume finisher. Not supersetted.'),
  ('00000000-0000-0000-0021-070200000001', 6, 'Hollow Body Hold',        '3', '30 sec', 45, 'moderate', 'Core hypertrophy. Anterior tension.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070200000002', 1, '1-Arm DB Row (A1)',       '4', '10',     5,  'high',     'RPE 8. Superset A1. Into A2.'),
  ('00000000-0000-0000-0021-070200000002', 2, 'DB Goblet Squat (A2)',    '4', '12',     75, 'high',     'Superset A2. RPE 8. Rest 75s.'),
  ('00000000-0000-0000-0021-070200000002', 3, 'Rear Delt DB Row (B1)',   '3', '12',     5,  'moderate', 'Superset B1. Into B2.'),
  ('00000000-0000-0000-0021-070200000002', 4, 'Bulgarian Split Squat (B2)', '3', '8',  60, 'high',     'Superset B2. RPE 8–9. 4 each leg. Rest 60s.'),
  ('00000000-0000-0000-0021-070200000002', 5, 'DB Pullover',             '3', '12',     60, 'moderate', 'Lat hypertrophy. Not supersetted.'),
  ('00000000-0000-0000-0021-070200000002', 6, 'Dead Bug',                '3', '10',     45, 'moderate', 'Core close. 5 each side. Slow.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070200000003', 1, 'DB Suitcase Carry (A1)', '4', '30m',    5,  'high',     'RPE 8. Superset A1. Heavy carry then into A2.'),
  ('00000000-0000-0000-0021-070200000003', 2, 'Pallof Press (A2)',       '4', '12',     60, 'moderate', 'Superset A2. Anti-rotation. Rest 60s.'),
  ('00000000-0000-0000-0021-070200000003', 3, 'DB Front Rack Carry (B1)', '3', '30m',  5,  'high',     'Superset B1. Into B2.'),
  ('00000000-0000-0000-0021-070200000003', 4, 'Side Plank (B2)',         '3', '45 sec', 60, 'moderate', 'Superset B2. 45s each side. Rest 60s.'),
  ('00000000-0000-0000-0021-070200000003', 5, 'DB Bicep Curl',           '3', '12',     45, 'moderate', 'Arm finish. Slow negative.'),
  ('00000000-0000-0000-0021-070200000003', 6, 'Hollow Body Hold',        '3', '30 sec', 45, 'moderate', 'Core close. Full tension.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070200000004', 1, 'Brisk Walk',              '1', '20 min', 0,  'low',      'Easy. Active recovery. Fox rests to grow.'),
  ('00000000-0000-0000-0021-070200000004', 2, 'World''s Greatest Stretch', '2', '6',   15, 'low',      '3 each side.'),
  ('00000000-0000-0000-0021-070200000004', 3, 'Pigeon Pose',             '2', '60 sec', 15, 'low',      '30s each side.'),
  ('00000000-0000-0000-0021-070200000004', 4, 'Thoracic Rotation',       '2', '10',     15, 'low',      '5 each side.'),
  ('00000000-0000-0000-0021-070200000004', 5, 'Cat-Cow',                 '2', '10',     15, 'low',      'Slow and smooth. Spine health.'),
  ('00000000-0000-0000-0021-070200000004', 6, 'Child''s Pose',           '2', '60 sec', 0,  'low',      'Final reset.');

-- Fox General Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070300000001', 1, 'Push-Up (A1)',            '4', '12',     5,  'high',     'Superset A1 — immediately into A2.'),
  ('00000000-0000-0000-0021-070300000001', 2, 'DB Romanian Deadlift (A2)', '4', '12',  60, 'high',     'Superset A2. Rest 60s.'),
  ('00000000-0000-0000-0021-070300000001', 3, 'DB Floor Press (B1)',     '3', '12',     5,  'moderate', 'Superset B1 — into B2.'),
  ('00000000-0000-0000-0021-070300000001', 4, 'DB Hip Thrust (B2)',      '3', '12',     45, 'moderate', 'Superset B2. 2s hold. Rest 45s.'),
  ('00000000-0000-0000-0021-070300000001', 5, 'Plank',                   '3', '45 sec', 30, 'moderate', 'Core finisher.'),
  ('00000000-0000-0000-0021-070300000001', 6, 'Dead Bug',                '3', '10',     30, 'moderate', '5 each side. Precision close.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070300000002', 1, '1-Arm DB Row (A1)',       '4', '12',     5,  'high',     'Superset A1 — into A2.'),
  ('00000000-0000-0000-0021-070300000002', 2, 'DB Goblet Squat (A2)',    '4', '12',     60, 'high',     'Superset A2. Rest 60s.'),
  ('00000000-0000-0000-0021-070300000002', 3, 'Rear Delt DB Row (B1)',   '3', '12',     5,  'moderate', 'Superset B1 — into B2.'),
  ('00000000-0000-0000-0021-070300000002', 4, 'Split Squat (B2)',        '3', '12',     45, 'moderate', 'Superset B2. 6 each leg. Rest 45s.'),
  ('00000000-0000-0000-0021-070300000002', 5, 'DB Pullover',             '3', '12',     45, 'moderate', 'Lat finish.'),
  ('00000000-0000-0000-0021-070300000002', 6, 'Side Plank',              '3', '30 sec', 30, 'moderate', '30s each side.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070300000003', 1, 'DB Suitcase Carry',       '3', '30m',    45, 'high',     'Heavy carry. Walk tall. Core braced.'),
  ('00000000-0000-0000-0021-070300000003', 2, 'Pallof Press',            '3', '12',     30, 'moderate', 'Anti-rotation. Pairs with carry.'),
  ('00000000-0000-0000-0021-070300000003', 3, 'Push-Up',                 '3', '12',     30, 'moderate', 'Volume push.'),
  ('00000000-0000-0000-0021-070300000003', 4, 'DB Romanian Deadlift',    '3', '12',     45, 'moderate', 'Hinge finish.'),
  ('00000000-0000-0000-0021-070300000003', 5, 'Hollow Body Hold',        '3', '30 sec', 30, 'moderate', 'Core tension.'),
  ('00000000-0000-0000-0021-070300000003', 6, 'Plank',                   '3', '45 sec', 30, 'moderate', 'Week close. Hold it.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-070300000004', 1, 'Brisk Walk',              '1', '15 min', 0,  'low',      'Easy movement. Fox minimum dose.'),
  ('00000000-0000-0000-0021-070300000004', 2, 'Hip Flexor Stretch',      '2', '60 sec', 15, 'low',      '30s each side.'),
  ('00000000-0000-0000-0021-070300000004', 3, 'Pigeon Pose',             '2', '60 sec', 15, 'low',      '30s each side.'),
  ('00000000-0000-0000-0021-070300000004', 4, 'World''s Greatest Stretch', '2', '6',   15, 'low',      '3 each side.'),
  ('00000000-0000-0000-0021-070300000004', 5, 'Cat-Cow',                 '2', '10',     15, 'low',      'Spine reset.'),
  ('00000000-0000-0000-0021-070300000004', 6, 'Child''s Pose',           '2', '60 sec', 0,  'low',      'Done. Recover well.');


-- ════════════════════════════════════════════════════════════
-- 8. STALLION — Speed + Power Conditioning
--    Split: Lower Power (Plyometric) | HIIT Conditioning | Full Body Strength | HIIT + Core
-- ════════════════════════════════════════════════════════════

INSERT INTO training_plans (id, archetype, goal, week_number, name, description, environment) VALUES
  ('00000000-0000-0000-0020-080100000000', 'stallion', 'fat_loss',    1, 'Stallion Home Fat Loss — Week 1',    'Speed circuits and plyometric work. High metabolic output. Built to run hot.', 'home'),
  ('00000000-0000-0000-0020-080200000000', 'stallion', 'muscle_gain', 1, 'Stallion Home Muscle — Week 1',      'Power-strength split. Lower plyometrics + upper strength. Speed meets size.', 'home'),
  ('00000000-0000-0000-0020-080300000000', 'stallion', 'general',     1, 'Stallion Home General — Week 1',     'Power, conditioning, and strength. The complete athletic package.', 'home')
ON CONFLICT ON CONSTRAINT training_plans_archetype_goal_week_number_env_key DO NOTHING;

INSERT INTO training_days (id, training_plan_id, day_number, day_name, focus, notes) VALUES
  ('00000000-0000-0000-0021-080100000001', '00000000-0000-0000-0020-080100000000', 1, 'Day 1', 'Lower Power + Plyo',       'Plyometrics and reactive strength. Fast and explosive.'),
  ('00000000-0000-0000-0021-080100000002', '00000000-0000-0000-0020-080100000000', 2, 'Day 2', 'HIIT Conditioning',        'Speed intervals. Max output for fat burn.'),
  ('00000000-0000-0000-0021-080100000003', '00000000-0000-0000-0020-080100000000', 3, 'Day 3', 'Full Body Strength',       'Compound lifts. Stallion builds power through strength too.'),
  ('00000000-0000-0000-0021-080100000004', '00000000-0000-0000-0020-080100000000', 4, 'Day 4', 'HIIT + Core',              'Speed finisher + core work. End the week at full speed.'),
  ('00000000-0000-0000-0021-080200000001', '00000000-0000-0000-0020-080200000000', 1, 'Day 1', 'Lower Power Strength',     'Heavy lower + plyometrics. Power meets load.'),
  ('00000000-0000-0000-0021-080200000002', '00000000-0000-0000-0020-080200000000', 2, 'Day 2', 'HIIT Upper Conditioning',  'Upper body conditioning. Fast reps, full effort.'),
  ('00000000-0000-0000-0021-080200000003', '00000000-0000-0000-0020-080200000000', 3, 'Day 3', 'Full Body Strength',       'Heavy compound day. Build base strength.'),
  ('00000000-0000-0000-0021-080200000004', '00000000-0000-0000-0020-080200000000', 4, 'Day 4', 'HIIT + Core',              'Speed circuit + core strength. Week close.'),
  ('00000000-0000-0000-0021-080300000001', '00000000-0000-0000-0020-080300000000', 1, 'Day 1', 'Lower Power',              'Plyometric lower body. Reactive strength.'),
  ('00000000-0000-0000-0021-080300000002', '00000000-0000-0000-0020-080300000000', 2, 'Day 2', 'HIIT Conditioning',        'Speed intervals. High output.'),
  ('00000000-0000-0000-0021-080300000003', '00000000-0000-0000-0020-080300000000', 3, 'Day 3', 'Full Body Strength',       'Compound lifts. Foundation strength.'),
  ('00000000-0000-0000-0021-080300000004', '00000000-0000-0000-0020-080300000000', 4, 'Day 4', 'HIIT + Core + Mobility',   'Speed + core + mobility close.')
ON CONFLICT DO NOTHING;

-- Stallion Fat Loss Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080100000001', 1, 'Pogo Hops',               '4', '20',     30, 'high',     'Two-foot continuous hops. Stay on toes. Fast ground contact. Ankle stiffness.'),
  ('00000000-0000-0000-0021-080100000001', 2, 'Squat Jump',              '4', '10',     30, 'high',     'Max height every rep. Full depth squat, explode up.'),
  ('00000000-0000-0000-0021-080100000001', 3, 'Line Hops',               '3', '20',     20, 'high',     'Side to side over a line. Fast feet. 10 each direction.'),
  ('00000000-0000-0000-0021-080100000001', 4, 'Split Squat Jump',        '3', '10',     30, 'high',     'Alternate legs in air. Max height. Soft landing.'),
  ('00000000-0000-0000-0021-080100000001', 5, 'DB Romanian Deadlift',    '3', '12',     30, 'moderate', 'Strength element after plyometrics. Full hinge.'),
  ('00000000-0000-0000-0021-080100000001', 6, 'Pallof Press',            '3', '12',     30, 'moderate', 'Anti-rotation close. Core stability after power work.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080100000002', 1, 'Burpee',                  '5', '10',     20, 'high',     'Max effort every set. 5 rounds. No stopping.'),
  ('00000000-0000-0000-0021-080100000002', 2, 'High Knees',              '4', '30 sec', 15, 'high',     'Sprint pace. Drive knees to hip. Arms pump.'),
  ('00000000-0000-0000-0021-080100000002', 3, 'Jump Jack',               '3', '30 sec', 15, 'moderate', 'Active rest between hard sets.'),
  ('00000000-0000-0000-0021-080100000002', 4, 'Mountain Climbers',       '4', '30 sec', 15, 'high',     'Fast pace. Hips level. Drive.'),
  ('00000000-0000-0000-0021-080100000002', 5, 'Squat Jump',              '3', '8',      20, 'high',     'Power element in the conditioning. Explode.'),
  ('00000000-0000-0000-0021-080100000002', 6, 'Plank',                   '3', '30 sec', 20, 'moderate', 'Core cooldown. Hold steady after the sprint work.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080100000003', 1, 'DB Push Press',           '4', '10',     30, 'high',     'Strength compound. Leg drive into press.'),
  ('00000000-0000-0000-0021-080100000003', 2, 'DB Goblet Squat',         '4', '15',     30, 'high',     'Loaded squat. Short rest to maintain HR.'),
  ('00000000-0000-0000-0021-080100000003', 3, '1-Arm DB Row',            '3', '12',     30, 'moderate', 'Pull volume. Alternate arms.'),
  ('00000000-0000-0000-0021-080100000003', 4, 'Split Squat',             '3', '12',     30, 'moderate', '6 each leg. Drive through front heel.'),
  ('00000000-0000-0000-0021-080100000003', 5, 'DB Romanian Deadlift',    '3', '12',     30, 'moderate', 'Hinge strength element.'),
  ('00000000-0000-0000-0021-080100000003', 6, 'Plank',                   '3', '45 sec', 20, 'moderate', 'Core close.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080100000004', 1, 'Burpee to Squat Jump',    '4', '8',      20, 'high',     'Full burpee, land into squat, explode up. No stopping.'),
  ('00000000-0000-0000-0021-080100000004', 2, 'High Knees',              '3', '30 sec', 15, 'high',     'Sprint pace. Drive knees.'),
  ('00000000-0000-0000-0021-080100000004', 3, 'Mountain Climbers',       '3', '30 sec', 15, 'high',     'Fast and tight.'),
  ('00000000-0000-0000-0021-080100000004', 4, 'Dead Bug',                '3', '10',     30, 'moderate', '5 each side. Core precision after conditioning.'),
  ('00000000-0000-0000-0021-080100000004', 5, 'Pallof Press',            '3', '12',     30, 'moderate', 'Anti-rotation. Strength of core.'),
  ('00000000-0000-0000-0021-080100000004', 6, 'Plank',                   '3', '60 sec', 30, 'moderate', 'Week close. Hold it all the way.');

-- Stallion Muscle Gain Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080200000001', 1, 'Squat Jump',              '3', '6',      60, 'high',     'Potentiation. 3 sets of power before the loaded work.'),
  ('00000000-0000-0000-0021-080200000001', 2, 'Bulgarian Split Squat',   '4', '8',      75, 'high',     'RPE 8–9 after plyos. Load heavy. 4 each leg.'),
  ('00000000-0000-0000-0021-080200000001', 3, 'DB Romanian Deadlift',    '4', '10',     75, 'high',     'Hamstring and hip strength. Load it.'),
  ('00000000-0000-0000-0021-080200000001', 4, 'Split Squat Jump',        '3', '8',      60, 'high',     'Back to power after strength. PAP effect.'),
  ('00000000-0000-0000-0021-080200000001', 5, 'DB Hip Thrust',           '3', '12',     60, 'moderate', 'Glute strength. 2s hold.'),
  ('00000000-0000-0000-0021-080200000001', 6, 'Pallof Press',            '3', '12',     45, 'moderate', 'Anti-rotation. Core base.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080200000002', 1, 'Explosive Push-Up',       '4', '8',      45, 'high',     'Max speed intent. Hands leave floor.'),
  ('00000000-0000-0000-0021-080200000002', 2, 'DB Push Press',           '4', '8',      60, 'high',     'RPE 8. Leg drive + press. Power loaded.'),
  ('00000000-0000-0000-0021-080200000002', 3, '1-Arm DB Row',            '4', '10',     60, 'moderate', 'Pull volume. Controlled.'),
  ('00000000-0000-0000-0021-080200000002', 4, 'High Knees',              '3', '30 sec', 20, 'high',     'Conditioning window. Drive knees.'),
  ('00000000-0000-0000-0021-080200000002', 5, 'Mountain Climbers',       '3', '30 sec', 20, 'high',     'Continue conditioning. Fast pace.'),
  ('00000000-0000-0000-0021-080200000002', 6, 'Plank',                   '3', '45 sec', 30, 'moderate', 'Core close.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080200000003', 1, 'DB Push Press',           '4', '8',      75, 'high',     'RPE 8–9. Primary strength compound.'),
  ('00000000-0000-0000-0021-080200000003', 2, 'DB Goblet Squat',         '4', '10',     75, 'high',     'Heavy squat. RPE 8.'),
  ('00000000-0000-0000-0021-080200000003', 3, '1-Arm DB Row',            '4', '10',     75, 'high',     'Pull compound. Elbow high.'),
  ('00000000-0000-0000-0021-080200000003', 4, 'Split Squat',             '3', '10',     60, 'moderate', '5 each leg. Controlled.'),
  ('00000000-0000-0000-0021-080200000003', 5, 'DB Romanian Deadlift',    '3', '12',     60, 'moderate', 'Hinge strength.'),
  ('00000000-0000-0000-0021-080200000003', 6, 'Dead Bug',                '3', '10',     45, 'moderate', 'Core close. 5 each side. Deliberate.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080200000004', 1, 'Burpee',                  '4', '10',     20, 'high',     'HIIT window. Full effort.'),
  ('00000000-0000-0000-0021-080200000004', 2, 'Pogo Hops',               '3', '20',     20, 'high',     'Reactive power. Fast ground contact.'),
  ('00000000-0000-0000-0021-080200000004', 3, 'High Knees',              '3', '30 sec', 15, 'high',     'Speed. Drive arms and knees.'),
  ('00000000-0000-0000-0021-080200000004', 4, 'Dead Bug',                '3', '10',     30, 'moderate', 'Core precision after conditioning.'),
  ('00000000-0000-0000-0021-080200000004', 5, 'Pallof Press',            '3', '12',     30, 'moderate', 'Stability. Hold each rep.'),
  ('00000000-0000-0000-0021-080200000004', 6, 'Plank',                   '3', '60 sec', 30, 'moderate', 'Core close. Week done. Hold it.');

-- Stallion General Days
INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080300000001', 1, 'Pogo Hops',               '3', '20',     30, 'high',     'Reactive start. Ankle stiffness and speed.'),
  ('00000000-0000-0000-0021-080300000001', 2, 'Squat Jump',              '4', '10',     30, 'high',     'Power production. Max height.'),
  ('00000000-0000-0000-0021-080300000001', 3, 'Split Squat Jump',        '3', '10',     30, 'high',     'Alternate legs. Explosive.'),
  ('00000000-0000-0000-0021-080300000001', 4, 'DB Romanian Deadlift',    '3', '12',     45, 'moderate', 'Strength base after plyos.'),
  ('00000000-0000-0000-0021-080300000001', 5, 'DB Goblet Squat',         '3', '12',     45, 'moderate', 'Loaded squat after power work.'),
  ('00000000-0000-0000-0021-080300000001', 6, 'Pallof Press',            '3', '12',     30, 'moderate', 'Core close. Anti-rotation.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080300000002', 1, 'Burpee',                  '4', '10',     20, 'high',     'Full effort. All-out.'),
  ('00000000-0000-0000-0021-080300000002', 2, 'High Knees',              '4', '30 sec', 15, 'high',     'Drive knees. Sprint pace.'),
  ('00000000-0000-0000-0021-080300000002', 3, 'Mountain Climbers',       '3', '30 sec', 15, 'high',     'Controlled fast. HR sustained.'),
  ('00000000-0000-0000-0021-080300000002', 4, 'Jump Jack',               '3', '30 sec', 15, 'moderate', 'Active rest window.'),
  ('00000000-0000-0000-0021-080300000002', 5, 'Line Hops',               '3', '20',     20, 'high',     'Speed and reactivity. Side to side.'),
  ('00000000-0000-0000-0021-080300000002', 6, 'Plank',                   '3', '45 sec', 30, 'moderate', 'Core close. Conditioning done.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080300000003', 1, 'DB Push Press',           '4', '10',     60, 'high',     'Strength compound. Leg drive.'),
  ('00000000-0000-0000-0021-080300000003', 2, 'DB Goblet Squat',         '4', '12',     60, 'high',     'Loaded squat. RPE 8.'),
  ('00000000-0000-0000-0021-080300000003', 3, '1-Arm DB Row',            '3', '12',     60, 'moderate', 'Pull compound.'),
  ('00000000-0000-0000-0021-080300000003', 4, 'Split Squat',             '3', '10',     45, 'moderate', '5 each leg.'),
  ('00000000-0000-0000-0021-080300000003', 5, 'DB Romanian Deadlift',    '3', '12',     45, 'moderate', 'Hinge strength.'),
  ('00000000-0000-0000-0021-080300000003', 6, 'Dead Bug',                '3', '10',     30, 'moderate', 'Core close. 5 each side.');

INSERT INTO training_exercises (training_day_id, sort_order, exercise_name, sets, reps, rest_seconds, intensity, notes) VALUES
  ('00000000-0000-0000-0021-080300000004', 1, 'Burpee',                  '3', '8',      20, 'high',     'Speed finish.'),
  ('00000000-0000-0000-0021-080300000004', 2, 'High Knees',              '3', '30 sec', 15, 'high',     'Drive knees. Go.'),
  ('00000000-0000-0000-0021-080300000004', 3, 'Dead Bug',                '3', '10',     30, 'moderate', 'Core precision.'),
  ('00000000-0000-0000-0021-080300000004', 4, 'World''s Greatest Stretch', '2', '6',   15, 'low',      '3 each side. Mobility.'),
  ('00000000-0000-0000-0021-080300000004', 5, 'Hip Flexor Stretch',      '2', '60 sec', 15, 'low',      '30s each side. Speed athletes need flexible hips.'),
  ('00000000-0000-0000-0021-080300000004', 6, 'Child''s Pose',           '2', '60 sec', 0,  'low',      'Final reset. Week done. Speed rests to return.');
