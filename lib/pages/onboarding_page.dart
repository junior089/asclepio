import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/app_provider.dart';
import '../theme/asclepio_theme.dart';
import '../widgets/health_components.dart';
import '../main.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageCtrl = PageController();
  int _currentPage = 0;
  bool _saving = false;

  // ── Data ───────────────────────────────────────────────────────────────────
  final _nameCtrl = TextEditingController();
  int _age = 25;
  String _gender = 'Male';
  double _weight = 70.0;
  double _height = 175.0;

  // Advanced Fields
  String _activityLevel =
      'Moderate'; // Sedentary, Light, Moderate, Active, Athlete
  final List<String> _injuries = [];
  final List<String> _goals = [];
  String _equipment = 'Gym'; // Gym, Home (Dumbbells), Bodyweight

  static const _activityLevels = [
    {'id': 'Sedentary', 'title': 'Rookie', 'desc': 'Little to no exercise'},
    {'id': 'Light', 'title': 'Beginner', 'desc': '1-3 days/week'},
    {'id': 'Moderate', 'title': 'Intermediate', 'desc': '3-5 days/week'},
    {'id': 'Active', 'title': 'Advanced', 'desc': '6-7 days/week'},
    {'id': 'Athlete', 'title': 'Elite', 'desc': 'Professional training'},
  ];

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < 5) {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _pageCtrl.previousPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic);
    }
  }

  Future<void> _finish() async {
    if (_nameCtrl.text.isEmpty) {
      // Should have been validated earlier, but safeguard
      _pageCtrl.animateToPage(1,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      return;
    }

    setState(() => _saving = true);

    // Save to Provider & Supabase
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid != null) {
        final data = {
          'id': uid,
          'name': _nameCtrl.text.trim(),
          'age': _age,
          'gender': _gender,
          'weight': _weight,
          'height': _height,
          'activity_level': _activityLevel,
          'goals': _goals,
          'injuries': _injuries,
          'equipment_access': _equipment,
          'onboarding_completed': true,
          'updated_at': DateTime.now().toIso8601String(),
        };

        await Supabase.instance.client.from('profiles').upsert(data);

        // Also update local provider
        if (mounted) {
          await context.read<AppProvider>().loadFromSupabase();
        }
      }

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving profile: $e'),
        backgroundColor: AsclepioTheme.error,
      ));
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Progress calculation
    final progress = (_currentPage + 1) / 6;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header (Progress) ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      onPressed: _back,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.1),
                        valueColor:
                            const AlwaysStoppedAnimation(AsclepioTheme.primary),
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${_currentPage + 1}/6',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──────────────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _stepWelcome(),
                  _stepIdentity(),
                  _stepBody(),
                  _stepActivity(),
                  _stepConditions(), // Injuries etc
                  _stepGoals(), // Equipment & Goals
                ],
              ),
            ),

            // ── Footer ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: GradientButton(
                text: _currentPage == 5 ? 'COMPLETE SETUP' : 'CONTINUE',
                onPressed: _saving ? null : _next,
                isLoading: _saving,
                icon: _currentPage == 5 ? Icons.check : Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step 0: Welcome ────────────────────────────────────────────────────────
  Widget _stepWelcome() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user_outlined,
              size: 80, color: AsclepioTheme.primary),
          const SizedBox(height: 32),
          Text(
            "LET'S BUILD YOUR\nPROFILE",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            "To customize your training plan, we need to know your stats, limits, and ambitions.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // ── Step 1: Identity ───────────────────────────────────────────────────────
  Widget _stepIdentity() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("WHO ARE YOU?", style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 32),
          TextFormField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              labelText: 'Display Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 24),
          Text("Date of Birth (Age: $_age)",
              style: Theme.of(context).textTheme.labelLarge),
          Slider(
            value: _age.toDouble(),
            min: 14,
            max: 80,
            activeColor: AsclepioTheme.primary,
            onChanged: (v) => setState(() => _age = v.round()),
          ),
          const SizedBox(height: 24),
          Text("Biologic Sex", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          Row(
            children: ['Male', 'Female'].map((g) {
              final selected = _gender == g;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _gender = g),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected
                          ? AsclepioTheme.primary
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: selected
                          ? null
                          : Border.all(color: Theme.of(context).dividerColor),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      g.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selected
                            ? Colors.black
                            : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Step 2: Body Stats ─────────────────────────────────────────────────────
  Widget _stepBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("BODY STATS", style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 16),
          Text(
              "Accurate data helps us calculate your calorie burn and metabolic rate.",
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 40),
          _statCard('Weight', '${_weight.toStringAsFixed(1)} kg', _weight, 30,
              200, (v) => setState(() => _weight = v)),
          const SizedBox(height: 24),
          _statCard('Height', '${_height.toStringAsFixed(0)} cm', _height, 100,
              230, (v) => setState(() => _height = v)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, double current, double min,
      double max, Function(double) onChange) {
    return HealthCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: AsclepioTheme.primary)),
            ],
          ),
          Slider(
            value: current,
            min: min,
            max: max,
            activeColor: AsclepioTheme.primary,
            onChanged: onChange,
          ),
        ],
      ),
    );
  }

  // ── Step 3: Activity Level ─────────────────────────────────────────────────
  Widget _stepActivity() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ACTIVITY LEVEL",
              style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 32),
          ..._activityLevels.map((lvl) {
            final selected = _activityLevel == lvl['id'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HealthCard(
                onTap: () => setState(() => _activityLevel = lvl['id']!),
                color: selected ? AsclepioTheme.primary : null,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lvl['title']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: selected
                                  ? Colors.black
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                            ),
                          ),
                          Text(
                            lvl['desc']!,
                            style: TextStyle(
                              color: selected
                                  ? Colors.black.withValues(alpha: 0.7)
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      const Icon(Icons.check_circle, color: Colors.black),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Step 4: Injuries ───────────────────────────────────────────────────────
  Widget _stepConditions() {
    final bodyParts = [
      'Shoulders',
      'Lower Back',
      'Knees',
      'Wrists',
      'Ankles',
      'Neck'
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ANY LIMITATIONS?",
              style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 16),
          Text("We'll avoid exercises that stress these areas.",
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: bodyParts.map((part) {
              final selected = _injuries.contains(part);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) {
                    _injuries.remove(part);
                  } else {
                    _injuries.add(part);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected
                        ? AsclepioTheme.error.withValues(alpha: 0.2)
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? AsclepioTheme.error
                          : Theme.of(context).dividerColor,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(part,
                          style: TextStyle(
                            color: selected
                                ? AsclepioTheme.error
                                : Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold,
                          )),
                      if (selected) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.close,
                            size: 16, color: AsclepioTheme.error),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Step 5: Goals & Equipment ──────────────────────────────────────────────
  Widget _stepGoals() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("FINAL SETUP", style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 32),

          Text("Equipment Access",
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          _radioOption('Gym', 'Full access to machines & weights'),
          _radioOption('Home (Dumbbells)', 'Basic free weights'),
          _radioOption('Bodyweight', 'No equipment needed'),

          const SizedBox(height: 32),
          Text("Primary Goal", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
          // Simple multi-select via chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Build Muscle',
              'Lose Fat',
              'Strength',
              'Endurance',
              'Flexibility'
            ].map((g) {
              final selected = _goals.contains(g);
              return FilterChip(
                label: Text(g),
                selected: selected,
                selectedColor: AsclepioTheme.primary,
                labelStyle: TextStyle(
                    color: selected ? Colors.black : null,
                    fontWeight: FontWeight.bold),
                checkmarkColor: Colors.black,
                onSelected: (v) => setState(() {
                  if (v) {
                    _goals.add(g);
                  } else {
                    _goals.remove(g);
                  }
                }),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _radioOption(String val, String desc) {
    final selected = _equipment == val;
    return GestureDetector(
      onTap: () => setState(() => _equipment = val),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AsclepioTheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected
                  ? AsclepioTheme.primary
                  : Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected
                  ? AsclepioTheme.primary
                  : Theme.of(context).disabledColor,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(desc,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
