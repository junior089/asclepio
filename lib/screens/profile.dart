import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'João Silva';
  int age = 30;
  double height = 180.0; // em cm
  double weight = 75.0; // em kg
  String gender = 'Masculino';
  File? _avatarImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = userName;
    _ageController.text = age.toString();
    _heightController.text = height.toString();
    _weightController.text = weight.toString();
    _genderController.text = gender;
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double bmi = _calculateIMC(height, weight);

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _avatarImage != null
                        ? FileImage(_avatarImage!)
                        : NetworkImage('https://example.com/default_avatar.jpg') as ImageProvider,
                    child: _avatarImage == null
                        ? Icon(Icons.camera_alt, size: 30, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: ListTile(
                  leading: Icon(Icons.person, color: const Color.fromARGB(255, 150, 0, 0)),
                  title: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nome'),
                    style: TextStyle(fontSize: 20),
                    onSubmitted: (value) {
                      setState(() {
                        userName = value;
                      });
                    },
                  ),
                ),
              ),
              _buildProfileInfoCard('Idade', _ageController, Icons.cake, (value) {
                setState(() {
                  age = int.tryParse(value) ?? age;
                });
              }),
              _buildProfileInfoCard('Altura (cm)', _heightController, Icons.height, (value) {
                setState(() {
                  height = double.tryParse(value) ?? height;
                });
              }),
              _buildProfileInfoCard('Peso (kg)', _weightController, Icons.fitness_center, (value) {
                setState(() {
                  weight = double.tryParse(value) ?? weight;
                });
              }),
              _buildProfileInfoCard('Gênero', _genderController, Icons.wc, (value) {
                setState(() {
                  gender = value;
                });
              }),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: ListTile(
                  leading: Icon(Icons.calculate, color: const Color.fromARGB(255, 150, 0, 0)),
                  title: Text('IMC: ${bmi.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    userName = _nameController.text;
                    age = int.tryParse(_ageController.text) ?? age;
                    height = double.tryParse(_heightController.text) ?? height;
                    weight = double.tryParse(_weightController.text) ?? weight;
                    gender = _genderController.text;
                  });
                },
                child: Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard(String label, TextEditingController controller, IconData icon, ValueChanged<String> onSubmitted) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 150, 0, 0)),
        title: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          style: TextStyle(fontSize: 20),
          onSubmitted: onSubmitted,
          keyboardType: label == 'Idade' || label.contains('Altura') || label.contains('Peso')
              ? TextInputType.number
              : TextInputType.text,
        ),
      ),
    );
  }

  double _calculateIMC(double height, double weight) {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }
}
