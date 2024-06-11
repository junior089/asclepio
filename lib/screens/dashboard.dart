import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total de Passos Hoje:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '5000', // Exemplo de dados
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.directions_walk, color: Colors.teal, size: 30),
              title: Text('Registrar Atividade'),
              onTap: () {
                Navigator.pushNamed(context, '/activity');
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 20),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.flag, color: Colors.teal, size: 30),
              title: Text('Ver Metas'),
              onTap: () {
                Navigator.pushNamed(context, '/goals');
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 20),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person, color: Colors.teal, size: 30),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              trailing: Icon(Icons.arrow_forward_ios, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
