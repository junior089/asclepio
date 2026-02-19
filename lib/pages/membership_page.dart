import 'package:flutter/material.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Benefícios da Associação:',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Aproveite todos os benefícios exclusivos!',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildMembershipCard(
                        context,
                        'Plano Mensal',
                        'R\$ 50 / mês',
                        'Ideal para quem quer flexibilidade mensal.',
                        Colors.orangeAccent,
                        Icons.calendar_today,
                        [
                          'Acesso total a todas as aulas',
                          'Suporte prioritário',
                          'Descontos em produtos'
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildMembershipCard(
                        context,
                        'Plano Anual',
                        'R\$ 500 / ano',
                        'A melhor economia para o ano todo.',
                        Colors.tealAccent,
                        Icons.star,
                        [
                          'Acesso total a todas as aulas',
                          'Suporte prioritário',
                          'Descontos em produtos',
                          'Um mês grátis'
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembershipCard(
    BuildContext context,
    String title,
    String price,
    String description,
    Color buttonColor,
    IconData icon,
    List<String> benefits,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 36, color: buttonColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: TextStyle(fontSize: 20, color: Colors.grey[700]),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: benefits
                .map((benefit) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.check,
                              size: 16, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(benefit,
                              style: const TextStyle(color: Colors.black87)),
                        ],
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Inscrição no $title"),
                    content: const Text("Você se inscreveu com sucesso!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Inscrever-se', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const SizedBox.shrink();
  }
}
