-- 01_gym_schema.sql

-- 1. Create Gym Exercises Table
CREATE TABLE IF NOT EXISTS gym_exercises (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  muscle_group TEXT NOT NULL,
  equipment TEXT NOT NULL,
  difficulty TEXT NOT NULL, -- 'Iniciante', 'Intermediário', 'Avançado'
  primary_muscle TEXT NOT NULL,
  secondary_muscles TEXT[] DEFAULT '{}',
  instructions TEXT[] DEFAULT '{}',
  video_url TEXT,
  icon TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create Indexes for fast lookup
CREATE INDEX idx_gym_exercises_muscle_group ON gym_exercises(muscle_group);
CREATE INDEX idx_gym_exercises_equipment ON gym_exercises(equipment);
CREATE INDEX idx_gym_exercises_difficulty ON gym_exercises(difficulty);

-- 3. Enhance Workouts Table (Refining existing structure)
-- We keep 'exercises' as JSONB for flexibility, but we can enforce a schema via check constraint if needed.
-- For now, let's just add a column to link to a specific routine if we implement those later.
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS routine_id BIGINT;

-- 4. Create RLS Policies for Exercises (Public Read, Admin Write)
ALTER TABLE gym_exercises ENABLE ROW LEVEL SECURITY;

-- Allow everyone (authenticated or not?) to read exercises
CREATE POLICY "Public exercises are viewable by everyone" ON gym_exercises
  FOR SELECT USING (true);

-- Only service_role can insert/update/delete (User shouldn't edit the global library)
CREATE POLICY "Service role can manage exercises" ON gym_exercises
  USING (auth.role() = 'service_role');
