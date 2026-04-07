-- ============================================================
-- Habit Templates Seed
-- Multi-signal matching: archetype + goal + fat_distribution + environment
-- NULL in any signal = applies to all values of that signal
-- sort_order: lower = higher priority (shown first, assigned first)
-- ============================================================

INSERT INTO habit_templates (archetype, goal, fat_distribution, workout_environment, habit_name, habit_type, target_type, target_value, target_unit, description, sort_order, is_active)
VALUES

-- ============================================================
-- UNIVERSAL HABITS (null archetype + null goal = everyone)
-- ============================================================
(NULL, NULL, NULL, NULL, 'Get 7+ hours of sleep',           'daily',  'duration', 7,    'hours',   'Sleep is your highest-leverage recovery tool.',                    1,  true),
(NULL, NULL, NULL, NULL, 'Drink 8+ glasses of water',        'daily',  'amount',   8,    'glasses', 'Hydration drives energy, performance, and fat metabolism.',         2,  true),
(NULL, NULL, NULL, NULL, 'Eat protein at every meal',         'daily',  'binary',   NULL, NULL,      'Prioritize protein first — it preserves muscle and controls hunger.', 3,  true),
(NULL, NULL, NULL, NULL, 'Log today''s workout',              'daily',  'binary',   NULL, NULL,      'Tracking what you do is the first step to improving it.',           4,  true),

-- ============================================================
-- FAT LOSS — UNIVERSAL (no archetype lock)
-- ============================================================
(NULL, 'fat_loss', NULL,      NULL,  'Hit daily step goal (8k+)',       'daily',  'count',  8000, 'steps',   'Non-exercise movement is a significant fat loss lever.',            1,  true),
(NULL, 'fat_loss', 'central', NULL,  'Hit daily step goal (10k)',        'daily',  'count',  10000,'steps',   'Central fat responds well to high daily activity.',                 1,  true),
(NULL, 'fat_loss', NULL,      NULL,  'Stop eating by 8pm',               'daily',  'binary', NULL, NULL,      'Late eating disrupts sleep quality and increases fat storage risk.', 2,  true),
(NULL, 'fat_loss', 'central', NULL,  'No liquid calories',               'daily',  'binary', NULL, NULL,      'Drinks are the hidden calorie source — cut them first.',             3,  true),
(NULL, 'fat_loss', NULL,      NULL,  'Hit protein target',               'daily',  'binary', NULL, NULL,      'Protein is your #1 fat loss tool. Hit it every day.',               4,  true),
(NULL, 'fat_loss', NULL,      NULL,  'Complete a cardio session',         'daily',  'binary', NULL, NULL,      'One conditioning or cardio block per day on training days.',         5,  true),
(NULL, 'fat_loss', NULL,      NULL,  'Track food intake',                 'daily',  'binary', NULL, NULL,      'Awareness is the foundation of fat loss. Track it.',                6,  true),
(NULL, 'fat_loss', 'lower',   NULL,  'Complete lower body training day',  'daily',  'binary', NULL, NULL,      'Lower body training burns more calories and builds the largest muscles.', 3, true),

-- ============================================================
-- MUSCLE GAIN — UNIVERSAL
-- ============================================================
(NULL, 'muscle_gain', NULL, NULL, 'Hit calorie surplus today',          'daily',  'binary', NULL, NULL,      'You cannot build muscle in a deficit. Eat to grow.',                1,  true),
(NULL, 'muscle_gain', NULL, NULL, 'Hit protein target',                  'daily',  'binary', NULL, NULL,      'Protein is the raw material for muscle. No exceptions.',            2,  true),
(NULL, 'muscle_gain', NULL, NULL, 'Complete heavy compound lift',         'daily',  'binary', NULL, NULL,      'Compound movements are the signal that triggers muscle growth.',     3,  true),
(NULL, 'muscle_gain', NULL, NULL, 'Recovery shake or meal post-workout', 'daily',  'binary', NULL, NULL,      'Feed the work you just did. The window matters.',                   4,  true),
(NULL, 'muscle_gain', NULL, NULL, 'Sleep 8 hours',                       'daily',  'duration',8,  'hours',   'Muscle is built while you sleep — not while you train.',            5,  true),
(NULL, 'muscle_gain', NULL, NULL, 'Progressive overload log',            'daily',  'binary', NULL, NULL,      'Track your lifts. If you''re not tracking, you''re not progressing.', 6, true),

-- ============================================================
-- PERFORMANCE — UNIVERSAL
-- ============================================================
(NULL, 'performance', NULL, NULL, 'Pre-workout fueling complete',   'daily',  'binary',   NULL, NULL,      'Performance requires fuel. Train fed, not fasted.',                   1,  true),
(NULL, 'performance', NULL, NULL, 'Hydration target (3L+)',          'daily',  'amount',   3,    'liters',  'Even 2% dehydration degrades athletic output significantly.',          2,  true),
(NULL, 'performance', NULL, NULL, 'Complete mobility session (15m)', 'daily',  'duration', 15,   'minutes', 'Mobility is the foundation that performance is built on.',             3,  true),
(NULL, 'performance', NULL, NULL, 'Speed or power session complete', 'daily',  'binary',   NULL, NULL,      'Quality over quantity. One quality power session per day.',             4,  true),
(NULL, 'performance', NULL, NULL, 'Focus block (30m, no phone)',     'daily',  'duration', 30,   'minutes', 'Mental clarity drives physical performance. Train both.',              5,  true),
(NULL, 'performance', NULL, NULL, 'Ice bath or contrast shower',     'weekly', 'count',    2,    'sessions','Active recovery protocols accelerate performance adaptation.',          6,  true),

-- ============================================================
-- GENERAL FITNESS — UNIVERSAL
-- ============================================================
(NULL, 'general', NULL, NULL, 'Complete today''s workout',       'daily',  'binary', NULL, NULL,      'Consistency is the only thing that matters long term.',               1,  true),
(NULL, 'general', NULL, NULL, 'Move for 30+ minutes',             'daily',  'duration',30, 'minutes', 'Movement is medicine. Make it daily.',                                2,  true),
(NULL, 'general', NULL, NULL, 'Eat a balanced meal',              'daily',  'binary', NULL, NULL,      'One solid, balanced meal per day sets the tone for the rest.',        3,  true),

-- ============================================================
-- ARCHETYPE-SPECIFIC: LION
-- ============================================================
('lion', 'fat_loss',    'central', NULL, 'Dominate a conditioning block',    'daily',  'binary', NULL, NULL,      'Lions attack cardio the same way they attack everything — completely.', 1, true),
('lion', 'fat_loss',    NULL,      NULL, 'No excuses on missed reps',         'daily',  'binary', NULL, NULL,      'Every rep counts. The Lion doesn''t shortchange the work.',             2, true),
('lion', 'muscle_gain', NULL,      NULL, 'Max effort on primary lift',        'daily',  'binary', NULL, NULL,      'The Lion''s strength comes from going all out when it counts.',          1, true),
('lion', 'performance', NULL,      NULL, 'Explosive warmup complete',         'daily',  'binary', NULL, NULL,      'Activate the system before demanding it performs.',                     1, true),

-- ============================================================
-- ARCHETYPE-SPECIFIC: WOLF
-- ============================================================
('wolf', 'fat_loss',    NULL, NULL, 'Log every meal',                 'daily',  'binary', NULL, NULL,      'Wolf tracks everything. Precision is the weapon.',                      1, true),
('wolf', 'fat_loss',    NULL, NULL, 'Review weekly plan adherence',   'weekly', 'binary', NULL, NULL,      'The Wolf reviews, adjusts, and executes. No guessing.',                 2, true),
('wolf', 'muscle_gain', NULL, NULL, 'Log all sets and weights',       'daily',  'binary', NULL, NULL,      'Wolf earns progress through precision. Track everything.',               1, true),
('wolf', 'muscle_gain', NULL, NULL, 'Plan next week''s training',     'weekly', 'binary', NULL, NULL,      'The Wolf prepares in advance. Execution follows planning.',              2, true),

-- ============================================================
-- ARCHETYPE-SPECIFIC: BEAR
-- ============================================================
('bear', 'muscle_gain', NULL, NULL, 'Complete all prescribed sets',   'daily',  'binary', NULL, NULL,      'Volume builds durability. The Bear never skips a set.',                 1, true),
('bear', 'muscle_gain', NULL, NULL, 'Anti-inflammatory food today',   'daily',  'binary', NULL, NULL,      'The Bear recovers through fueling right. Prioritize whole foods.',       2, true),
('bear', 'fat_loss',    NULL, NULL, 'Slow and controlled reps',       'daily',  'binary', NULL, NULL,      'The Bear builds muscle while cutting by staying technical.',             1, true),

-- ============================================================
-- ARCHETYPE-SPECIFIC: GORILLA
-- ============================================================
('gorilla', 'muscle_gain', NULL, NULL, 'Eat big — hit calorie target',      'daily',  'binary', NULL, NULL,      'The Gorilla was built for mass. Eat like you mean it.',              1, true),
('gorilla', 'muscle_gain', NULL, NULL, 'Heavy compound first — no skipping', 'daily',  'binary', NULL, NULL,      'The foundation is the squat, the deadlift, the press. Always.',      2, true),
('gorilla', 'muscle_gain', NULL, NULL, 'Protein within 30min post-lift',     'daily',  'binary', NULL, NULL,      'Feed the work. The Gorilla doesn''t train and forget to eat.',       3, true),

-- ============================================================
-- ARCHETYPE-SPECIFIC: HAWK
-- ============================================================
('hawk', 'fat_loss',    NULL, NULL, 'Rate today''s workout quality (1–5)', 'daily',  'count',  1, 'rating', 'The Hawk tracks data to optimize. Quality score matters.',              1, true),
('hawk', 'performance', NULL, NULL, 'Review performance metrics',           'daily',  'binary', NULL, NULL,   'Data without review is useless. The Hawk acts on what it sees.',        1, true),
('hawk', 'performance', NULL, NULL, 'Auto-regulate today''s RPE',           'daily',  'binary', NULL, NULL,   'Listen to your body and adjust intensity accordingly.',                 2, true),

-- ============================================================
-- ARCHETYPE-SPECIFIC: STALLION
-- ============================================================
('stallion', 'fat_loss',    NULL, NULL, 'Complete cardio session (30m+)',    'daily',  'duration', 30, 'minutes','The Stallion was built for endurance. Use it.',                      1, true),
('stallion', 'performance', NULL, NULL, 'Long cardio session (45m+)',        'daily',  'duration', 45, 'minutes','Endurance is your edge. Build it consistently.',                     1, true),
('stallion', 'general',     NULL, NULL, 'Stay active all day (no long sits)','daily',  'binary',   NULL, NULL,   'The Stallion keeps moving. Break up every 90 minutes of sitting.',   1, true),

-- ============================================================
-- ARCHETYPE-SPECIFIC: PANTHER
-- ============================================================
('panther', 'performance', NULL, NULL, 'Technical drill or skill work',     'daily',  'binary', NULL, NULL,   'Precision separates the Panther. Skill work is non-negotiable.',        1, true),
('panther', 'fat_loss',    NULL, NULL, 'Agility or speed session',           'daily',  'binary', NULL, NULL,   'The Panther stays lean by staying fast. Prioritize movement quality.',   1, true),

-- ============================================================
-- ARCHETYPE-SPECIFIC: FOX
-- ============================================================
('fox', 'general',     NULL, NULL, 'Try one new movement or variation',  'weekly', 'binary', NULL, NULL,   'The Fox adapts. Variety is a feature, not a flaw.',                     1, true),
('fox', 'fat_loss',    NULL, NULL, 'Flexible meal plan — stay in target', 'daily',  'binary', NULL, NULL,   'The Fox uses flexible dieting: hit the targets, ignore the rules.',     1, true),

-- ============================================================
-- HOME MODE SPECIFIC
-- ============================================================
(NULL, NULL, NULL, 'home', 'Complete home workout (no skipping)', 'daily', 'binary', NULL, NULL, 'No gym? No excuse. Home sessions count exactly the same.',               1, true),
(NULL, NULL, NULL, 'home', 'Do a 10-minute bodyweight finisher',   'daily', 'duration', 10, 'minutes', 'Add 10 minutes of bodyweight work at the end of your home session.',    2, true)

ON CONFLICT DO NOTHING;
