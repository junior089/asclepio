import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/app_provider.dart';
import 'theme/asclepio_theme.dart';
import 'pages/health_dashboard.dart';
import 'pages/exercise_page.dart';
import 'pages/Resources/resources_page.dart';
import 'pages/Profile/profile_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: '.env');

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(const AsclepioApp());
}

class AsclepioApp extends StatelessWidget {
  const AsclepioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'Asclépio',
        theme: AsclepioTheme.light,
        darkTheme: AsclepioTheme.dark,
        themeMode: ThemeMode.system,
        home: const AuthGate(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// Decide a tela inicial baseado no estado de auth.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return const AuthPage();
    }
    // Usuário logado → verificar se completou onboarding
    return FutureBuilder<Map<String, dynamic>?>(
      future: Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', session.user.id)
          .maybeSingle(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AsclepioTheme.backgroundLight,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AsclepioTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AsclepioTheme.shadowNeon,
                    ),
                    child: const Icon(Icons.favorite_rounded,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'ASCLÉPIO',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: AsclepioTheme.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sua saúde em primeiro lugar',
                    style: TextStyle(
                      fontSize: 14,
                      color: AsclepioTheme.textSecondaryLight,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AsclepioTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final profile = snapshot.data;
        if (profile == null || profile['onboarding_completed'] != true) {
          return const OnboardingPage();
        }
        // Carregar dados do perfil no provider
        context.read<AppProvider>().loadFromSupabase();
        return const MainScreen();
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _navAnimCtrl;
  late final Animation<double> _navAnim;

  static const List<Widget> _pages = [
    HealthDashboard(),
    ExercisePage(),
    ResourcesPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _navAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _navAnim = CurvedAnimation(parent: _navAnimCtrl, curve: Curves.easeOut);
    _navAnimCtrl.forward();
  }

  @override
  void dispose() {
    _navAnimCtrl.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    _navAnimCtrl.reset();
    setState(() => _currentIndex = index);
    _navAnimCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _navAnim,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: AsclepioTheme.shadowSm,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AsclepioTheme.primary,
          unselectedItemColor: Theme.of(context).disabledColor,
          items: [
            _navItem(Icons.dashboard_rounded, 'Início', 0),
            _navItem(Icons.fitness_center_rounded, 'Exercícios', 1),
            _navItem(Icons.grid_view_rounded, 'Recursos', 2),
            _navItem(Icons.person_rounded, 'Perfil', 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: _currentIndex == index ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
