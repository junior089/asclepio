import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _stepsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Atividade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _stepsController,
                decoration: InputDecoration(
                  labelText: 'Número de Passos',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número de passos';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Salvar a atividade
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar Atividade'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
