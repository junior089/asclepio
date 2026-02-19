import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/asclepio_theme.dart';
import '../widgets/health_components.dart';
import 'onboarding_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  bool _loading = false;
  bool _obscure = true;

  // Controllers
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  // Animation
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _snack('Preencha os campos', isError: true);
      return;
    }
    if (pass.length < 6) {
      _snack('Senha muito curta (mínimo 6)', isError: true);
      return;
    }

    setState(() => _loading = true);

    try {
      if (_isLogin) {
        await Supabase.instance.client.auth
            .signInWithPassword(email: email, password: pass);
      } else {
        await Supabase.instance.client.auth
            .signUp(email: email, password: pass);
      }

      if (!mounted) return;
      // Success transition
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingPage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    } on AuthException catch (e) {
      _snack(e.message, isError: true);
    } catch (e) {
      _snack('Erro inesperado', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: isError ? AsclepioTheme.error : AsclepioTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nike Fit style: Clean, dark/light integrated or full screen imagery.
      // We will use a subtle animated gradient background or solid premium color.
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Element (Subtle Blob/Gradient)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AsclepioTheme.primary.withValues(alpha: 0.3),
                    AsclepioTheme.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Logo Section ────────────────────────────────────────
                      const Icon(Icons.fitness_center_rounded,
                          size: 48, color: AsclepioTheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        'ASCLÉPIO',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  letterSpacing: 4,
                                  fontSize: 28,
                                ),
                      ),
                      Text(
                        'ELITE TRAINING',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                              letterSpacing: 2,
                            ),
                      ),

                      const SizedBox(height: 60),

                      // ── Toggle ──────────────────────────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withValues(alpha: 0.1)),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            _toggleBtn('Login', true),
                            _toggleBtn('Sign Up', false),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── Inputs ──────────────────────────────────────────────
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isLogin
                            ? const SizedBox.shrink()
                            : Column(
                                key: const ValueKey('signup_fields'),
                                children: [
                                  TextFormField(
                                    controller: _nameCtrl,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: const InputDecoration(
                                      labelText: 'FULL NAME',
                                      prefixIcon: Icon(Icons.person_outline),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                      ),

                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'EMAIL',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── Action ──────────────────────────────────────────────
                      GradientButton(
                        text: _isLogin ? 'UNLOCK ACCESSS' : 'JOIN THE CLUB',
                        onPressed: _submit,
                        isLoading: _loading,
                        icon: Icons.arrow_forward,
                      ),

                      const SizedBox(height: 24),

                      if (_isLogin)
                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleBtn(String title, bool isLoginBtn) {
    final active = _isLogin == isLoginBtn;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isLogin = isLoginBtn),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active
                ? Theme.of(context).scaffoldBackgroundColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active ? AsclepioTheme.shadowSm : [],
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: active
                  ? AsclepioTheme.textPrimaryLight
                  : Theme.of(context).disabledColor,
            ),
          ),
        ),
      ),
    );
  }
}
