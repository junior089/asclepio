import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';

class DiseaseOutbreak {
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String type;
  final IconData icon;
  final Color color;

  DiseaseOutbreak({
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.type,
    required this.icon,
    required this.color,
  });
}

class DiseaseOutbreaksPage extends StatefulWidget {
  const DiseaseOutbreaksPage({super.key});

  @override
  State<DiseaseOutbreaksPage> createState() => _DiseaseOutbreaksPageState();
}

class _DiseaseOutbreaksPageState extends State<DiseaseOutbreaksPage> {
  // Lista original — nunca modificada pela busca
  final List<DiseaseOutbreak> _allOutbreaks = [
    DiseaseOutbreak(
      title: 'Surto de Dengue',
      description:
          'Aumento de casos de dengue na região metropolitana. Procure eliminar focos de água parada.',
      location: 'São Paulo, SP',
      date: DateTime(2025, 1, 10),
      type: 'Dengue',
      icon: Icons.bug_report,
      color: Colors.orange,
    ),
    DiseaseOutbreak(
      title: 'Influenza H3N2',
      description:
          'Surto de gripe H3N2 afetando principalmente idosos e crianças. Vacinação disponível.',
      location: 'Rio de Janeiro, RJ',
      date: DateTime(2025, 1, 5),
      type: 'Gripe',
      icon: Icons.coronavirus,
      color: Colors.blue,
    ),
    DiseaseOutbreak(
      title: 'Leptospirose',
      description:
          'Casos de leptospirose após enchentes. Evite contato com água de enchente.',
      location: 'Porto Alegre, RS',
      date: DateTime(2024, 12, 20),
      type: 'Leptospirose',
      icon: Icons.water_damage,
      color: Colors.brown,
    ),
    DiseaseOutbreak(
      title: 'Chikungunya',
      description:
          'Aumento de casos de chikungunya. Use repelente e roupas compridas.',
      location: 'Recife, PE',
      date: DateTime(2024, 12, 15),
      type: 'Chikungunya',
      icon: Icons.pest_control,
      color: Colors.red,
    ),
    DiseaseOutbreak(
      title: 'Sarampo',
      description:
          'Casos confirmados de sarampo. Verifique sua carteira de vacinação.',
      location: 'Manaus, AM',
      date: DateTime(2024, 11, 30),
      type: 'Sarampo',
      icon: Icons.sick,
      color: Colors.purple,
    ),
    DiseaseOutbreak(
      title: 'Meningite Viral',
      description:
          'Surto de meningite viral em escolas. Lave as mãos frequentemente.',
      location: 'Belo Horizonte, MG',
      date: DateTime(2024, 11, 20),
      type: 'Meningite',
      icon: Icons.medical_services,
      color: Colors.teal,
    ),
  ];

  List<DiseaseOutbreak> _filteredOutbreaks = [];
  String _searchQuery = '';
  String _selectedType = 'Todos';

  @override
  void initState() {
    super.initState();
    _filteredOutbreaks = List.from(_allOutbreaks);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onTypeChanged(String type) {
    setState(() {
      _selectedType = type;
      _applyFilters();
    });
  }

  void _applyFilters() {
    // Sempre filtra sobre a lista original
    _filteredOutbreaks = _allOutbreaks.where((o) {
      final matchesSearch = _searchQuery.isEmpty ||
          o.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          o.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          o.type.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == 'Todos' || o.type == _selectedType;
      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final types = [
      'Todos',
      ...{..._allOutbreaks.map((o) => o.type)}
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas de Saúde'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red[700],
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                TextField(
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar surtos...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: types.map((type) {
                      final isSelected = _selectedType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (_) => _onTypeChanged(type),
                          selectedColor: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.red[700] : Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Aviso de dados simulados
          Container(
            width: double.infinity,
            color: Colors.amber[100],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dados simulados para demonstração. Consulte fontes oficiais.',
                    style: TextStyle(fontSize: 12, color: Colors.brown),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _filteredOutbreaks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 56, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('Nenhum surto encontrado.',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredOutbreaks.length,
                    itemBuilder: (context, index) {
                      final outbreak = _filteredOutbreaks[index];
                      return _buildOutbreakCard(outbreak);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutbreakCard(DiseaseOutbreak outbreak) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showOutbreakDetail(outbreak),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: outbreak.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(outbreak.icon, color: outbreak.color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            outbreak.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: outbreak.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            outbreak.type,
                            style: TextStyle(
                                fontSize: 11,
                                color: outbreak.color,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      outbreak.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(outbreak.location,
                            style: const TextStyle(
                                fontSize: 12, color: AppTheme.textSecondary)),
                        const Spacer(),
                        const Icon(Icons.calendar_today_outlined,
                            size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM/yyyy').format(outbreak.date),
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOutbreakDetail(DiseaseOutbreak outbreak) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(outbreak.icon, color: outbreak.color, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    outbreak.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(outbreak.description,
                style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 16),
            _detailRow(Icons.location_on_outlined, 'Local', outbreak.location),
            _detailRow(Icons.calendar_today_outlined, 'Data',
                DateFormat('dd/MM/yyyy').format(outbreak.date)),
            _detailRow(Icons.category_outlined, 'Tipo', outbreak.type),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
