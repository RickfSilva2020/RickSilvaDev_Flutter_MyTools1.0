import 'package:flutter/material.dart';

class EletricaPage extends StatelessWidget {
  const EletricaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ferramentas Elétricas'),
        backgroundColor: const Color(0xFF5A7C5A),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Conteúdo da Tela de Ferramentas Elétricas',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navega de volta para a tela anterior
                Navigator.pop(context);
              },
              child: const Text('Voltar para a Home'),
            ),
          ],
        ),
      ),
    );
  }
}
