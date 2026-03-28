-- ============================================================
-- Animal Instinkz — Seed Data
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard
-- ============================================================
-- UUIDs:
--   Exercises:  00000000-0000-0000-0001-XXXXXXXXXXXX
--   Templates:  00000000-0000-0000-0002-XXXXXXXXXXXX
-- ============================================================

-- ============================================================
-- 1. EXERCISES (30 core exercises)
-- ============================================================

INSERT INTO exercises (id, name, category, equipment, movement_pattern, muscle_primary, muscle_secondary, difficulty, hundred_series_approved, coaching_cues, archetype_affinity)
VALUES

-- Compound Lifts
('00000000-0000-0000-0001-000000000001','Back Squat','compound_lift',ARRAY['barbell','rack'],'squat',ARRAY['quads','glutes'],ARRAY['hamstrings','core'],'intermediate',false,ARRAY['Brace your core hard','Drive knees out','Chest stays tall'],ARRAY['wolf','lion','bear','gorilla']),
('00000000-0000-0000-0001-000000000002','Deadlift','compound_lift',ARRAY['barbell'],'hinge',ARRAY['hamstrings','glutes','back'],ARRAY['core','traps'],'intermediate',false,ARRAY['Hinge at hips first','Keep bar close to shins','Drive the floor away'],ARRAY['wolf','gorilla','bear','hawk']),
('00000000-0000-0000-0001-000000000003','Bench Press','compound_lift',ARRAY['barbell','bench'],'push',ARRAY['chest','triceps'],ARRAY['shoulders'],'intermediate',false,ARRAY['Retract your scapula','Touch chest — do not bounce','Drive through the bar'],ARRAY['lion','gorilla','wolf']),
('00000000-0000-0000-0001-000000000004','Overhead Press','compound_lift',ARRAY['barbell'],'push',ARRAY['shoulders','triceps'],ARRAY['core','traps'],'intermediate',false,ARRAY['Brace tight','Lock out fully overhead','Keep ribs down'],ARRAY['lion','wolf','hawk']),
('00000000-0000-0000-0001-000000000005','Barbell Row','compound_lift',ARRAY['barbell'],'pull',ARRAY['lats','rhomboids'],ARRAY['biceps','rear delts'],'intermediate',false,ARRAY['Lead with elbows','Pull to lower chest','Maintain 45° hinge'],ARRAY['wolf','gorilla','bear']),
('00000000-0000-0000-0001-000000000006','Romanian Deadlift','compound_lift',ARRAY['barbell'],'hinge',ARRAY['hamstrings','glutes'],ARRAY['lower back','core'],'intermediate',false,ARRAY['Push hips back','Soft bend in knees','Feel the stretch — then drive'],ARRAY['wolf','panther','hawk']),
('00000000-0000-0000-0001-000000000007','Hip Thrust','compound_lift',ARRAY['barbell','bench'],'hinge',ARRAY['glutes'],ARRAY['hamstrings','core'],'beginner',false,ARRAY['Drive through heels','Squeeze hard at top','Chin tucked'],ARRAY['stallion','panther','fox']),
('00000000-0000-0000-0001-000000000008','Front Squat','compound_lift',ARRAY['barbell','rack'],'squat',ARRAY['quads'],ARRAY['core','upper back'],'advanced',false,ARRAY['Elbows high','Stay as upright as possible','Drive knees out'],ARRAY['panther','hawk','fox']),

-- Bodyweight
('00000000-0000-0000-0001-000000000009','Push-Up','bodyweight',ARRAY['none'],'push',ARRAY['chest','triceps'],ARRAY['shoulders','core'],'beginner',true,ARRAY['Body straight as a board','Full range of motion','Control the descent'],ARRAY['fox','stallion','panther']),
('00000000-0000-0000-0001-000000000010','Pull-Up','bodyweight',ARRAY['pull-up bar'],'pull',ARRAY['lats','biceps'],ARRAY['rhomboids','core'],'intermediate',false,ARRAY['Dead hang start','Pull elbows to floor','Control the negative'],ARRAY['wolf','lion','gorilla']),
('00000000-0000-0000-0001-000000000011','Dip','bodyweight',ARRAY['dip bars'],'push',ARRAY['triceps','chest'],ARRAY['shoulders'],'intermediate',false,ARRAY['Slight forward lean for chest','Full depth — no half reps','Control the descent'],ARRAY['lion','gorilla','bear']),
('00000000-0000-0000-0001-000000000012','Plank','bodyweight',ARRAY['none'],'carry',ARRAY['core'],ARRAY['shoulders','glutes'],'beginner',false,ARRAY['Neutral spine','Squeeze glutes and abs','Breathe steadily'],ARRAY['wolf','hawk','panther']),
('00000000-0000-0000-0001-000000000013','Burpee','bodyweight',ARRAY['none'],'locomotion',ARRAY['full body'],ARRAY['cardio'],'intermediate',false,ARRAY['Explosive jump','Chest fully to floor','Move with intention — not chaos'],ARRAY['fox','stallion','lion']),
('00000000-0000-0000-0001-000000000014','Box Jump','bodyweight',ARRAY['box'],'squat',ARRAY['quads','glutes'],ARRAY['calves','core'],'intermediate',false,ARRAY['Soft landing — absorb it','Full hip extension at top','Reset completely before next jump'],ARRAY['lion','panther','hawk']),
('00000000-0000-0000-0001-000000000015','Walking Lunge','bodyweight',ARRAY['none'],'squat',ARRAY['quads','glutes'],ARRAY['hamstrings','core'],'beginner',false,ARRAY['Long stride','Knee tracks over toes','Tall posture throughout'],ARRAY['panther','stallion','fox']),
('00000000-0000-0000-0001-000000000016','Bodyweight Squat','bodyweight',ARRAY['none'],'squat',ARRAY['quads','glutes'],ARRAY['hamstrings','core'],'beginner',true,ARRAY['Chest tall','Drive knees out','Full depth — own it'],ARRAY['fox','stallion','bear']),

-- Machine
('00000000-0000-0000-0001-000000000017','Leg Press','machine',ARRAY['leg press machine'],'squat',ARRAY['quads','glutes'],ARRAY['hamstrings'],'beginner',false,ARRAY['Do not lock knees at top','Full range of motion','Controlled descent'],ARRAY['bear','gorilla','stallion']),
('00000000-0000-0000-0001-000000000018','Lat Pulldown','machine',ARRAY['cable machine'],'pull',ARRAY['lats','biceps'],ARRAY['rhomboids'],'beginner',false,ARRAY['Pull to upper chest','Elbows down and back','Full stretch at top'],ARRAY['wolf','bear','stallion']),
('00000000-0000-0000-0001-000000000019','Cable Row','machine',ARRAY['cable machine'],'pull',ARRAY['lats','rhomboids'],ARRAY['biceps','rear delts'],'beginner',false,ARRAY['Upright torso — no swinging','Pull to waist','Full arm extension on return'],ARRAY['wolf','bear','panther']),
('00000000-0000-0000-0001-000000000020','Leg Curl','machine',ARRAY['leg curl machine'],'hinge',ARRAY['hamstrings'],ARRAY['glutes'],'beginner',false,ARRAY['Control the negative','Full range of motion','Do not use momentum'],ARRAY['panther','hawk','stallion']),
('00000000-0000-0000-0001-000000000021','Chest Press Machine','machine',ARRAY['chest press machine'],'push',ARRAY['chest','triceps'],ARRAY['shoulders'],'beginner',false,ARRAY['Controlled tempo','Full range of motion','Squeeze at full extension'],ARRAY['bear','stallion','fox']),

-- Kettlebell
('00000000-0000-0000-0001-000000000022','Kettlebell Swing','kettlebell',ARRAY['kettlebell'],'hinge',ARRAY['glutes','hamstrings'],ARRAY['core','shoulders'],'intermediate',false,ARRAY['Hip hinge — not a squat','Explosive hip drive','Let the bell float at top'],ARRAY['fox','stallion','hawk']),
('00000000-0000-0000-0001-000000000023','Goblet Squat','kettlebell',ARRAY['kettlebell'],'squat',ARRAY['quads','glutes'],ARRAY['core','upper back'],'beginner',false,ARRAY['Chest tall','Elbows inside knees','Full depth'],ARRAY['bear','stallion','fox']),
('00000000-0000-0000-0001-000000000024','KB Clean and Press','kettlebell',ARRAY['kettlebell'],'push',ARRAY['shoulders','legs','core'],ARRAY['triceps','glutes'],'advanced',false,ARRAY['Drive from hips on the clean','Punch through on press','Stay tight overhead'],ARRAY['lion','fox','panther']),

-- Conditioning
('00000000-0000-0000-0001-000000000025','Jump Rope','conditioning',ARRAY['jump rope'],'locomotion',ARRAY['calves','cardio'],ARRAY['shoulders','coordination'],'beginner',false,ARRAY['Light on your feet','Wrists lead the spin','Find your rhythm and hold it'],ARRAY['stallion','fox','panther']),
('00000000-0000-0000-0001-000000000026','Rowing Machine','conditioning',ARRAY['rowing machine'],'pull',ARRAY['back','legs','cardio'],ARRAY['arms','core'],'intermediate',false,ARRAY['Sequence: legs then hips then arms','Keep stroke rate steady','Drive hard through heels'],ARRAY['stallion','hawk','bear']),
('00000000-0000-0000-0001-000000000027','Assault Bike','conditioning',ARRAY['assault bike'],'locomotion',ARRAY['full body','cardio'],ARRAY['quads','shoulders'],'beginner',false,ARRAY['Find a sustainable pace','Use arms and legs equally','Breathe through it'],ARRAY['stallion','lion','fox']),
('00000000-0000-0000-0001-000000000028','Battle Ropes','conditioning',ARRAY['battle ropes'],'carry',ARRAY['shoulders','core','cardio'],ARRAY['biceps','forearms'],'beginner',false,ARRAY['Athletic stance','Drive from the hips','Consistent rhythm — do not fade'],ARRAY['lion','gorilla','fox']),

-- Mobility
('00000000-0000-0000-0001-000000000029','Hip Flexor Stretch','mobility',ARRAY['none'],'locomotion',ARRAY['hip flexors'],ARRAY['quads'],'beginner',false,ARRAY['Tall spine','Gently drive hip forward','Breathe into the stretch'],ARRAY['stallion','panther','hawk']),
('00000000-0000-0000-0001-000000000030','Thoracic Rotation','mobility',ARRAY['none'],'rotation',ARRAY['thoracic spine'],ARRAY['shoulders'],'beginner',false,ARRAY['Keep hips still','Rotate from mid-back only','Slow and controlled'],ARRAY['hawk','panther','fox'])

ON CONFLICT (id) DO NOTHING;


-- ============================================================
-- 2. WORKOUT TEMPLATES — General Mode, Week 1
-- Format: (id, archetype_id, training_mode, week_number, day_label, day_number, estimated_duration_min)
-- ============================================================

INSERT INTO workout_templates (id, archetype_id, training_mode, week_number, day_label, day_number, estimated_duration_min, notes)
VALUES

-- WOLF — Structured periodized splits
('00000000-0000-0000-0002-000000000001','wolf','general',1,'Upper Push',1,55,'Focus on controlled reps. Wolf earns progress through precision.'),
('00000000-0000-0000-0002-000000000002','wolf','general',1,'Lower Power',2,60,'Every set is deliberate. Own the pattern before adding weight.'),
('00000000-0000-0000-0002-000000000003','wolf','general',1,'Active Recovery',3,30,'Recovery is part of the system. Do not skip this day.'),
('00000000-0000-0000-0002-000000000004','wolf','general',1,'Upper Pull',4,55,'Pull sessions build the back that holds everything together.'),
('00000000-0000-0000-0002-000000000005','wolf','general',1,'Full Body Strength',5,60,'Finish the week strong. Execute the plan.'),

-- LION — Max intensity
('00000000-0000-0000-0002-000000000006','lion','general',1,'Max Upper',1,60,'Command this session. Every rep is a statement.'),
('00000000-0000-0000-0002-000000000007','lion','general',1,'Max Lower',2,65,'The Lion does not save energy. Leave nothing in the tank.'),
('00000000-0000-0000-0002-000000000008','lion','general',1,'Power Day',3,50,'Explosive, dominant, present. This is what you were built for.'),
('00000000-0000-0000-0002-000000000009','lion','general',1,'Hypertrophy Block',4,60,'Build the body that backs up the intensity.'),
('00000000-0000-0000-0002-000000000010','lion','general',1,'AMRAP Finisher',5,45,'All out. No pacing. Finish the week with fire.'),

-- PANTHER — Athletic / technical
('00000000-0000-0000-0002-000000000011','panther','general',1,'Speed-Strength',1,50,'Every rep deliberate. The Panther moves with purpose.'),
('00000000-0000-0000-0002-000000000012','panther','general',1,'Mobility and Skill',2,40,'Precision is built here. No shortcuts.'),
('00000000-0000-0000-0002-000000000013','panther','general',1,'Power Development',3,50,'Translate mobility into force. Technical and sharp.'),
('00000000-0000-0000-0002-000000000014','panther','general',1,'Agility and Conditioning',4,45,'Move fast and smart. The Panther controls the pace.'),
('00000000-0000-0000-0002-000000000015','panther','general',1,'Technical Review',5,55,'Review. Refine. Reinforce what matters.'),

-- BEAR — High volume
('00000000-0000-0000-0002-000000000016','bear','general',1,'Squat Focus',1,65,'Volume builds durability. The Bear earns it rep by rep.'),
('00000000-0000-0000-0002-000000000017','bear','general',1,'Press Focus',2,65,'Grind through the volume. Consistency is the weapon.'),
('00000000-0000-0000-0002-000000000018','bear','general',1,'Deadlift Focus',3,65,'The Bear was built for this. Own the weight.'),
('00000000-0000-0000-0002-000000000019','bear','general',1,'Upper Volume',4,60,'More volume means more adaptation. Stay the course.'),
('00000000-0000-0000-0002-000000000020','bear','general',1,'Lower Volume',5,60,'Finish strong. The Bear does not fade.'),

-- HAWK — Data-driven / auto-regulation
('00000000-0000-0000-0002-000000000021','hawk','general',1,'Primary Strength',1,60,'Assess your readiness and adjust RPE accordingly.'),
('00000000-0000-0000-0002-000000000022','hawk','general',1,'Accessory Focus',2,55,'Fill the gaps. Every weakness is a data point.'),
('00000000-0000-0000-0002-000000000023','hawk','general',1,'Deload and Assess',3,35,'Recover intelligently. The Hawk watches and learns.'),
('00000000-0000-0000-0002-000000000024','hawk','general',1,'Secondary Strength',4,60,'Smart effort. Maximum return on every set.'),
('00000000-0000-0000-0002-000000000025','hawk','general',1,'Conditioning Protocol',5,45,'Test your engine. Note the data.'),

-- GORILLA — Powerbuilding
('00000000-0000-0000-0002-000000000026','gorilla','general',1,'Squat and Back',1,65,'Raw and heavy. The Gorilla earns its size.'),
('00000000-0000-0000-0002-000000000027','gorilla','general',1,'Bench and Shoulders',2,60,'Dominant pressing. Built for dominance.'),
('00000000-0000-0000-0002-000000000028','gorilla','general',1,'Deadlift and Arms',3,65,'Pull heavy. Finish the arms that grip everything.'),
('00000000-0000-0000-0002-000000000029','gorilla','general',1,'Heavy Upper',4,60,'More pressing. More pulling. More mass.'),
('00000000-0000-0000-0002-000000000030','gorilla','general',1,'Heavy Lower',5,65,'End the week with the foundation that holds it all up.'),

-- STALLION — Endurance + hybrid
('00000000-0000-0000-0002-000000000031','stallion','general',1,'Long Cardio',1,50,'Find your pace. Hold it. The Stallion was made for this.'),
('00000000-0000-0000-0002-000000000032','stallion','general',1,'Strength Circuit',2,45,'Build the engine underneath the endurance.'),
('00000000-0000-0000-0002-000000000033','stallion','general',1,'Active Recovery',3,30,'Easy movement. Keep the body moving without breaking it.'),
('00000000-0000-0000-0002-000000000034','stallion','general',1,'Interval Training',4,40,'Go hard. Rest. Go hard again. The Stallion outlasts.'),
('00000000-0000-0000-0002-000000000035','stallion','general',1,'Hybrid Session',5,50,'Combine it. Run, lift, breathe. All of it is fuel.'),

-- FOX — Flexible / adaptive
('00000000-0000-0000-0002-000000000036','fox','general',1,'Full Body A',1,45,'Efficient. Purposeful. No wasted movement.'),
('00000000-0000-0000-0002-000000000037','fox','general',1,'Conditioning Focus',2,40,'The Fox uses the shortest path to the result.'),
('00000000-0000-0000-0002-000000000038','fox','general',1,'Full Body B',3,50,'Different stimulus. Same outcome. Adapt and grow.'),
('00000000-0000-0000-0002-000000000039','fox','general',1,'Skills and Mobility',4,35,'Sharpen what others neglect. That is the edge.'),
('00000000-0000-0000-0002-000000000040','fox','general',1,'Wildcard',5,50,'Read the body. Choose the path. Execute it fully.')

ON CONFLICT (id) DO NOTHING;


-- ============================================================
-- 3. WORKOUT TEMPLATE EXERCISES
-- ============================================================

-- ========================
-- WOLF
-- ========================

-- Wolf Day 1: Upper Push
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000001','00000000-0000-0000-0001-000000000003',1,'primary',4,4,6,8.0,180,'Control the descent — touch and press'),
('00000000-0000-0000-0002-000000000001','00000000-0000-0000-0001-000000000004',2,'primary',4,6,8,7.5,150,'Strict press — no leg drive'),
('00000000-0000-0000-0002-000000000001','00000000-0000-0000-0001-000000000019',3,'accessory',3,10,12,7.0,90,'Upright torso — full arm extension'),
('00000000-0000-0000-0002-000000000001','00000000-0000-0000-0001-000000000011',4,'accessory',3,8,10,7.5,90,'Full depth — control the negative'),
('00000000-0000-0000-0002-000000000001','00000000-0000-0000-0001-000000000012',5,'finisher',3,null,null,null,60,'Hold 45 seconds each set');

-- Wolf Day 2: Lower Power
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000002','00000000-0000-0000-0001-000000000001',1,'primary',5,3,5,8.5,240,'Own the bottom — drive the floor away'),
('00000000-0000-0000-0002-000000000002','00000000-0000-0000-0001-000000000006',2,'primary',4,6,8,7.5,150,'Feel the stretch at bottom — drive at top'),
('00000000-0000-0000-0002-000000000002','00000000-0000-0000-0001-000000000015',3,'accessory',3,10,12,7.0,90,'Long stride — knee over toe'),
('00000000-0000-0000-0002-000000000002','00000000-0000-0000-0001-000000000020',4,'accessory',3,10,12,7.0,90,'Control the negative — no momentum');

-- Wolf Day 3: Active Recovery
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000003','00000000-0000-0000-0001-000000000029',1,'activation',2,null,null,null,30,'Hold 60 seconds each side'),
('00000000-0000-0000-0002-000000000003','00000000-0000-0000-0001-000000000030',2,'activation',2,null,null,null,30,'Slow rotations — 10 each side'),
('00000000-0000-0000-0002-000000000003','00000000-0000-0000-0001-000000000025',3,'finisher',3,null,null,null,60,'Jump rope 3 min each set — easy pace'),
('00000000-0000-0000-0002-000000000003','00000000-0000-0000-0001-000000000012',4,'cooldown',2,null,null,null,30,'Hold 60 seconds each set');

-- Wolf Day 4: Upper Pull
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000004','00000000-0000-0000-0001-000000000010',1,'primary',4,5,7,8.0,180,'Full hang — pull elbows to floor'),
('00000000-0000-0000-0002-000000000004','00000000-0000-0000-0001-000000000005',2,'primary',4,6,8,7.5,150,'Pull to lower chest — controlled'),
('00000000-0000-0000-0002-000000000004','00000000-0000-0000-0001-000000000018',3,'accessory',3,10,12,7.0,90,'Full stretch at top — pull to chest'),
('00000000-0000-0000-0002-000000000004','00000000-0000-0000-0001-000000000004',4,'accessory',3,8,10,7.0,120,'Strict — no body english'),
('00000000-0000-0000-0002-000000000004','00000000-0000-0000-0001-000000000019',5,'finisher',3,12,15,7.0,60,'Squeeze each rep — cable row finisher');

-- Wolf Day 5: Full Body Strength
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000005','00000000-0000-0000-0001-000000000002',1,'primary',4,4,5,8.5,240,'The system demands this lift. Execute.'),
('00000000-0000-0000-0002-000000000005','00000000-0000-0000-0001-000000000003',2,'primary',3,6,8,7.5,150,'Controlled — touch and drive'),
('00000000-0000-0000-0002-000000000005','00000000-0000-0000-0001-000000000005',3,'accessory',3,8,10,7.5,120,'Hinge 45° — pull to waist'),
('00000000-0000-0000-0002-000000000005','00000000-0000-0000-0001-000000000014',4,'finisher',3,5,5,null,90,'Explosive — reset every rep');

-- ========================
-- LION
-- ========================

-- Lion Day 1: Max Upper
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000006','00000000-0000-0000-0001-000000000003',1,'primary',5,3,5,9.0,240,'Max effort — command the bar'),
('00000000-0000-0000-0002-000000000006','00000000-0000-0000-0001-000000000004',2,'primary',4,4,6,8.5,180,'Strict press — dominate the rep'),
('00000000-0000-0000-0002-000000000006','00000000-0000-0000-0001-000000000010',3,'accessory',4,6,8,8.0,150,'Pull with everything you have'),
('00000000-0000-0000-0002-000000000006','00000000-0000-0000-0001-000000000011',4,'accessory',3,8,10,8.0,90,'Full depth — no shortcuts'),
('00000000-0000-0000-0002-000000000006','00000000-0000-0000-0001-000000000028',5,'finisher',3,null,null,null,60,'30 seconds max effort each set');

-- Lion Day 2: Max Lower
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000007','00000000-0000-0000-0001-000000000001',1,'primary',5,3,5,9.0,300,'The Lion owns this lift — go heavy'),
('00000000-0000-0000-0002-000000000007','00000000-0000-0000-0001-000000000002',2,'primary',4,4,5,9.0,240,'All in — every rep'),
('00000000-0000-0000-0002-000000000007','00000000-0000-0000-0001-000000000014',3,'activation',3,5,5,null,90,'Explosive — full extension'),
('00000000-0000-0000-0002-000000000007','00000000-0000-0000-0001-000000000017',4,'accessory',3,8,10,8.0,120,'Drive hard — controlled descent');

-- Lion Day 3: Power Day
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000008','00000000-0000-0000-0001-000000000024',1,'primary',4,5,6,8.0,150,'Drive from hips — punch through overhead'),
('00000000-0000-0000-0002-000000000008','00000000-0000-0000-0001-000000000014',2,'primary',4,5,6,null,120,'Max height — soft landing'),
('00000000-0000-0000-0002-000000000008','00000000-0000-0000-0001-000000000028',3,'finisher',3,null,null,null,90,'45 seconds — all out — battle ropes'),
('00000000-0000-0000-0002-000000000008','00000000-0000-0000-0001-000000000013',4,'finisher',3,10,10,null,90,'10 reps — no rest between — push');

-- Lion Day 4: Hypertrophy Block
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000009','00000000-0000-0000-0001-000000000003',1,'primary',4,8,10,7.5,120,'Build the muscle — feel every rep'),
('00000000-0000-0000-0002-000000000009','00000000-0000-0000-0001-000000000005',2,'primary',4,8,10,7.5,120,'Pull with intention — squeeze'),
('00000000-0000-0000-0002-000000000009','00000000-0000-0000-0001-000000000018',3,'accessory',3,12,15,7.0,90,'Controlled — full stretch'),
('00000000-0000-0000-0002-000000000009','00000000-0000-0000-0001-000000000011',4,'accessory',3,10,12,7.5,90,'Full depth — no shortcuts'),
('00000000-0000-0000-0002-000000000009','00000000-0000-0000-0001-000000000019',5,'finisher',3,12,15,7.0,60,'Finisher — squeeze at each rep');

-- Lion Day 5: AMRAP Finisher
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000010','00000000-0000-0000-0001-000000000027',1,'primary',3,null,null,null,90,'Max calories — 60 sec assault bike each set'),
('00000000-0000-0000-0002-000000000010','00000000-0000-0000-0001-000000000013',2,'primary',3,15,15,null,60,'15 reps — all out — Lion does not slow down'),
('00000000-0000-0000-0002-000000000010','00000000-0000-0000-0001-000000000022',3,'finisher',3,20,20,null,60,'20 swings — explosive — every time'),
('00000000-0000-0000-0002-000000000010','00000000-0000-0000-0001-000000000028',4,'finisher',3,null,null,null,90,'30 sec — end the week with fire');

-- ========================
-- PANTHER
-- ========================

-- Panther Day 1: Speed-Strength
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000011','00000000-0000-0000-0001-000000000014',1,'activation',4,4,4,null,120,'Explosive — max height — reset each rep'),
('00000000-0000-0000-0002-000000000011','00000000-0000-0000-0001-000000000008',2,'primary',4,4,6,7.5,150,'Front squat — stay upright — precision'),
('00000000-0000-0000-0002-000000000011','00000000-0000-0000-0001-000000000024',3,'primary',3,5,6,8.0,120,'Clean and press — technical — stay tight'),
('00000000-0000-0000-0002-000000000011','00000000-0000-0000-0001-000000000015',4,'finisher',3,12,14,7.0,60,'Long stride — perfect mechanics');

-- Panther Day 2: Mobility and Skill
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000012','00000000-0000-0000-0001-000000000030',1,'activation',3,null,null,null,30,'10 rotations each side — slow and controlled'),
('00000000-0000-0000-0002-000000000012','00000000-0000-0000-0001-000000000029',2,'activation',3,null,null,null,30,'Hold 60 sec each side — breathe deep'),
('00000000-0000-0000-0002-000000000012','00000000-0000-0000-0001-000000000023',3,'primary',3,12,15,6.5,90,'Goblet squat — own the bottom position'),
('00000000-0000-0000-0002-000000000012','00000000-0000-0000-0001-000000000009',4,'primary',3,15,20,7.0,60,'Full range — body straight as a board'),
('00000000-0000-0000-0002-000000000012','00000000-0000-0000-0001-000000000012',5,'cooldown',2,null,null,null,30,'45 seconds — squeeze and breathe');

-- Panther Day 3: Power Development
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000013','00000000-0000-0000-0001-000000000006',1,'primary',4,6,8,7.5,150,'Push hips back — feel the stretch — drive up'),
('00000000-0000-0000-0002-000000000013','00000000-0000-0000-0001-000000000004',2,'primary',4,6,8,7.5,150,'Strict press — no body english — precision'),
('00000000-0000-0000-0002-000000000013','00000000-0000-0000-0001-000000000019',3,'accessory',3,12,14,7.0,90,'Upright — full arm extension'),
('00000000-0000-0000-0002-000000000013','00000000-0000-0000-0001-000000000025',4,'finisher',3,null,null,null,60,'3 min jump rope — find your rhythm');

-- Panther Day 4: Agility and Conditioning
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000014','00000000-0000-0000-0001-000000000013',1,'primary',4,12,12,null,90,'Move with intention — chest to floor'),
('00000000-0000-0000-0002-000000000014','00000000-0000-0000-0001-000000000014',2,'primary',4,5,5,null,90,'Max height — soft landing — reset'),
('00000000-0000-0000-0002-000000000014','00000000-0000-0000-0001-000000000022',3,'primary',3,20,20,null,60,'Explosive hip drive — not a squat'),
('00000000-0000-0000-0002-000000000014','00000000-0000-0000-0001-000000000025',4,'finisher',3,null,null,null,60,'2 min fast rope — maintain rhythm'),
('00000000-0000-0000-0002-000000000014','00000000-0000-0000-0001-000000000027',5,'finisher',2,null,null,null,90,'30 sec assault bike — max effort');

-- Panther Day 5: Technical Review
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000015','00000000-0000-0000-0001-000000000001',1,'primary',4,5,6,7.5,150,'Quality reps — deliberate movement'),
('00000000-0000-0000-0002-000000000015','00000000-0000-0000-0001-000000000010',2,'primary',4,6,8,7.5,150,'Full hang — pull with precision'),
('00000000-0000-0000-0002-000000000015','00000000-0000-0000-0001-000000000005',3,'accessory',3,8,10,7.5,120,'Hinge and pull — full range'),
('00000000-0000-0000-0002-000000000015','00000000-0000-0000-0001-000000000012',4,'cooldown',3,null,null,null,30,'Hold 45 sec — breathe and reset');

-- ========================
-- BEAR
-- ========================

-- Bear Day 1: Squat Focus
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000016','00000000-0000-0000-0001-000000000001',1,'primary',5,5,8,8.0,180,'Volume is the weapon — stay consistent'),
('00000000-0000-0000-0002-000000000016','00000000-0000-0000-0001-000000000017',2,'primary',4,10,12,7.5,120,'Full range — controlled descent'),
('00000000-0000-0000-0002-000000000016','00000000-0000-0000-0001-000000000015',3,'accessory',3,12,14,7.0,90,'Lunge with purpose — long stride'),
('00000000-0000-0000-0002-000000000016','00000000-0000-0000-0001-000000000020',4,'accessory',3,12,15,7.0,90,'Slow negative — no momentum'),
('00000000-0000-0000-0002-000000000016','00000000-0000-0000-0001-000000000023',5,'finisher',3,15,20,7.0,60,'Goblet squat — own the bottom');

-- Bear Day 2: Press Focus
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000017','00000000-0000-0000-0001-000000000003',1,'primary',5,6,8,7.5,150,'Volume pressing — every rep solid'),
('00000000-0000-0000-0002-000000000017','00000000-0000-0000-0001-000000000021',2,'primary',4,10,12,7.5,120,'Machine press — controlled tempo'),
('00000000-0000-0000-0002-000000000017','00000000-0000-0000-0001-000000000011',3,'accessory',3,10,12,7.5,90,'Full depth — grind the reps'),
('00000000-0000-0000-0002-000000000017','00000000-0000-0000-0001-000000000004',4,'accessory',3,10,12,7.5,120,'Strict overhead — volume block'),
('00000000-0000-0000-0002-000000000017','00000000-0000-0000-0001-000000000012',5,'cooldown',3,null,null,null,30,'Core holds — 45 seconds each');

-- Bear Day 3: Deadlift Focus
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000018','00000000-0000-0000-0001-000000000002',1,'primary',5,5,6,8.5,240,'The Bear was built for this — pull it'),
('00000000-0000-0000-0002-000000000018','00000000-0000-0000-0001-000000000006',2,'primary',4,8,10,7.5,150,'Hamstring stretch at bottom — drive'),
('00000000-0000-0000-0002-000000000018','00000000-0000-0000-0001-000000000005',3,'accessory',3,8,10,7.5,120,'Row volume — back is everything'),
('00000000-0000-0000-0002-000000000018','00000000-0000-0000-0001-000000000010',4,'accessory',3,8,10,8.0,120,'Weighted if possible — max effort');

-- Bear Day 4: Upper Volume
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000019','00000000-0000-0000-0001-000000000018',1,'primary',4,10,12,7.0,90,'Full stretch — pull to chest'),
('00000000-0000-0000-0002-000000000019','00000000-0000-0000-0001-000000000019',2,'primary',4,12,14,7.0,90,'Cable row — upright — squeeze'),
('00000000-0000-0000-0002-000000000019','00000000-0000-0000-0001-000000000010',3,'accessory',3,6,8,7.5,120,'Pull-ups — volume block'),
('00000000-0000-0000-0002-000000000019','00000000-0000-0000-0001-000000000005',4,'accessory',3,10,12,7.5,120,'Barbell row — consistent reps'),
('00000000-0000-0000-0002-000000000019','00000000-0000-0000-0001-000000000021',5,'finisher',3,15,20,7.0,60,'Chest machine — pump finisher');

-- Bear Day 5: Lower Volume
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000020','00000000-0000-0000-0001-000000000017',1,'primary',5,10,12,7.5,120,'Leg press — volume — full range'),
('00000000-0000-0000-0002-000000000020','00000000-0000-0000-0001-000000000007',2,'primary',4,12,15,7.5,120,'Hip thrust — squeeze every rep at top'),
('00000000-0000-0000-0002-000000000020','00000000-0000-0000-0001-000000000020',3,'accessory',3,12,15,7.0,90,'Leg curl — slow negative'),
('00000000-0000-0000-0002-000000000020','00000000-0000-0000-0001-000000000023',4,'accessory',3,15,20,7.0,90,'Goblet squat — full depth'),
('00000000-0000-0000-0002-000000000020','00000000-0000-0000-0001-000000000026',5,'finisher',2,null,null,null,90,'10 min rowing — steady pace to finish');

-- ========================
-- HAWK
-- ========================

-- Hawk Day 1: Primary Strength
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000021','00000000-0000-0000-0001-000000000001',1,'primary',4,4,6,8.0,180,'Log the weight and RPE — track progress'),
('00000000-0000-0000-0002-000000000021','00000000-0000-0000-0001-000000000002',2,'primary',4,4,5,8.5,210,'Max effort — note fatigue response'),
('00000000-0000-0000-0002-000000000021','00000000-0000-0000-0001-000000000004',3,'accessory',3,8,10,7.5,120,'OHP — strict — assess shoulder stability'),
('00000000-0000-0000-0002-000000000021','00000000-0000-0000-0001-000000000012',4,'cooldown',2,null,null,null,30,'Plank — hold 45 sec — core stability');

-- Hawk Day 2: Accessory Focus
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000022','00000000-0000-0000-0001-000000000006',1,'primary',4,8,10,7.5,120,'RDL — fill the hamstring gap'),
('00000000-0000-0000-0002-000000000022','00000000-0000-0000-0001-000000000019',2,'primary',4,10,12,7.0,90,'Cable row — note form weaknesses'),
('00000000-0000-0000-0002-000000000022','00000000-0000-0000-0001-000000000020',3,'accessory',3,12,15,7.0,90,'Leg curl — assess hamstring balance'),
('00000000-0000-0000-0002-000000000022','00000000-0000-0000-0001-000000000018',4,'accessory',3,12,15,7.0,90,'Lat pulldown — full stretch'),
('00000000-0000-0000-0002-000000000022','00000000-0000-0000-0001-000000000030',5,'cooldown',2,null,null,null,30,'Thoracic rotation — mobility maintenance');

-- Hawk Day 3: Deload and Assess
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000023','00000000-0000-0000-0001-000000000023',1,'primary',3,12,15,6.0,90,'Goblet squat — light — perfect form only'),
('00000000-0000-0000-0002-000000000023','00000000-0000-0000-0001-000000000009',2,'primary',3,15,20,6.0,60,'Push-up — assess shoulder symmetry'),
('00000000-0000-0000-0002-000000000023','00000000-0000-0000-0001-000000000029',3,'cooldown',2,null,null,null,30,'Hip flexor stretch — 60 sec each side'),
('00000000-0000-0000-0002-000000000023','00000000-0000-0000-0001-000000000025',4,'cooldown',2,null,null,null,60,'Jump rope 5 min — easy pace only');

-- Hawk Day 4: Secondary Strength
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000024','00000000-0000-0000-0001-000000000003',1,'primary',4,4,6,8.0,180,'Bench — log RPE carefully'),
('00000000-0000-0000-0002-000000000024','00000000-0000-0000-0001-000000000008',2,'primary',3,4,6,7.5,180,'Front squat — assess movement quality'),
('00000000-0000-0000-0002-000000000024','00000000-0000-0000-0001-000000000010',3,'accessory',3,6,8,7.5,150,'Pull-ups — note strength vs last week'),
('00000000-0000-0000-0002-000000000024','00000000-0000-0000-0001-000000000005',4,'accessory',3,8,10,7.5,120,'Barbell row — clean mechanics');

-- Hawk Day 5: Conditioning Protocol
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000025','00000000-0000-0000-0001-000000000026',1,'primary',3,null,null,null,90,'Rowing 4 min — note split time'),
('00000000-0000-0000-0002-000000000025','00000000-0000-0000-0001-000000000022',2,'primary',3,20,20,null,60,'KB swing — note hip drive quality'),
('00000000-0000-0000-0002-000000000025','00000000-0000-0000-0001-000000000028',3,'finisher',3,null,null,null,90,'Battle ropes 30 sec — track output'),
('00000000-0000-0000-0002-000000000025','00000000-0000-0000-0001-000000000013',4,'finisher',3,10,10,null,60,'Burpee — note time to complete');

-- ========================
-- GORILLA
-- ========================

-- Gorilla Day 1: Squat and Back
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000026','00000000-0000-0000-0001-000000000001',1,'primary',5,3,5,9.0,300,'Gorilla moves weight — own the squat'),
('00000000-0000-0000-0002-000000000026','00000000-0000-0000-0001-000000000002',2,'primary',4,3,4,9.0,240,'Heavy pull — maximum effort'),
('00000000-0000-0000-0002-000000000026','00000000-0000-0000-0001-000000000005',3,'accessory',3,6,8,8.0,150,'Barbell row — the back that moves big weight'),
('00000000-0000-0000-0002-000000000026','00000000-0000-0000-0001-000000000010',4,'accessory',3,6,8,8.0,120,'Pull-ups — weighted if possible');

-- Gorilla Day 2: Bench and Shoulders
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000027','00000000-0000-0000-0001-000000000003',1,'primary',5,3,5,9.0,240,'Bench press — command the bar'),
('00000000-0000-0000-0002-000000000027','00000000-0000-0000-0001-000000000004',2,'primary',4,5,6,8.5,180,'Overhead press — heavy and strict'),
('00000000-0000-0000-0002-000000000027','00000000-0000-0000-0001-000000000011',3,'accessory',3,8,10,8.0,90,'Dips — heavy — full range'),
('00000000-0000-0000-0002-000000000027','00000000-0000-0000-0001-000000000019',4,'accessory',3,10,12,7.5,90,'Cable row — back for balance');

-- Gorilla Day 3: Deadlift and Arms
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000028','00000000-0000-0000-0001-000000000002',1,'primary',4,4,5,9.0,300,'Deadlift — no excuses — all in'),
('00000000-0000-0000-0002-000000000028','00000000-0000-0000-0001-000000000006',2,'primary',4,8,10,8.0,150,'Romanian deadlift — feel it'),
('00000000-0000-0000-0002-000000000028','00000000-0000-0000-0001-000000000010',3,'accessory',4,6,8,8.0,120,'Pull-ups — built to pull'),
('00000000-0000-0000-0002-000000000028','00000000-0000-0000-0001-000000000005',4,'accessory',3,8,10,8.0,120,'Barbell row — complete the back'),
('00000000-0000-0000-0002-000000000028','00000000-0000-0000-0001-000000000011',5,'finisher',3,10,12,7.5,90,'Dips — arm finisher');

-- Gorilla Day 4: Heavy Upper
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000029','00000000-0000-0000-0001-000000000003',1,'primary',4,4,6,8.5,180,'Bench — still heavy — still dominant'),
('00000000-0000-0000-0002-000000000029','00000000-0000-0000-0001-000000000004',2,'primary',4,5,6,8.5,180,'OHP — strict — no momentum'),
('00000000-0000-0000-0002-000000000029','00000000-0000-0000-0001-000000000005',3,'accessory',4,8,10,8.0,120,'Barbell row — back stays king'),
('00000000-0000-0000-0002-000000000029','00000000-0000-0000-0001-000000000010',4,'accessory',3,8,10,8.0,120,'Pull-ups — add weight when ready');

-- Gorilla Day 5: Heavy Lower
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000030','00000000-0000-0000-0001-000000000001',1,'primary',5,4,6,8.5,240,'Back squat — end the week strong'),
('00000000-0000-0000-0002-000000000030','00000000-0000-0000-0001-000000000017',2,'primary',4,8,10,8.0,150,'Leg press — additional volume'),
('00000000-0000-0000-0002-000000000030','00000000-0000-0000-0001-000000000006',3,'accessory',3,10,12,8.0,120,'Romanian deadlift — posterior chain'),
('00000000-0000-0000-0002-000000000030','00000000-0000-0000-0001-000000000007',4,'finisher',3,12,15,7.5,90,'Hip thrust — glute finisher — squeeze hard');

-- ========================
-- STALLION
-- ========================

-- Stallion Day 1: Long Cardio
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000031','00000000-0000-0000-0001-000000000026',1,'primary',3,null,null,null,60,'Row 8 min each set — find your pace'),
('00000000-0000-0000-0002-000000000031','00000000-0000-0000-0001-000000000027',2,'primary',2,null,null,null,90,'Assault bike 5 min — steady cadence'),
('00000000-0000-0000-0002-000000000031','00000000-0000-0000-0001-000000000025',3,'finisher',3,null,null,null,60,'Jump rope 5 min — rhythm is everything'),
('00000000-0000-0000-0002-000000000031','00000000-0000-0000-0001-000000000029',4,'cooldown',2,null,null,null,30,'Hip flexor stretch — 60 sec each side');

-- Stallion Day 2: Strength Circuit
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000032','00000000-0000-0000-0001-000000000023',1,'primary',4,15,20,7.0,60,'Goblet squat — build the legs that run'),
('00000000-0000-0000-0002-000000000032','00000000-0000-0000-0001-000000000009',2,'primary',4,15,20,7.0,60,'Push-up — upper body base'),
('00000000-0000-0000-0002-000000000032','00000000-0000-0000-0001-000000000015',3,'primary',3,14,16,7.0,60,'Walking lunge — stride with purpose'),
('00000000-0000-0000-0002-000000000032','00000000-0000-0000-0001-000000000022',4,'finisher',3,20,25,null,60,'KB swing — explosive hip drive'),
('00000000-0000-0000-0002-000000000032','00000000-0000-0000-0001-000000000016',5,'finisher',3,25,30,7.0,60,'Bodyweight squat — high rep finish');

-- Stallion Day 3: Active Recovery
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000033','00000000-0000-0000-0001-000000000029',1,'activation',3,null,null,null,30,'60 sec each side — breathe deep'),
('00000000-0000-0000-0002-000000000033','00000000-0000-0000-0001-000000000030',2,'activation',3,null,null,null,30,'10 rotations each side — slow'),
('00000000-0000-0000-0002-000000000033','00000000-0000-0000-0001-000000000025',3,'primary',3,null,null,null,60,'Jump rope 5 min — easy pace — active recovery');

-- Stallion Day 4: Interval Training
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000034','00000000-0000-0000-0001-000000000027',1,'primary',5,null,null,null,60,'30 sec max effort — 60 sec rest — repeat'),
('00000000-0000-0000-0002-000000000034','00000000-0000-0000-0001-000000000013',2,'primary',4,15,15,null,60,'15 burpees — explosive — no stopping'),
('00000000-0000-0000-0002-000000000034','00000000-0000-0000-0001-000000000025',3,'finisher',3,null,null,null,60,'2 min fast rope — max speed'),
('00000000-0000-0000-0002-000000000034','00000000-0000-0000-0001-000000000028',4,'finisher',3,null,null,null,90,'Battle ropes 40 sec — all out');

-- Stallion Day 5: Hybrid Session
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000035','00000000-0000-0000-0001-000000000026',1,'primary',2,null,null,null,90,'Row 6 min — warm up the engine'),
('00000000-0000-0000-0002-000000000035','00000000-0000-0000-0001-000000000001',2,'primary',3,6,8,7.5,150,'Back squat — stallion can squat too'),
('00000000-0000-0000-0002-000000000035','00000000-0000-0000-0001-000000000022',3,'primary',3,20,20,null,60,'KB swing — explosive and powerful'),
('00000000-0000-0000-0002-000000000035','00000000-0000-0000-0001-000000000017',4,'accessory',3,12,15,7.0,90,'Leg press — volume for the legs'),
('00000000-0000-0000-0002-000000000035','00000000-0000-0000-0001-000000000025',5,'finisher',3,null,null,null,60,'Jump rope 3 min — finish with rhythm');

-- ========================
-- FOX
-- ========================

-- Fox Day 1: Full Body A
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000036','00000000-0000-0000-0001-000000000023',1,'activation',3,12,15,6.5,60,'Goblet squat — activate the legs'),
('00000000-0000-0000-0002-000000000036','00000000-0000-0000-0001-000000000009',2,'primary',3,15,20,7.0,60,'Push-up — efficient and effective'),
('00000000-0000-0000-0002-000000000036','00000000-0000-0000-0001-000000000022',3,'primary',3,20,20,null,60,'KB swing — power with purpose'),
('00000000-0000-0000-0002-000000000036','00000000-0000-0000-0001-000000000015',4,'accessory',3,12,14,7.0,60,'Walking lunge — find the most efficient path'),
('00000000-0000-0000-0002-000000000036','00000000-0000-0000-0001-000000000012',5,'cooldown',2,null,null,null,30,'Plank 45 sec — the Fox always finishes');

-- Fox Day 2: Conditioning Focus
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000037','00000000-0000-0000-0001-000000000022',1,'primary',4,20,25,null,60,'KB swing — warm up the posterior chain'),
('00000000-0000-0000-0002-000000000037','00000000-0000-0000-0001-000000000013',2,'primary',4,12,12,null,60,'Burpee — 12 reps — efficient movement'),
('00000000-0000-0000-0002-000000000037','00000000-0000-0000-0001-000000000025',3,'primary',3,null,null,null,60,'Jump rope 3 min — find the rhythm'),
('00000000-0000-0000-0002-000000000037','00000000-0000-0000-0001-000000000028',4,'finisher',3,null,null,null,90,'Battle ropes 30 sec — all out'),
('00000000-0000-0000-0002-000000000037','00000000-0000-0000-0001-000000000027',5,'finisher',2,null,null,null,90,'Assault bike 30 sec — finish it');

-- Fox Day 3: Full Body B
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000038','00000000-0000-0000-0001-000000000006',1,'primary',4,8,10,7.5,120,'Romanian deadlift — different stimulus'),
('00000000-0000-0000-0002-000000000038','00000000-0000-0000-0001-000000000010',2,'primary',4,6,8,7.5,120,'Pull-ups — the Fox adapts — pull strong'),
('00000000-0000-0000-0002-000000000038','00000000-0000-0000-0001-000000000023',3,'accessory',3,12,15,7.0,60,'Goblet squat — different angle — same result'),
('00000000-0000-0000-0002-000000000038','00000000-0000-0000-0001-000000000024',4,'finisher',3,5,6,8.0,120,'KB clean and press — total body finisher');

-- Fox Day 4: Skills and Mobility
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000039','00000000-0000-0000-0001-000000000030',1,'activation',3,null,null,null,30,'Thoracic rotation — 10 each side'),
('00000000-0000-0000-0002-000000000039','00000000-0000-0000-0001-000000000029',2,'activation',3,null,null,null,30,'Hip flexor stretch — 60 sec each side'),
('00000000-0000-0000-0002-000000000039','00000000-0000-0000-0001-000000000014',3,'primary',4,5,5,null,90,'Box jump — power and skill combined'),
('00000000-0000-0000-0002-000000000039','00000000-0000-0000-0001-000000000015',4,'primary',3,14,16,7.0,60,'Walking lunge — sharp mechanics');

-- Fox Day 5: Wildcard
INSERT INTO workout_template_exercises (template_id, exercise_id, exercise_order, block, sets, reps_min, reps_max, rpe_target, rest_seconds, coaching_note) VALUES
('00000000-0000-0000-0002-000000000040','00000000-0000-0000-0001-000000000002',1,'primary',3,4,5,8.0,210,'Deadlift — even the Fox pulls heavy'),
('00000000-0000-0000-0002-000000000040','00000000-0000-0000-0001-000000000003',2,'primary',3,5,7,7.5,150,'Bench — smart pressing — the Fox never wastes reps'),
('00000000-0000-0000-0002-000000000040','00000000-0000-0000-0001-000000000010',3,'accessory',3,6,8,7.5,120,'Pull-ups — complete the upper body'),
('00000000-0000-0000-0002-000000000040','00000000-0000-0000-0001-000000000013',4,'finisher',3,10,10,null,60,'Burpee finisher — tactical effort'),
('00000000-0000-0000-0002-000000000040','00000000-0000-0000-0001-000000000027',5,'finisher',2,null,null,null,90,'Assault bike 30 sec — end the week');
