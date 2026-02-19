import 'package:flutter/material.dart';
import '../../theme/asclepio_theme.dart';
import 'tabs/gym_routines_tab.dart';
import 'tabs/gym_library_tab.dart';
import 'tabs/gym_history_tab.dart';

class GymPage extends StatefulWidget {
  const GymPage({super.key});

  @override
  State<GymPage> createState() => _GymPageState();
}

class _GymPageState extends State<GymPage> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Workspace'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AsclepioTheme.primary,
          labelColor: AsclepioTheme.primary,
          unselectedLabelColor: Theme.of(context).disabledColor,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Routines'),
            Tab(text: 'Library'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: const [
          GymRoutinesTab(),
          GymLibraryTab(),
          GymHistoryTab(),
        ],
      ),
    );
  }
}
