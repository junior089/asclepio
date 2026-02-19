-- 02_seed_exercises.sql

INSERT INTO gym_exercises (name, muscle_group, equipment, difficulty, primary_muscle, secondary_muscles, instructions) VALUES
-- PEITO
('Supino Reto com Barra', 'Peito', 'Barra', 'Intermediário', 'Peitoral Maior', ARRAY['Deltoide Anterior', 'Tríceps'], ARRAY['Deite no banco reto', 'Segure a barra com pegada mais larga que os ombros', 'Desça a barra até o peito', 'Empurre de volta até extensão completa']),
('Supino Inclinado com Haltere', 'Peito', 'Haltere', 'Intermediário', 'Peitoral Superior', ARRAY['Deltoide Anterior', 'Tríceps'], ARRAY['Ajuste o banco a 30-45°', 'Segure um haltere em cada mão', 'Desça até os cotovelos a 90°', 'Empurre para cima']),
('Supino Declinado', 'Peito', 'Barra', 'Intermediário', 'Peitoral Inferior', ARRAY['Tríceps'], ARRAY['Posicione no banco declinado', 'Desça a barra controladamente', 'Empurre até extensão']),
('Crucifixo com Haltere', 'Peito', 'Haltere', 'Iniciante', 'Peitoral Maior', ARRAY['Deltoide Anterior'], ARRAY['Deite no banco reto com halteres', 'Abra os braços em arco', 'Mantenha leve flexão nos cotovelos', 'Junte os halteres no topo']),
('Crossover no Cabo', 'Peito', 'Cabo', 'Intermediário', 'Peitoral Maior', ARRAY['Deltoide Anterior'], ARRAY['Posicione as polias altas', 'Dê um passo à frente', 'Junte as mãos na frente do corpo', 'Controle o retorno']),
('Flexão de Braço', 'Peito', 'Peso Corporal', 'Iniciante', 'Peitoral Maior', ARRAY['Tríceps', 'Deltoide Anterior'], ARRAY['Mãos na largura dos ombros', 'Corpo reto como uma prancha', 'Desça até o peito tocar o chão', 'Empurre para cima']),
('Chest Press na Máquina', 'Peito', 'Máquina', 'Iniciante', 'Peitoral Maior', ARRAY['Tríceps'], ARRAY['Ajuste o assento na altura do peito', 'Empurre para frente até extensão', 'Retorne controladamente']),
('Peck Deck (Fly na Máquina)', 'Peito', 'Máquina', 'Iniciante', 'Peitoral Maior', ARRAY[''], ARRAY['Ajuste os braços na altura do peito', 'Junte os braços à frente', 'Controle o retorno', 'Mantenha cotovelos levemente flexionados']),

-- COSTAS
('Barra Fixa (Pull-up)', 'Costas', 'Peso Corporal', 'Avançado', 'Grande Dorsal', ARRAY['Bíceps', 'Romboides'], ARRAY['Pegada pronada mais larga que ombros', 'Puxe até o queixo passar a barra', 'Desça controladamente']),
('Remada Curvada com Barra', 'Costas', 'Barra', 'Intermediário', 'Grande Dorsal', ARRAY['Romboides', 'Bíceps', 'Trapézio'], ARRAY['Incline o tronco a 45°', 'Puxe a barra até o abdômen', 'Contraia as escápulas no topo', 'Desça controladamente']),
('Puxada Frontal no Cabo', 'Costas', 'Cabo', 'Iniciante', 'Grande Dorsal', ARRAY['Bíceps', 'Romboides'], ARRAY['Segure a barra larga', 'Puxe até o peito', 'Contraia as costas', 'Retorne controladamente']),
('Remada Unilateral com Haltere', 'Costas', 'Haltere', 'Iniciante', 'Grande Dorsal', ARRAY['Romboides', 'Bíceps'], ARRAY['Apoie joelho e mão no banco', 'Puxe o haltere até o quadril', 'Contraia a escápula no topo']),
('Remada Cavaleiro (T-Bar)', 'Costas', 'Barra', 'Intermediário', 'Grande Dorsal', ARRAY['Romboides', 'Trapézio'], ARRAY['Posicione sobre a barra em V', 'Puxe até o peito', 'Mantenha tronco estável']),
('Pulldown com Triângulo', 'Costas', 'Cabo', 'Iniciante', 'Grande Dorsal', ARRAY['Bíceps'], ARRAY['Use pegada neutra no triângulo', 'Puxe até o peito', 'Foque na contração das costas']),
('Remada Sentada no Cabo', 'Costas', 'Cabo', 'Iniciante', 'Romboides', ARRAY['Grande Dorsal', 'Bíceps'], ARRAY['Sente com peito erguido', 'Puxe até o abdômen', 'Junte as escápulas']),
('Levantamento Terra', 'Costas', 'Barra', 'Avançado', 'Eretores da Espinha', ARRAY['Glúteos', 'Isquiotibiais', 'Trapézio'], ARRAY['Pés na largura dos ombros', 'Costas retas, peito para cima', 'Levante empurrando o chão', 'Travamento no topo']),

-- OMBROS
('Desenvolvimento com Haltere', 'Ombros', 'Haltere', 'Intermediário', 'Deltoide Anterior', ARRAY['Deltoide Lateral', 'Tríceps'], ARRAY['Sentado ou em pé', 'Halteres na altura dos ombros', 'Empurre para cima', 'Desça até 90°']),
('Elevação Lateral', 'Ombros', 'Haltere', 'Iniciante', 'Deltoide Lateral', ARRAY[''], ARRAY['Halteres ao lado do corpo', 'Eleve lateralmente até os ombros', 'Controle a descida', 'Evite balançar o corpo']),
('Elevação Frontal', 'Ombros', 'Haltere', 'Iniciante', 'Deltoide Anterior', ARRAY[''], ARRAY['Halteres à frente das coxas', 'Eleve à frente até a altura dos ombros', 'Desça controladamente']),
('Face Pull', 'Ombros', 'Cabo', 'Iniciante', 'Deltoide Posterior', ARRAY['Romboides', 'Trapézio'], ARRAY['Polia na altura do rosto', 'Puxe a corda até o rosto', 'Abra os cotovelos', 'Controle o retorno']),
('Desenvolvimento Arnold', 'Ombros', 'Haltere', 'Avançado', 'Deltoide', ARRAY['Tríceps'], ARRAY['Inicie com pegada supinada ao peito', 'Gire as palmas empurrando para cima', 'Termine com pegada pronada no topo']),
('Remada Alta', 'Ombros', 'Barra', 'Intermediário', 'Deltoide Lateral', ARRAY['Trapézio'], ARRAY['Segure a barra com pegada estreita', 'Puxe até o queixo', 'Cotovelos apontam para cima']),

-- BICEPS
('Rosca Direta com Barra', 'Bíceps', 'Barra', 'Iniciante', 'Bíceps Braquial', ARRAY['Braquial'], ARRAY['Segure a barra com pegada supinada', 'Flexione os cotovelos', 'Aperte no topo', 'Desça controladamente']),
('Rosca Alternada com Haltere', 'Bíceps', 'Haltere', 'Iniciante', 'Bíceps Braquial', ARRAY['Braquial'], ARRAY['Alterne braço esquerdo e direito', 'Gire o punho durante a subida (supinação)', 'Controle a descida']),
('Rosca Martelo', 'Bíceps', 'Haltere', 'Iniciante', 'Braquiorradial', ARRAY['Bíceps Braquial'], ARRAY['Pegada neutra (palmas para dentro)', 'Flexione até o ombro', 'Mantenha cotovelos fixos']),
('Rosca Scott', 'Bíceps', 'Barra', 'Intermediário', 'Bíceps Braquial', ARRAY[''], ARRAY['Apoie os braços no banco Scott', 'Flexione a barra EZ', 'Desça sem estender completamente']),
('Rosca Concentrada', 'Bíceps', 'Haltere', 'Intermediário', 'Bíceps Braquial', ARRAY[''], ARRAY['Sentado, cotovelo na parte interna da coxa', 'Flexione o haltere', 'Contraia no topo por 1s']),
('Rosca no Cabo (Cross Body)', 'Bíceps', 'Cabo', 'Intermediário', 'Bíceps Braquial', ARRAY['Braquial'], ARRAY['Polia baixa', 'Puxe cruzando o corpo', 'Contraia no topo']),

-- TRICEPS
('Tríceps Pulley (Corda)', 'Tríceps', 'Cabo', 'Iniciante', 'Tríceps', ARRAY[''], ARRAY['Polia alta com corda', 'Cotovelos fixos ao lado do corpo', 'Estenda os braços e abra a corda no final', 'Retorne controladamente']),
('Tríceps Testa com Barra EZ', 'Tríceps', 'Barra', 'Intermediário', 'Tríceps', ARRAY[''], ARRAY['Deite no banco reto', 'Desça a barra até a testa', 'Estenda os braços', 'Cotovelos apontam para o teto']),
('Mergulho (Dips)', 'Tríceps', 'Peso Corporal', 'Avançado', 'Tríceps', ARRAY['Peitoral', 'Deltoide Anterior'], ARRAY['Segure nas barras paralelas', 'Desça flexionando os cotovelos', 'Corpo levemente inclinado para frente', 'Empurre para cima']),
('Tríceps Francês com Haltere', 'Tríceps', 'Haltere', 'Intermediário', 'Tríceps (cabeça longa)', ARRAY[''], ARRAY['Sentado, haltere atrás da cabeça', 'Estenda o braço para cima', 'Cotovelo apontando para cima']),
('Tríceps Kickback', 'Tríceps', 'Haltere', 'Iniciante', 'Tríceps', ARRAY[''], ARRAY['Incline o tronco', 'Estenda o braço para trás', 'Aperte no topo', 'Cotovelo fixo']),

-- PERNAS
('Agachamento Livre', 'Pernas', 'Barra', 'Intermediário', 'Quadríceps', ARRAY['Glúteos', 'Isquiotibiais', 'Core'], ARRAY['Barra apoiada nos trapézios', 'Pés na largura dos ombros', 'Desça até 90° ou mais', 'Empurre o chão para subir']),
('Leg Press 45°', 'Pernas', 'Máquina', 'Iniciante', 'Quadríceps', ARRAY['Glúteos', 'Isquiotibiais'], ARRAY['Pés na largura dos ombros na plataforma', 'Desça o peso controladamente', 'Não trave os joelhos no topo']),
('Cadeira Extensora', 'Pernas', 'Máquina', 'Iniciante', 'Quadríceps', ARRAY[''], ARRAY['Ajuste a almofada nos tornozelos', 'Estenda as pernas', 'Contraia no topo por 1s', 'Desça controladamente']),
('Mesa Flexora', 'Pernas', 'Máquina', 'Iniciante', 'Isquiotibiais', ARRAY[''], ARRAY['Deite-se de bruços', 'Flexione as pernas até 90°', 'Contraia no topo', 'Controle a descida']),
('Afundo (Lunge)', 'Pernas', 'Haltere', 'Intermediário', 'Quadríceps', ARRAY['Glúteos', 'Isquiotibiais'], ARRAY['Dê um passo à frente', 'Joelho traseiro quase toca o chão', 'Empurre de volta à posição', 'Alterne as pernas']),
('Stiff (Levantamento Terra Romeno)', 'Pernas', 'Barra', 'Intermediário', 'Isquiotibiais', ARRAY['Glúteos', 'Eretores da Espinha'], ARRAY['Pernas semi-estendidas', 'Desça a barra ao longo das pernas', 'Sinta o alongamento dos isquiotibiais', 'Suba contraindo os glúteos']),
('Panturrilha em Pé', 'Pernas', 'Máquina', 'Iniciante', 'Gastrocnêmio', ARRAY['Sóleo'], ARRAY['Ombros sob as almofdas', 'Eleve os calcanhares ao máximo', 'Segure no topo por 1s', 'Desça estendendo bem']),
('Agachamento Búlgaro', 'Pernas', 'Haltere', 'Avançado', 'Quadríceps', ARRAY['Glúteos'], ARRAY['Pé traseiro no banco', 'Desça o joelho frontal a 90°', 'Empurre para subir', 'Foque no equilíbrio']),
('Hack Squat', 'Pernas', 'Máquina', 'Intermediário', 'Quadríceps', ARRAY['Glúteos'], ARRAY['Costas apoiadas no encosto', 'Pés na plataforma', 'Desça controladamente', 'Empurre sem travar']),

-- ABDOMEN
('Abdominal Crunch', 'Abdômen', 'Peso Corporal', 'Iniciante', 'Reto Abdominal', ARRAY[''], ARRAY['Deite com joelhos flexionados', 'Levante ombros do chão', 'Contraia o abdômen', 'Desça controladamente']),
('Prancha (Plank)', 'Abdômen', 'Peso Corporal', 'Iniciante', 'Core', ARRAY['Reto Abdominal', 'Oblíquos'], ARRAY['Apoie antebraços e pontas dos pés', 'Corpo reto como uma tábua', 'Contraia o abdômen', 'Mantenha por tempo']),
('Abdominal Infra (Elevação de Pernas)', 'Abdômen', 'Peso Corporal', 'Intermediário', 'Reto Abdominal Inferior', ARRAY['Flexores do Quadril'], ARRAY['Deite no banco ou chão', 'Eleve as pernas estendidas', 'Desça sem tocar o chão']),
('Abdominal Oblíquo (Bicicleta)', 'Abdômen', 'Peso Corporal', 'Intermediário', 'Oblíquos', ARRAY['Reto Abdominal'], ARRAY['Deite, mãos atrás da cabeça', 'Cotovelo toca joelho oposto', 'Alterne os lados', 'Movimento de pedalar']),
('Abdominal na Máquina', 'Abdômen', 'Máquina', 'Iniciante', 'Reto Abdominal', ARRAY[''], ARRAY['Ajuste o peso', 'Flexione o tronco para frente', 'Contraia o abdômen', 'Retorne controladamente']),
('Prancha Lateral', 'Abdômen', 'Peso Corporal', 'Intermediário', 'Oblíquos', ARRAY['Core'], ARRAY['Apoie um antebraço', 'Corpo em linha reta', 'Quadril elevado', 'Mantenha por tempo']),

-- GLUTEOS
('Hip Thrust', 'Glúteos', 'Barra', 'Intermediário', 'Glúteo Máximo', ARRAY['Isquiotibiais'], ARRAY['Costas apoiadas no banco', 'Barra sobre o quadril', 'Empurre o quadril até extensão completa', 'Contraia glúteos no topo por 2s']),
('Elevação Pélvica', 'Glúteos', 'Peso Corporal', 'Iniciante', 'Glúteo Máximo', ARRAY[''], ARRAY['Deite com pés no chão', 'Eleve o quadril', 'Contraia glúteos no topo', 'Desça sem tocar o chão'])

ON CONFLICT (name) DO NOTHING;
