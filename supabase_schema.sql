-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  Asclépio — Schema Supabase                                            ║
-- ║  Execute isso no SQL Editor do Supabase Dashboard                      ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Perfis de usuário
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  name TEXT NOT NULL DEFAULT 'Usuário',
  age INTEGER DEFAULT 25,
  weight DOUBLE PRECISION DEFAULT 70.0,
  height DOUBLE PRECISION DEFAULT 175.0,
  gender TEXT DEFAULT 'Masculino',
  blood_type TEXT DEFAULT 'O+',
  goal TEXT DEFAULT 'Saúde geral',
  pre_existing_conditions TEXT DEFAULT '',
  avatar_url TEXT DEFAULT '',
  steps_goal INTEGER DEFAULT 8000,
  calories_goal INTEGER DEFAULT 500,
  activity_minutes_goal INTEGER DEFAULT 30,
  onboarding_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Habilitar RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own profile" ON profiles
  FOR ALL USING (auth.uid() = id);

-- Treinos de musculação
CREATE TABLE IF NOT EXISTS workouts (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  muscle_group TEXT NOT NULL,
  exercises JSONB NOT NULL DEFAULT '[]',
  duration_minutes INTEGER DEFAULT 0,
  total_volume DOUBLE PRECISION DEFAULT 0,
  notes TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own workouts" ON workouts
  FOR ALL USING (auth.uid() = user_id);
CREATE INDEX idx_workouts_user ON workouts(user_id, created_at DESC);

-- Atividades cardio
CREATE TABLE IF NOT EXISTS cardio_activities (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  activity_type TEXT NOT NULL,
  duration_seconds INTEGER DEFAULT 0,
  distance_km DOUBLE PRECISION DEFAULT 0,
  pace DOUBLE PRECISION DEFAULT 0,
  calories INTEGER DEFAULT 0,
  notes TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE cardio_activities ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own cardio" ON cardio_activities
  FOR ALL USING (auth.uid() = user_id);
CREATE INDEX idx_cardio_user ON cardio_activities(user_id, created_at DESC);

-- Consumo de água
CREATE TABLE IF NOT EXISTS water_logs (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  amount_ml INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE water_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own water logs" ON water_logs
  FOR ALL USING (auth.uid() = user_id);
CREATE INDEX idx_water_user ON water_logs(user_id, created_at DESC);

-- Histórico de peso
CREATE TABLE IF NOT EXISTS weight_history (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  weight DOUBLE PRECISION NOT NULL,
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE weight_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own weight history" ON weight_history
  FOR ALL USING (auth.uid() = user_id);
CREATE INDEX idx_weight_user ON weight_history(user_id, recorded_at DESC);

-- Plano semanal de treinos
CREATE TABLE IF NOT EXISTS weekly_plans (
  user_id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  plan JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE weekly_plans ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own weekly plan" ON weekly_plans
  FOR ALL USING (auth.uid() = user_id);
