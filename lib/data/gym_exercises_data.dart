/// Banco de exercícios de musculação com dados detalhados.
class GymExercise {
  final String name;
  final String muscleGroup;
  final String equipment;
  final String difficulty; // Iniciante, Intermediário, Avançado
  final List<String> instructions;
  final String primaryMuscle;
  final List<String> secondaryMuscles;

  const GymExercise({
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    this.instructions = const [],
    this.primaryMuscle = '',
    this.secondaryMuscles = const [],
  });
}

class GymExercisesData {
  GymExercisesData._();

  static const muscleGroupIcons = {
    'Peito': '🫁',
    'Costas': '🔙',
    'Ombros': '💪',
    'Bíceps': '💪',
    'Tríceps': '💪',
    'Pernas': '🦵',
    'Abdômen': '🔥',
    'Glúteos': '🍑',
    'Antebraço': '✊',
  };

  static List<String> get muscleGroups => muscleGroupIcons.keys.toList();

  static List<GymExercise> getByMuscleGroup(String group) =>
      exercises.where((e) => e.muscleGroup == group).toList();

  static List<GymExercise> getByDifficulty(String difficulty) =>
      exercises.where((e) => e.difficulty == difficulty).toList();

  static List<GymExercise> getByEquipment(String equipment) =>
      exercises.where((e) => e.equipment == equipment).toList();

  static const List<String> equipmentTypes = [
    'Barra',
    'Haltere',
    'Máquina',
    'Cabo',
    'Peso Corporal',
    'Kettlebell',
    'Smith',
    'Elástico',
  ];

  static const exercises = <GymExercise>[
    // ═══════════════════ PEITO ═══════════════════
    GymExercise(
        name: 'Supino Reto com Barra',
        muscleGroup: 'Peito',
        equipment: 'Barra',
        difficulty: 'Intermediário',
        primaryMuscle: 'Peitoral Maior',
        secondaryMuscles: [
          'Deltoide Anterior',
          'Tríceps'
        ],
        instructions: [
          'Deite no banco reto',
          'Segure a barra com pegada mais larga que os ombros',
          'Desça a barra até o peito',
          'Empurre de volta até extensão completa'
        ]),
    GymExercise(
        name: 'Supino Inclinado com Haltere',
        muscleGroup: 'Peito',
        equipment: 'Haltere',
        difficulty: 'Intermediário',
        primaryMuscle: 'Peitoral Superior',
        secondaryMuscles: [
          'Deltoide Anterior',
          'Tríceps'
        ],
        instructions: [
          'Ajuste o banco a 30-45°',
          'Segure um haltere em cada mão',
          'Desça até os cotovelos a 90°',
          'Empurre para cima'
        ]),
    GymExercise(
        name: 'Supino Declinado',
        muscleGroup: 'Peito',
        equipment: 'Barra',
        difficulty: 'Intermediário',
        primaryMuscle: 'Peitoral Inferior',
        secondaryMuscles: [
          'Tríceps'
        ],
        instructions: [
          'Posicione no banco declinado',
          'Desça a barra controladamente',
          'Empurre até extensão'
        ]),
    GymExercise(
        name: 'Crucifixo com Haltere',
        muscleGroup: 'Peito',
        equipment: 'Haltere',
        difficulty: 'Iniciante',
        primaryMuscle: 'Peitoral Maior',
        secondaryMuscles: [
          'Deltoide Anterior'
        ],
        instructions: [
          'Deite no banco reto com halteres',
          'Abra os braços em arco',
          'Mantenha leve flexão nos cotovelos',
          'Junte os halteres no topo'
        ]),
    GymExercise(
        name: 'Crossover no Cabo',
        muscleGroup: 'Peito',
        equipment: 'Cabo',
        difficulty: 'Intermediário',
        primaryMuscle: 'Peitoral Maior',
        secondaryMuscles: [
          'Deltoide Anterior'
        ],
        instructions: [
          'Posicione as polias altas',
          'Dê um passo à frente',
          'Junte as mãos na frente do corpo',
          'Controle o retorno'
        ]),
    GymExercise(
        name: 'Flexão de Braço',
        muscleGroup: 'Peito',
        equipment: 'Peso Corporal',
        difficulty: 'Iniciante',
        primaryMuscle: 'Peitoral Maior',
        secondaryMuscles: [
          'Tríceps',
          'Deltoide Anterior'
        ],
        instructions: [
          'Mãos na largura dos ombros',
          'Corpo reto como uma prancha',
          'Desça até o peito tocar o chão',
          'Empurre para cima'
        ]),
    GymExercise(
        name: 'Chest Press na Máquina',
        muscleGroup: 'Peito',
        equipment: 'Máquina',
        difficulty: 'Iniciante',
        primaryMuscle: 'Peitoral Maior',
        secondaryMuscles: [
          'Tríceps'
        ],
        instructions: [
          'Ajuste o assento na altura do peito',
          'Empurre para frente até extensão',
          'Retorne controladamente'
        ]),
    GymExercise(
        name: 'Peck Deck (Fly na Máquina)',
        muscleGroup: 'Peito',
        equipment: 'Máquina',
        difficulty: 'Iniciante',
        primaryMuscle: 'Peitoral Maior',
        secondaryMuscles: [],
        instructions: [
          'Ajuste os braços na altura do peito',
          'Junte os braços à frente',
          'Controle o retorno',
          'Mantenha cotovelos levemente flexionados'
        ]),

    // ═══════════════════ COSTAS ═══════════════════
    GymExercise(
        name: 'Barra Fixa (Pull-up)',
        muscleGroup: 'Costas',
        equipment: 'Peso Corporal',
        difficulty: 'Avançado',
        primaryMuscle: 'Grande Dorsal',
        secondaryMuscles: [
          'Bíceps',
          'Romboides'
        ],
        instructions: [
          'Pegada pronada mais larga que ombros',
          'Puxe até o queixo passar a barra',
          'Desça controladamente'
        ]),
    GymExercise(
        name: 'Remada Curvada com Barra',
        muscleGroup: 'Costas',
        equipment: 'Barra',
        difficulty: 'Intermediário',
        primaryMuscle: 'Grande Dorsal',
        secondaryMuscles: [
          'Romboides',
          'Bíceps',
          'Trapézio'
        ],
        instructions: [
          'Incline o tronco a 45°',
          'Puxe a barra até o abdômen',
          'Contraia as escápulas no topo',
          'Desça controladamente'
        ]),
    GymExercise(
        name: 'Puxada Frontal no Cabo',
        muscleGroup: 'Costas',
        equipment: 'Cabo',
        difficulty: 'Iniciante',
        primaryMuscle: 'Grande Dorsal',
        secondaryMuscles: [
          'Bíceps',
          'Romboides'
        ],
        instructions: [
          'Segure a barra larga',
          'Puxe até o peito',
          'Contraia as costas',
          'Retorne controladamente'
        ]),
    GymExercise(
        name: 'Remada Unilateral com Haltere',
        muscleGroup: 'Costas',
        equipment: 'Haltere',
        difficulty: 'Iniciante',
        primaryMuscle: 'Grande Dorsal',
        secondaryMuscles: [
          'Romboides',
          'Bíceps'
        ],
        instructions: [
          'Apoie joelho e mão no banco',
          'Puxe o haltere até o quadril',
          'Contraia a escápula no topo'
        ]),
    GymExercise(
        name: 'Remada Cavaleiro (T-Bar)',
        muscleGroup: 'Costas',
        equipment: 'Barra',
        difficulty: 'Intermediário',
        primaryMuscle: 'Grande Dorsal',
        secondaryMuscles: [
          'Romboides',
          'Trapézio'
        ],
        instructions: [
          'Posicione sobre a barra em V',
          'Puxe até o peito',
          'Mantenha tronco estável'
        ]),
    GymExercise(
        name: 'Pulldown com Triângulo',
        muscleGroup: 'Costas',
        equipment: 'Cabo',
        difficulty: 'Iniciante',
        primaryMuscle: 'Grande Dorsal',
        secondaryMuscles: [
          'Bíceps'
        ],
        instructions: [
          'Use pegada neutra no triângulo',
          'Puxe até o peito',
          'Foque na contração das costas'
        ]),
    GymExercise(
        name: 'Remada Sentada no Cabo',
        muscleGroup: 'Costas',
        equipment: 'Cabo',
        difficulty: 'Iniciante',
        primaryMuscle: 'Romboides',
        secondaryMuscles: [
          'Grande Dorsal',
          'Bíceps'
        ],
        instructions: [
          'Sente com peito erguido',
          'Puxe até o abdômen',
          'Junte as escápulas'
        ]),
    GymExercise(
        name: 'Levantamento Terra',
        muscleGroup: 'Costas',
        equipment: 'Barra',
        difficulty: 'Avançado',
        primaryMuscle: 'Eretores da Espinha',
        secondaryMuscles: [
          'Glúteos',
          'Isquiotibiais',
          'Trapézio'
        ],
        instructions: [
          'Pés na largura dos ombros',
          'Costas retas, peito para cima',
          'Levante empurrando o chão',
          'Travamento no topo'
        ]),

    // ═══════════════════ OMBROS ═══════════════════
    GymExercise(
        name: 'Desenvolvimento com Haltere',
        muscleGroup: 'Ombros',
        equipment: 'Haltere',
        difficulty: 'Intermediário',
        primaryMuscle: 'Deltoide Anterior',
        secondaryMuscles: [
          'Deltoide Lateral',
          'Tríceps'
        ],
        instructions: [
          'Sentado ou em pé',
          'Halteres na altura dos ombros',
          'Empurre para cima',
          'Desça até 90°'
        ]),
    GymExercise(
        name: 'Elevação Lateral',
        muscleGroup: 'Ombros',
        equipment: 'Haltere',
        difficulty: 'Iniciante',
        primaryMuscle: 'Deltoide Lateral',
        secondaryMuscles: [],
        instructions: [
          'Halteres ao lado do corpo',
          'Eleve lateralmente até os ombros',
          'Controle a descida',
          'Evite balançar o corpo'
        ]),
    GymExercise(
        name: 'Elevação Frontal',
        muscleGroup: 'Ombros',
        equipment: 'Haltere',
        difficulty: 'Iniciante',
        primaryMuscle: 'Deltoide Anterior',
        secondaryMuscles: [],
        instructions: [
          'Halteres à frente das coxas',
          'Eleve à frente até a altura dos ombros',
          'Desça controladamente'
        ]),
    GymExercise(
        name: 'Face Pull',
        muscleGroup: 'Ombros',
        equipment: 'Cabo',
        difficulty: 'Iniciante',
        primaryMuscle: 'Deltoide Posterior',
        secondaryMuscles: [
          'Romboides',
          'Trapézio'
        ],
        instructions: [
          'Polia na altura do rosto',
          'Puxe a corda até o rosto',
          'Abra os cotovelos',
          'Controle o retorno'
        ]),
    GymExercise(
        name: 'Desenvolvimento Arnold',
        muscleGroup: 'Ombros',
        equipment: 'Haltere',
        difficulty: 'Avançado',
        primaryMuscle: 'Deltoide',
        secondaryMuscles: [
          'Tríceps'
        ],
        instructions: [
          'Inicie com pegada supinada ao peito',
          'Gire as palmas empurrando para cima',
          'Termine com pegada pronada no topo'
        ]),
    GymExercise(
        name: 'Remada Alta',
        muscleGroup: 'Ombros',
        equipment: 'Barra',
        difficulty: 'Intermediário',
        primaryMuscle: 'Deltoide Lateral',
        secondaryMuscles: [
          'Trapézio'
        ],
        instructions: [
          'Segure a barra com pegada estreita',
          'Puxe até o queixo',
          'Cotovelos apontam para cima'
        ]),

    // ═══════════════════ BÍCEPS ═══════════════════
    GymExercise(
        name: 'Rosca Direta com Barra',
        muscleGroup: 'Bíceps',
        equipment: 'Barra',
        difficulty: 'Iniciante',
        primaryMuscle: 'Bíceps Braquial',
        secondaryMuscles: [
          'Braquial'
        ],
        instructions: [
          'Segure a barra com pegada supinada',
          'Flexione os cotovelos',
          'Aperte no topo',
          'Desça controladamente'
        ]),
    GymExercise(
        name: 'Rosca Alternada com Haltere',
        muscleGroup: 'Bíceps',
        equipment: 'Haltere',
        difficulty: 'Iniciante',
        primaryMuscle: 'Bíceps Braquial',
        secondaryMuscles: [
          'Braquial'
        ],
        instructions: [
          'Alterne braço esquerdo e direito',
          'Gire o punho durante a subida (supinação)',
          'Controle a descida'
        ]),
    GymExercise(
        name: 'Rosca Martelo',
        muscleGroup: 'Bíceps',
        equipment: 'Haltere',
        difficulty: 'Iniciante',
        primaryMuscle: 'Braquiorradial',
        secondaryMuscles: [
          'Bíceps Braquial'
        ],
        instructions: [
          'Pegada neutra (palmas para dentro)',
          'Flexione até o ombro',
          'Mantenha cotovelos fixos'
        ]),
    GymExercise(
        name: 'Rosca Scott',
        muscleGroup: 'Bíceps',
        equipment: 'Barra',
        difficulty: 'Intermediário',
        primaryMuscle: 'Bíceps Braquial',
        secondaryMuscles: [],
        instructions: [
          'Apoie os braços no banco Scott',
          'Flexione a barra EZ',
          'Desça sem estender completamente'
        ]),
    GymExercise(
        name: 'Rosca Concentrada',
        muscleGroup: 'Bíceps',
        equipment: 'Haltere',
        difficulty: 'Intermediário',
        primaryMuscle: 'Bíceps Braquial',
        secondaryMuscles: [],
        instructions: [
          'Sentado, cotovelo na parte interna da coxa',
          'Flexione o haltere',
          'Contraia no topo por 1s'
        ]),
    GymExercise(
        name: 'Rosca no Cabo (Cross Body)',
        muscleGroup: 'Bíceps',
        equipment: 'Cabo',
        difficulty: 'Intermediário',
        primaryMuscle: 'Bíceps Braquial',
        secondaryMuscles: [
          'Braquial'
        ],
        instructions: [
          'Polia baixa',
          'Puxe cruzando o corpo',
          'Contraia no topo'
        ]),

    // ═══════════════════ TRÍCEPS ═══════════════════
    GymExercise(
        name: 'Tríceps Pulley (Corda)',
        muscleGroup: 'Tríceps',
        equipment: 'Cabo',
        difficulty: 'Iniciante',
        primaryMuscle: 'Tríceps',
        secondaryMuscles: [],
        instructions: [
          'Polia alta com corda',
          'Cotovelos fixos ao lado do corpo',
          'Estenda os braços e abra a corda no final',
          'Retorne controladamente'
        ]),
    GymExercise(
        name: 'Tríceps Testa com Barra EZ',
        muscleGroup: 'Tríceps',
        equipment: 'Barra',
        difficulty: 'Intermediário',
        primaryMuscle: 'Tríceps',
        secondaryMuscles: [],
        instructions: [
          'Deite no banco reto',
          'Desça a barra até a testa',
          'Estenda os braços',
          'Cotovelos apontam para o teto'
        ]),
    GymExercise(
        name: 'Mergulho (Dips)',
        muscleGroup: 'Tríceps',
        equipment: 'Peso Corporal',
        difficulty: 'Avançado',
        primaryMuscle: 'Tríceps',
        secondaryMuscles: [
          'Peitoral',
          'Deltoide Anterior'
        ],
        instructions: [
          'Segure nas barras paralelas',
          'Desça flexionando os cotovelos',
          'Corpo levemente inclinado para frente',
          'Empurre para cima'
        ]),
    GymExercise(
        name: 'Tríceps Francês com Haltere',
        muscleGroup: 'Tríceps',
        equipment: 'Haltere',
        difficulty: 'Intermediário',
        primaryMuscle: 'Tríceps (cabeça longa)',
        secondaryMuscles: [],
        instructions: [
          'Sentado, haltere atrás da cabeça',
          'Estenda o braço para cima',
          'Cotovelo apontando para cima'
        ]),
    GymExercise(
        name: 'Tríceps Kickback',
        muscleGroup: 'Tríceps',
        equipment: 'Haltere',
        difficulty: 'Iniciante',
        primaryMuscle: 'Tríceps',
        secondaryMuscles: [],
        instructions: [
          'Incline o tronco',
          'Estenda o braço para trás',
          'Aperte no topo',
          'Cotovelo fixo'
        ]),

    // ═══════════════════ PERNAS ═══════════════════
    GymExercise(
        name: 'Agachamento Livre',
        muscleGroup: 'Pernas',
        equipment: 'Barra',
        difficulty: 'Intermediário',
        primaryMuscle: 'Quadríceps',
        secondaryMuscles: [
          'Glúteos',
          'Isquiotibiais',
          'Core'
        ],
        instructions: [
          'Barra apoiada nos trapézios',
          'Pés na largura dos ombros',
          'Desça até 90° ou mais',
          'Empurre o chão para subir'
        ]),
    GymExercise(
        name: 'Leg Press 45°',
        muscleGroup: 'Pernas',
        equipment: 'Máquina',
        difficulty: 'Iniciante',
        primaryMuscle: 'Quadríceps',
        secondaryMuscles: [
          'Glúteos',
          'Isquiotibiais'
        ],
        instructions: [
          'Pés na largura dos ombros na plataforma',
          'Desça o peso controladamente',
          'Não trave os joelhos no topo'
        ]),
    GymExercise(
        name: 'Cadeira Extensora',
        muscleGroup: 'Pernas',
        equipment: 'Máquina',
        difficulty: 'Iniciante',
        primaryMuscle: 'Quadríceps',
        secondaryMuscles: [],
        instructions: [
          'Ajuste a almofada nos tornozelos',
          'Estenda as pernas',
          'Contraia no topo por 1s',
          'Desça controladamente'
        ]),
    GymExercise(
        name: 'Mesa Flexora',
        muscleGroup: 'Pernas',
        equipment: 'Máquina',
        difficulty: 'Iniciante',
        primaryMuscle: 'Isquiotibiais',
        secondaryMuscles: [],
        instructions: [
          'Deite-se de bruços',
          'Flexione as pernas até 90°',
          'Contraia no topo',
          'Controle a descida'
        ]),
    GymExercise(
        name: 'Afundo (Lunge)',
        muscleGroup: 'Pernas',
        equipment: 'Haltere',
        difficulty: 'Intermediário',
        primaryMuscle: 'Quadríceps',
        secondaryMuscles: [
          'Glúteos',
          'Isquiotibiais'
        ],
        instructions: [
          'Dê um passo à frente',
          'Joelho traseiro quase toca o chão',
          'Empurre de volta à posição',
          'Alterne as pernas'
        ]),
    GymExercise(
        name: 'Stiff (Levantamento Terra Romeno)',
        muscleGroup: 'Pernas',
        equipment: 'Barra',
        difficulty: 'Intermediário',
        primaryMuscle: 'Isquiotibiais',
        secondaryMuscles: [
          'Glúteos',
          'Eretores da Espinha'
        ],
        instructions: [
          'Pernas semi-estendidas',
          'Desça a barra ao longo das pernas',
          'Sinta o alongamento dos isquiotibiais',
          'Suba contraindo os glúteos'
        ]),
    GymExercise(
        name: 'Panturrilha em Pé',
        muscleGroup: 'Pernas',
        equipment: 'Máquina',
        difficulty: 'Iniciante',
        primaryMuscle: 'Gastrocnêmio',
        secondaryMuscles: [
          'Sóleo'
        ],
        instructions: [
          'Ombros sob as almofdas',
          'Eleve os calcanhares ao máximo',
          'Segure no topo por 1s',
          'Desça estendendo bem'
        ]),
    GymExercise(
        name: 'Agachamento Búlgaro',
        muscleGroup: 'Pernas',
        equipment: 'Haltere',
        difficulty: 'Avançado',
        primaryMuscle: 'Quadríceps',
        secondaryMuscles: [
          'Glúteos'
        ],
        instructions: [
          'Pé traseiro no banco',
          'Desça o joelho frontal a 90°',
          'Empurre para subir',
          'Foque no equilíbrio'
        ]),
    GymExercise(
        name: 'Hack Squat',
        muscleGroup: 'Pernas',
        equipment: 'Máquina',
        difficulty: 'Intermediário',
        primaryMuscle: 'Quadríceps',
        secondaryMuscles: [
          'Glúteos'
        ],
        instructions: [
          'Costas apoiadas no encosto',
          'Pés na plataforma',
          'Desça controladamente',
          'Empurre sem travar'
        ]),

    // ═══════════════════ ABDÔMEN ═══════════════════
    GymExercise(
        name: 'Abdominal Crunch',
        muscleGroup: 'Abdômen',
        equipment: 'Peso Corporal',
        difficulty: 'Iniciante',
        primaryMuscle: 'Reto Abdominal',
        secondaryMuscles: [],
        instructions: [
          'Deite com joelhos flexionados',
          'Levante ombros do chão',
          'Contraia o abdômen',
          'Desça controladamente'
        ]),
    GymExercise(
        name: 'Prancha (Plank)',
        muscleGroup: 'Abdômen',
        equipment: 'Peso Corporal',
        difficulty: 'Iniciante',
        primaryMuscle: 'Core',
        secondaryMuscles: [
          'Reto Abdominal',
          'Oblíquos'
        ],
        instructions: [
          'Apoie antebraços e pontas dos pés',
          'Corpo reto como uma tábua',
          'Contraia o abdômen',
          'Mantenha por tempo'
        ]),
    GymExercise(
        name: 'Abdominal Infra (Elevação de Pernas)',
        muscleGroup: 'Abdômen',
        equipment: 'Peso Corporal',
        difficulty: 'Intermediário',
        primaryMuscle: 'Reto Abdominal Inferior',
        secondaryMuscles: [
          'Flexores do Quadril'
        ],
        instructions: [
          'Deite no banco ou chão',
          'Eleve as pernas estendidas',
          'Desça sem tocar o chão'
        ]),
    GymExercise(
        name: 'Abdominal Oblíquo (Bicicleta)',
        muscleGroup: 'Abdômen',
        equipment: 'Peso Corporal',
        difficulty: 'Intermediário',
        primaryMuscle: 'Oblíquos',
        secondaryMuscles: [
          'Reto Abdominal'
        ],
        instructions: [
          'Deite, mãos atrás da cabeça',
          'Cotovelo toca joelho oposto',
          'Alterne os lados',
          'Movimento de pedalar'
        ]),
    GymExercise(
        name: 'Abdominal na Máquina',
        muscleGroup: 'Abdômen',
        equipment: 'Máquina',
        difficulty: 'Iniciante',
        primaryMuscle: 'Reto Abdominal',
        secondaryMuscles: [],
        instructions: [
          'Ajuste o peso',
          'Flexione o tronco para frente',
          'Contraia o abdômen',
          'Retorne controladamente'
        ]),
    GymExercise(
        name: 'Prancha Lateral',
        muscleGroup: 'Abdômen',
        equipment: 'Peso Corporal',
        difficulty: 'Intermediário',
        primaryMuscle: 'Oblíquos',
        secondaryMuscles: [
          'Core'
        ],
        instructions: [
          'Apoie um antebraço',
          'Corpo em linha reta',
          'Quadril elevado',
          'Mantenha por tempo'
        ]),

    // ═══════════════════ GLÚTEOS ═══════════════════
    GymExercise(
        name: 'Hip Thrust',
        muscleGroup: 'Glúteos',
        equipment: 'Barra',
        difficulty: 'Intermediário',
        primaryMuscle: 'Glúteo Máximo',
        secondaryMuscles: [
          'Isquiotibiais'
        ],
        instructions: [
          'Costas apoiadas no banco',
          'Barra sobre o quadril',
          'Empurre o quadril até extensão completa',
          'Contraia glúteos no topo por 2s'
        ]),
    GymExercise(
        name: 'Elevação Pélvica',
        muscleGroup: 'Glúteos',
        equipment: 'Peso Corporal',
        difficulty: 'Iniciante',
        primaryMuscle: 'Glúteo Máximo',
        secondaryMuscles: [],
        instructions: [
          'Deite com pés no chão',
          'Eleve o quadril',
          'Contraia glúteos no topo',
          'Desça sem tocar o chão'
        ]),
    GymExercise(
        name: 'Abdução de Quadril na Máquina',
        muscleGroup: 'Glúteos',
        equipment: 'Máquina',
        difficulty: 'Iniciante',
        primaryMuscle: 'Glúteo Médio',
        secondaryMuscles: [],
        instructions: [
          'Sentada na máquina',
          'Abra as pernas contra a resistência',
          'Contraia no ponto máximo'
        ]),
    GymExercise(
        name: 'Kickback no Cabo',
        muscleGroup: 'Glúteos',
        equipment: 'Cabo',
        difficulty: 'Intermediário',
        primaryMuscle: 'Glúteo Máximo',
        secondaryMuscles: [
          'Isquiotibiais'
        ],
        instructions: [
          'Prenda a caneleira na polia baixa',
          'Estenda a perna para trás',
          'Contraia o glúteo no topo'
        ]),
    GymExercise(
        name: 'Agachamento Sumô',
        muscleGroup: 'Glúteos',
        equipment: 'Haltere',
        difficulty: 'Intermediário',
        primaryMuscle: 'Glúteos',
        secondaryMuscles: [
          'Adutores',
          'Quadríceps'
        ],
        instructions: [
          'Pés largos, pontas para fora',
          'Haltere entre as pernas',
          'Desça mantendo joelhos para fora',
          'Empurre para subir'
        ]),

    // ═══════════════════ ANTEBRAÇO ═══════════════════
    GymExercise(
        name: 'Rosca de Punho',
        muscleGroup: 'Antebraço',
        equipment: 'Barra',
        difficulty: 'Iniciante',
        primaryMuscle: 'Flexores do Antebraço',
        secondaryMuscles: [],
        instructions: [
          'Antebraços apoiados no banco',
          'Flexione os punhos para cima',
          'Desça controladamente'
        ]),
    GymExercise(
        name: 'Rosca Inversa de Punho',
        muscleGroup: 'Antebraço',
        equipment: 'Barra',
        difficulty: 'Iniciante',
        primaryMuscle: 'Extensores do Antebraço',
        secondaryMuscles: [],
        instructions: [
          'Pegada pronada',
          'Estenda os punhos para cima',
          'Controle a descida'
        ]),
    GymExercise(
        name: 'Farmer Walk',
        muscleGroup: 'Antebraço',
        equipment: 'Haltere',
        difficulty: 'Intermediário',
        primaryMuscle: 'Antebraço',
        secondaryMuscles: [
          'Core',
          'Trapézio'
        ],
        instructions: [
          'Segure halteres pesados',
          'Caminhe mantendo postura ereta',
          'Peito erguido, ombros para trás'
        ]),
    // ═══════════════════ CARDIO ═══════════════════
    GymExercise(
        name: 'Esteira (Corrida)',
        muscleGroup: 'Cardio',
        equipment: 'Máquina',
        difficulty: 'Iniciante',
        primaryMuscle: 'Pernas',
        secondaryMuscles: [
          'Coração'
        ],
        instructions: [
          'Mantenha postura ereta',
          'Passadas suaves',
          'Controle a respiração'
        ]),
    GymExercise(
        name: 'Bicicleta Ergométrica',
        muscleGroup: 'Cardio',
        equipment: 'Máquina',
        difficulty: 'Iniciante',
        primaryMuscle: 'Quadríceps',
        secondaryMuscles: [
          'Coração'
        ],
        instructions: [
          'Ajuste o banco na altura do quadril',
          'Pedale mantendo ritmo constante'
        ]),
    GymExercise(
        name: 'Elíptico',
        muscleGroup: 'Cardio',
        equipment: 'Máquina',
        difficulty: 'Iniciante',
        primaryMuscle: 'Pernas',
        secondaryMuscles: [
          'Coração'
        ],
        instructions: [
          'Segure nas hastes móveis',
          'Movimento fluido de corrida sem impacto'
        ]),
    GymExercise(
        name: 'Pular Corda',
        muscleGroup: 'Cardio',
        equipment: 'Peso Corporal',
        difficulty: 'Intermediário',
        primaryMuscle: 'Panturrilha',
        secondaryMuscles: [
          'Coração',
          'Ombros'
        ],
        instructions: [
          'Pule nas pontas dos pés',
          'Gire a corda com os punhos'
        ]),
    GymExercise(
        name: 'Remo (Ergômetro)',
        muscleGroup: 'Cardio',
        equipment: 'Máquina',
        difficulty: 'Intermediário',
        primaryMuscle: 'Costas',
        secondaryMuscles: [
          'Pernas',
          'Coração'
        ],
        instructions: [
          'Empurre com as pernas',
          'Puxe com os braços',
          'Retorne em ordem inversa'
        ]),

    // ═══════════════════ FULL BODY / CROSSFIT ═══════════════════
    GymExercise(
        name: 'Burpee',
        muscleGroup: 'Full Body',
        equipment: 'Peso Corporal',
        difficulty: 'Avançado',
        primaryMuscle: 'Pernas',
        secondaryMuscles: [
          'Peito',
          'Ombros',
          'Coração'
        ],
        instructions: [
          'Agache e apoie as mãos',
          'Jogue os pés para trás',
          'Faça uma flexão',
          'Pule para frente e salte'
        ]),
    GymExercise(
        name: 'Thruster',
        muscleGroup: 'Full Body',
        equipment: 'Barra',
        difficulty: 'Avançado',
        primaryMuscle: 'Quadríceps',
        secondaryMuscles: [
          'Ombros',
          'Tríceps'
        ],
        instructions: [
          'Agachamento frontal',
          'Na subida, empurre a barra acima da cabeça em um movimento fluido'
        ]),
    GymExercise(
        name: 'Kettlebell Swing',
        muscleGroup: 'Full Body',
        equipment: 'Kettlebell',
        difficulty: 'Intermediário',
        primaryMuscle: 'Glúteos',
        secondaryMuscles: [
          'Isquiotibiais',
          'Ombros'
        ],
        instructions: [
          'Segure o KB com as duas mãos',
          'Faça um movimento de pêndulo com o quadril',
          'Contraia glúteos no topo'
        ]),
    GymExercise(
        name: 'Box Jump',
        muscleGroup: 'Pernas',
        equipment: 'Peso Corporal',
        difficulty: 'Intermediário',
        primaryMuscle: 'Quadríceps',
        secondaryMuscles: [
          'Panturrilha'
        ],
        instructions: [
          'Salte com os dois pés na caixa',
          'Estenda o quadril no topo',
          'Desça com cuidado'
        ]),
    GymExercise(
        name: 'Wall Ball',
        muscleGroup: 'Full Body',
        equipment: 'Bola',
        difficulty: 'Intermediário',
        primaryMuscle: 'Quadríceps',
        secondaryMuscles: [
          'Ombros'
        ],
        instructions: [
          'Segure a bola no peito',
          'Agache completo',
          'Na subida, jogue a bola no alvo'
        ]),
    GymExercise(
        name: 'Clean and Jerk',
        muscleGroup: 'Full Body',
        equipment: 'Barra',
        difficulty: 'Elite',
        primaryMuscle: 'Pernas',
        secondaryMuscles: [
          'Ombros',
          'Costas'
        ],
        instructions: [
          'Tire a barra do chão até os ombros (Clean)',
          'Empurre acima da cabeça (Jerk)'
        ]),
    GymExercise(
        name: 'Snatch',
        muscleGroup: 'Full Body',
        equipment: 'Barra',
        difficulty: 'Elite',
        primaryMuscle: 'Costas',
        secondaryMuscles: [
          'Ombros',
          'Pernas'
        ],
        instructions: [
          'Puxe a barra do chão direto para cima da cabeça em um movimento único'
        ]),
  ];

  /// Templates de treino pré-definidos.
  static const workoutTemplates = {
    'Push/Pull/Legs': {
      0: 'Push (Peito + Ombros + Tríceps)',
      1: 'Pull (Costas + Bíceps)',
      2: 'Legs (Pernas + Glúteos)',
      3: 'Push (Peito + Ombros + Tríceps)',
      4: 'Pull (Costas + Bíceps)',
      5: 'Legs (Pernas + Glúteos)',
      6: 'Descanso',
    },
    'ABC': {
      0: 'A - Peito + Tríceps',
      1: 'B - Costas + Bíceps',
      2: 'C - Pernas + Ombros',
      3: 'A - Peito + Tríceps',
      4: 'B - Costas + Bíceps',
      5: 'C - Pernas + Ombros',
      6: 'Descanso',
    },
    'ABCDE': {
      0: 'A - Peito',
      1: 'B - Costas',
      2: 'C - Pernas',
      3: 'D - Ombros + Trapézio',
      4: 'E - Braços',
      5: 'Descanso',
      6: 'Descanso',
    },
    'Upper/Lower': {
      0: 'Upper (Tronco)',
      1: 'Lower (Pernas + Glúteos)',
      2: 'Descanso',
      3: 'Upper (Tronco)',
      4: 'Lower (Pernas + Glúteos)',
      5: 'Descanso',
      6: 'Descanso',
    },
    'Full Body 3x': {
      0: 'Full Body',
      1: 'Descanso',
      2: 'Full Body',
      3: 'Descanso',
      4: 'Full Body',
      5: 'Descanso',
      6: 'Descanso',
    },
  };
}
