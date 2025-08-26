import 'package:flutter/material.dart';
import 'package:my_tools/elet_secao_condutores_page.dart';
import 'package:my_tools/elet_disjuntores_page.dart';
import 'package:my_tools/elet_contatores_page.dart';
import 'package:my_tools/elet_queda_tensao_page.dart';
import 'package:my_tools/elet_ohm_law_page.dart';
import 'package:my_tools/elet_resistor_page.dart';
import 'package:my_tools/mot_corrente_motor_page.dart';
import 'package:my_tools/mot_potencia_motor_page.dart';
import 'package:my_tools/mot_frequencia_motor_page.dart';

class EletricaPage extends StatefulWidget {
  const EletricaPage({super.key});

  @override
  State<EletricaPage> createState() => _EletricaPageState();
}

class _EletricaPageState extends State<EletricaPage> {
  String _selectedTab = 'Geral';

  final RadialGradient greenGradient = const RadialGradient(
    center: Alignment.center,
    radius: 1.4,
    colors: [
      Color.fromARGB(255, 158, 180, 158),
      Color.fromARGB(255, 38, 43, 38),
    ],
    stops: [0.0, 1.0],
  );

  final LinearGradient darkGreenGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 158, 180, 158),
      Color.fromARGB(255, 38, 43, 38),
    ],
  );

  // Listas de dados para cada aba
  final Map<String, List<Map<String, String>>> tabContents = {
    'Geral': [
      {'image': 'assets/images/fios.png', 'title': 'Cálculo de Seção de Fios'},
      {
        'image': 'assets/images/disjuntor.png',
        'title': 'Cálculo de Disjuntores',
      },
      {'image': 'assets/images/contator.png', 'title': 'Cálculo de Contatores'},
      {
        'image': 'assets/images/tensão.png',
        'title': 'Cálculo de queda de tensão',
      },
      {
        'image': 'assets/images/corrente.png',
        'title': 'Cálculo Corrente, Tensão e Res.',
      },

      {'image': 'assets/images/resistor.png', 'title': 'Resistores'},
    ],
    'Motores': [
      {'image': 'assets/images/mot_corrente.png', 'title': 'Corrente do Motor'},
      {'image': 'assets/images/mot_potencia.png', 'title': 'Potência do Motor'},
      {
        'image': 'assets/images/mot_frequencia.png',
        'title': 'Frequência do Motor',
      },
      {'image': 'assets/images/mot_tensao.png', 'title': 'Tensão do Motor'},
      {
        'image': 'assets/images/mot_fatpotencia.png',
        'title': 'Fator de Potência do Motor',
      },
      {
        'image': 'assets/images/mot_eficiencia.png',
        'title': 'Eficiência do Motor',
      },
      {
        'image': 'assets/images/mot_tripmono.png',
        'title': 'Motor Trifásico para Monofásico',
      },
      {
        'image': 'assets/images/mot_capacitor.png',
        'title': 'Capacitor para motor Monofásico',
      },
      {
        'image': 'assets/images/mot_diagmono.png',
        'title': 'Diagrama para motor Monofásico',
      },
      {
        'image': 'assets/images/mot_diagtri.png',
        'title': 'Diagrama para motor Trifásico',
      },
    ],
    'Conversões': [
      {'image': 'assets/images/favoritos.png', 'title': 'Cálculo de Motor'},
      {'image': 'assets/images/favoritos.png', 'title': 'Reparo de Motores'},
    ],
    'Recursos': [
      {'image': 'assets/images/favoritos.png', 'title': 'Normas Técnicas'},
      {'image': 'assets/images/favoritos.png', 'title': 'Símbolos Elétricos'},
    ],
    'Favoritos': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: greenGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildCustomAppBar(context),
              _buildTabSection(),
              Expanded(
                // Renderiza o conteúdo dinamicamente
                child: _buildTabContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Novo Widget para a AppBar customizada com título
  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: darkGreenGradient,
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
              'Ferramentas Elétricas',
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

  // Widget para a seção de abas
  Widget _buildTabSection() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        gradient: darkGreenGradient,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Habilita a rolagem horizontal
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTab('Geral'),
            _buildTab('Motores'),
            _buildTab('Conversões'),
            _buildTab('Recursos'),
            _buildTab('Favoritos'), // Nova aba
          ],
        ),
      ),
    );
  }

  // Widget para cada aba
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

  // Widget que renderiza o conteúdo da aba selecionada
  Widget _buildTabContent() {
    final List<Map<String, String>> tools = tabContents[_selectedTab]!;
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return _buildToolCard(
          imagePath: tool['image']!,
          title: tool['title']!,
          onTap: () {
            // Lógica para o clique no botão da ferramenta
          },
        );
      },
    );
  }

  // Widget para cada card de ferramenta na lista
  Widget _buildToolCard({
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
            Color.fromARGB(118, 129, 163, 117),
            Color.fromARGB(255, 38, 43, 38),
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
          onTap: () async {
            // Lógica para o clique no botão da Aba Geral
            if (title == 'Cálculo de Seção de Fios') {
              await Future.delayed(const Duration(milliseconds: 150));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SecaoCondutoresPage(),
                ),
              );
            } else if (title == 'Cálculo de Disjuntores') {
              await Future.delayed(const Duration(milliseconds: 150));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DisjuntoresPage(),
                ),
              );
            } else if (title == 'Cálculo de Contatores') {
              await Future.delayed(const Duration(milliseconds: 150));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContatoresPage()),
              );
            } else if (title == 'Cálculo de queda de tensão') {
              await Future.delayed(const Duration(milliseconds: 150));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuedaTensaoPage(),
                ),
              );
            } else if (title == 'Cálculo Corrente, Tensão e Res.') {
              await Future.delayed(const Duration(milliseconds: 150));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OhmLawPage()),
              );
            } else if (title == 'Resistores') {
              await Future.delayed(const Duration(milliseconds: 150));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResistorPage()),
              );
              // Lógica para o clique no botão da Aba Motores
            } else if (title == 'Corrente do Motor') {
              await Future.delayed(const Duration(milliseconds: 150));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CorrenteMotorPage(),
                ),
              );
            } else if (title == 'Potência do Motor') {
              await Future.delayed(const Duration(milliseconds: 150));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PotenciaMotorPage(),
                ),
              );
            } else if (title == 'Frequência do Motor') {
              await Future.delayed(const Duration(milliseconds: 150));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FrequenciaMotorPage(),
                ),
              );
            }
          },
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
