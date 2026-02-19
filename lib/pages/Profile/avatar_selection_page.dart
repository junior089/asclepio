import 'package:flutter/material.dart';

class AvatarSelectionPage extends StatefulWidget {
  const AvatarSelectionPage({super.key});

  @override
  State<AvatarSelectionPage> createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends State<AvatarSelectionPage> {
  final List<String> _avatarList = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
  ];

  String? selectedAvatarPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha um Avatar'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Número de colunas
          childAspectRatio: 1, // Proporção largura/altura
        ),
        itemCount: _avatarList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Atualiza o avatar selecionado
              setState(() {
                selectedAvatarPath = _avatarList[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child: Image.asset(
                  _avatarList[index],
                  fit: BoxFit.cover, // Ajusta a imagem para não ficar cortada
                  width: 100, // Largura do avatar
                  height: 100, // Altura do avatar
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            selectedAvatarPath != null
                ? 'Avatar selecionado: ${selectedAvatarPath!.split('/').last}'
                : 'Nenhum avatar selecionado',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
