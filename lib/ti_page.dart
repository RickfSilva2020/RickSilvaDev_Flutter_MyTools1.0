import 'package:flutter/material.dart';

class TiPage extends StatefulWidget {
  const TiPage({super.key});

  @override
  State<TiPage> createState() => _TiPageState();
}

class _TiPageState extends State<TiPage> {
  String _selectedTab = 'Ferramentas de Rede';

  // Gradientes de cor azul
  final RadialGradient blueGradient = const RadialGradient(
    center: Alignment.center,
    radius: 1.4,
    colors: [
      Color.fromARGB(255, 128, 172, 209),
      Color.fromARGB(255, 14, 20, 24),
    ],
    stops: [0.0, 1.0],
  );

  final LinearGradient darkBlueGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color.fromARGB(255, 7, 10, 12), Color.fromARGB(255, 23, 31, 37)],
  );

  // Lista de dados para cada aba
  final Map<String, List<Map<String, String>>> tabContents = {
    'Ferramentas de Rede': [
      {
        'image': 'assets/images/ping.png',
        'title': 'Teste de ping e traceroute',
      },
      {
        'image': 'assets/images/port_scan.png',
        'title': 'Scanner de portas (Port Scan)',
      },
      {'image': 'assets/images/dns.png', 'title': 'Whois / DNS lookup'},
      {
        'image': 'assets/images/velocidade.png',
        'title': 'Monitor de velocidade',
      },
      {'image': 'assets/images/ip.png', 'title': 'IP público/privado'},
      {'image': 'assets/images/wol.png', 'title': 'Wake-on-LAN'},
    ],
    'Ferramentas de Sistema': [
      {'image': 'assets/images/processos.png', 'title': 'Monitor de processos'},
      {'image': 'assets/images/ssh.png', 'title': 'SSH/Telnet integrado'},
      {'image': 'assets/images/senha.png', 'title': 'Gerenciador de senhas'},
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Executar scripts remotos',
      },
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Verificação de disponibilidade',
      },
    ],
    'Segurança': [
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Testes de vulnerabilidade',
      },
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Gerador de senhas seguras',
      },
      {'image': 'assets/images/aleatorio.png', 'title': 'Autenticador 2FA'},
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Ferramentas de criptografia',
      },
    ],
    'Cloud e Virtualização': [
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Conexão a serviços de nuvem',
      },
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Monitoramento de máquinas virtuais',
      },
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Controle de containers',
      },
      {'image': 'assets/images/aleatorio.png', 'title': 'Gestão de backups'},
    ],
    'Utilidades Extras': [
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Conversor de unidades',
      },
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Calculadora de sub-redes',
      },
      {'image': 'assets/images/aleatorio.png', 'title': 'Visualizador de logs'},
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Checklist de troubleshooting',
      },
      {
        'image': 'assets/images/aleatorio.png',
        'title': 'Templates de documentação',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: blueGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildCustomAppBar(context),
              _buildTabSection(),
              Expanded(child: _buildTabContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: darkBlueGradient,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Ferramentas de TI',
              style: TextStyle(
                fontFamily: 'Inria Sans',
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 2.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        gradient: darkBlueGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTab('Ferramentas de Rede'),
            _buildTab('Ferramentas de Sistema'),
            _buildTab('Segurança'),
            _buildTab('Cloud e Virtualização'),
            _buildTab('Utilidades Extras'),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String tabName) {
    final bool isActive = _selectedTab == tabName;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = tabName;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: isActive
              ? Border.all(color: Colors.white.withOpacity(0.3))
              : null,
        ),
        child: Center(
          child: Text(
            tabName,
            style: TextStyle(
              fontFamily: 'Inria Sans',
              color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    final List<Map<String, String>> tools = tabContents[_selectedTab]!;
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return _buildToolCard(
          context: context,
          imagePath: tool['image']!,
          title: tool['title']!,
          onTap: () {
            // Lógica de navegação para as ferramentas de TI
            // Será implementada conforme sua necessidade
          },
        );
      },
    );
  }

  Widget _buildToolCard({
    required BuildContext context,
    required String imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(
              123,
              45,
              92,
              134,
            ), // Cor de início do gradiente (verde)
            Color.fromARGB(255, 38, 43, 38), // Cor de fim do gradiente (verde)
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 2)),
          BoxShadow(
            color: Colors.white12,
            blurRadius: 8,
            offset: Offset(-2, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          splashColor: Colors.white24,
          highlightColor: Colors.white12,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.asset(imagePath, width: 40, height: 40),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inria Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
