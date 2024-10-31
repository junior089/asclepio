import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CleaningProductsPage extends StatefulWidget {
  const CleaningProductsPage({Key? key}) : super(key: key);

  @override
  _CleaningProductsPageState createState() => _CleaningProductsPageState();
}

class _CleaningProductsPageState extends State<CleaningProductsPage> {
  final List<String> products = [
    'Água Sanitária',
    'Amônia',
    'Detergente',
    'Vinagre',
    'Bicarbonato de Sódio',
    'Álcool',
    'Desinfetante',
    'Sabão em Barra',
    'Limpa Vidros',
    'Desengordurante',
    'Multiuso',
  ];

  String selectedProduct1 = 'Água Sanitária';
  String selectedProduct2 = 'Amônia';
  String result = '';
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cleaning_services, color: Colors.blueGrey[800]),
            SizedBox(width: 10),
            Text(
              'Mistura de Produtos',
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Verifique a mistura de produtos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildProductDropdown('Produto 1', selectedProduct1, (newValue) {
                setState(() {
                  selectedProduct1 = newValue!;
                  result = _checkMixing(selectedProduct1, selectedProduct2);
                });
              }),
              SizedBox(height: 15),
              _buildProductDropdown('Produto 2', selectedProduct2, (newValue) {
                setState(() {
                  selectedProduct2 = newValue!;
                  result = _checkMixing(selectedProduct1, selectedProduct2);
                });
              }),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      result = _checkMixing(selectedProduct1, selectedProduct2);
                      if (!history.contains('$selectedProduct1 + $selectedProduct2')) {
                        history.add('$selectedProduct1 + $selectedProduct2: $result');
                        _saveHistory();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.grey[400],
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    textStyle: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  child: Text('Verificar Mistura'),
                ),
              ),
              SizedBox(height: 20),
              if (result.isNotEmpty)
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: result.contains('perigosa') ? Colors.red[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: result.contains('perigosa') ? Colors.red : Colors.green, width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        result.contains('perigosa') ? Icons.warning : Icons.check_circle,
                        color: result.contains('perigosa') ? Colors.red : Colors.green,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          result,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: result.contains('perigosa') ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              Text(
                'Histórico de Misturas:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 350,
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          history[index],
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              history.removeAt(index);
                              _saveHistory();
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

}

  DropdownButton<String> _buildProductDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      isExpanded: true,
      value: value,
      onChanged: onChanged,
      items: products.map<DropdownMenuItem<String>>((String product) {
        return DropdownMenuItem<String>(
          value: product,
          child: Text(product),
        );
      }).toList(),
      hint: Text(label),
      underline: Container(
        height: 2,
        color: Colors.lightBlue[300],
      ),
      style: TextStyle(fontSize: 16, color: Colors.blueGrey[800]),
    );
  }

  String _checkMixing(String product1, String product2) {
    if ((product1 == 'Água Sanitária' && product2 == 'Amônia') ||
        (product1 == 'Amônia' && product2 == 'Água Sanitária')) {
      return 'Mistura perigosa: pode gerar gases tóxicos!';
    }
    return 'Mistura segura.';
  }

  void _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList('mixHistory') ?? [];
    });
  }

  void _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('mixHistory', history);
  }
}
