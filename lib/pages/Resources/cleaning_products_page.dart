import 'package:flutter/material.dart';

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

  final List<String> brands = [
    'Qboa',
    'Ypê',
    'Veja',
    'Cocamil',
    'Brilhus',
    'Limpeza 10',
    'São Jorge',
  ];

  final List<String> cleaningTips = [
    'Misture água sanitária com água para desinfetar superfícies.',
    'Use vinagre para limpar janelas e espelhos para um brilho sem manchas.',
    'Bicarbonato de sódio é ótimo para remover odores de tapetes e estofados.',
    'Aplique desengordurante em superfícies de cozinha para remover a gordura.',
    'Álcool pode ser usado para desinfetar teclados e outros eletrônicos.',
    'Use detergente em água morna para lavar louças mais eficientemente.',
    'Misturar detergente com vinagre pode ajudar a remover manchas difíceis.',
  ];

  String selectedProduct1 = 'Água Sanitária';
  String selectedProduct2 = 'Amônia';
  String result = '';
  List<String> history = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mistura de Produtos de Limpeza'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verifique a mistura de produtos de limpeza',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
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
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Verificar Mistura',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (result.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: result.contains('perigosa') ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: result.contains('perigosa') ? Colors.red : Colors.green, width: 2),
                ),
                child: Text(
                  result,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: result.contains('perigosa') ? Colors.red : Colors.green,
                  ),
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
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Dicas de Limpeza:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cleaningTips.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        cleaningTips[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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

  void _handleBrandAction(String brand) {
    String message;
    switch (brand) {
      case 'Qboa':
        message = 'Você selecionou a marca Qboa. Conheça os melhores produtos para limpeza!';
        break;
      case 'Ypê':
        message = 'Você selecionou a marca Ypê. A escolha perfeita para sua casa!';
        break;
      case 'Veja':
        message = 'Você selecionou a marca Veja. Limpeza eficaz garantida!';
        break;
      case 'Cocamil':
        message = 'Você selecionou a marca Cocamil. Produtos de alta qualidade!';
        break;
      case 'Brilhus':
        message = 'Você selecionou a marca Brilhus. A força que sua casa precisa!';
        break;
      case 'Limpeza 10':
        message = 'Você selecionou a marca Limpeza 10. Praticidade e eficiência!';
        break;
      case 'São Jorge':
        message = 'Você selecionou a marca São Jorge. Qualidade que você confia!';
        break;
      default:
        message = 'Marca desconhecida.';
    }
    // Exibe uma mensagem ao usuário
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }
}
