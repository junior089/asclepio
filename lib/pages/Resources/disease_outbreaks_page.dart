import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Saúde',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DiseaseOutbreaksPage(),
    );
  }
}

class DiseaseOutbreak {
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String type; // Tipo do surto (Gripe, Dengue, etc.)

  DiseaseOutbreak({
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.type,
  });
}

class DiseaseOutbreaksPage extends StatefulWidget {
  @override
  _DiseaseOutbreaksPageState createState() => _DiseaseOutbreaksPageState();
}

class _DiseaseOutbreaksPageState extends State<DiseaseOutbreaksPage> {
  List<DiseaseOutbreak> filteredOutbreaks = [];
  String searchQuery = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOutbreaks();
  }

  Future<void> _fetchOutbreaks() async {
    setState(() {
      isLoading = true;
    });

    // Simulação de uma chamada a uma API
    await Future.delayed(Duration(seconds: 2)); // Simula atraso de rede

    // Simulação de dados retornados pela API
    List<DiseaseOutbreak> outbreaks = [
      DiseaseOutbreak(
        title: 'Surto de Gripe',
        description: 'Aumento de casos de gripe na região.',
        location: 'São Paulo, SP',
        date: DateTime.now().subtract(Duration(days: 1)),
        type: 'Gripe',
      ),
      DiseaseOutbreak(
        title: 'Epidemia de Dengue',
        description: 'Casos elevados de dengue registrados.',
        location: 'Rio de Janeiro, RJ',
        date: DateTime.now().subtract(Duration(days: 5)),
        type: 'Dengue',
      ),
      DiseaseOutbreak(
        title: 'Alerta de COVID-19',
        description: 'Aumento de casos confirmados de COVID-19.',
        location: 'Belo Horizonte, MG',
        date: DateTime.now().subtract(Duration(days: 10)),
        type: 'COVID-19',
      ),
    ];

    setState(() {
      filteredOutbreaks = outbreaks; // Atualiza a lista filtrada
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alertas de Surtos de Doenças'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisar...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                  filteredOutbreaks = filteredOutbreaks.where((outbreak) {
                    return outbreak.title.toLowerCase().contains(searchQuery) ||
                        outbreak.location.toLowerCase().contains(searchQuery) ||
                        outbreak.description.toLowerCase().contains(searchQuery) ||
                        outbreak.type.toLowerCase().contains(searchQuery);
                  }).toList();
                });
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildInfoBanner(),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: filteredOutbreaks.length,
                itemBuilder: (context, index) {
                  return _buildOutbreakCard(filteredOutbreaks[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue),
      ),
      child: Text(
        'Fique atento aos surtos de doenças na sua região. Mantenha-se informado!',
        style: TextStyle(fontSize: 16, color: Colors.blue[800]),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOutbreakCard(DiseaseOutbreak outbreak) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(outbreak.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(outbreak.description),
            Text('Local: ${outbreak.location}'),
            Text('Data: ${outbreak.date.toLocal().toString().split(' ')[0]}'),
          ],
        ),
        leading: _getLeadingIcon(outbreak.type),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OutbreakDetailPage(outbreak: outbreak),
            ),
          ).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Detalhes carregados com sucesso!')),
            );
          });
        },
      ),
    );
  }

  Icon _getLeadingIcon(String type) {
    switch (type) {
      case 'Gripe':
        return Icon(Icons.sick, color: Colors.blue);
      case 'Dengue':
        return Icon(Icons.warning, color: Colors.yellow);
      case 'COVID-19':
        return Icon(Icons.health_and_safety, color: Colors.red);
      default:
        return Icon(Icons.info);
    }
  }
}

class OutbreakDetailPage extends StatelessWidget {
  final DiseaseOutbreak outbreak;

  OutbreakDetailPage({required this.outbreak});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(outbreak.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(outbreak.description),
            SizedBox(height: 16.0),
            Text('Localização: ${outbreak.location}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text('Data: ${outbreak.date.toLocal().toString().split(' ')[0]}', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
