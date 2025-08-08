import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final RadialGradient greenGradient = const RadialGradient(
    center: Alignment.center,
    radius: 1.4,
    colors: [
      Color.fromARGB(255, 158, 180, 158),
      Color.fromARGB(255, 38, 43, 38),
    ],
    stops: [0.0, 1.0],
  );

  // Substitua o código completo do build e do body
  // ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Container(
        decoration: BoxDecoration(gradient: greenGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              // Reduz a altura do espaçamento para corrigir o overflow
              const SizedBox(height: 75),
              Expanded(child: _buildBody()),
              const SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
  // ...

  // O restante do código, incluindo as funções _buildAppBar(), _buildBody(), etc.,
  // permanece o mesmo.
  // Widget para a AppBar personalizada
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(
        kToolbarHeight + 60.0,
      ), //Temanho ajustado
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: greenGradient,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ícone do menu hamburguer
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
                // Logo no centro (substitua 'assets/rs_logo.png' pela sua imagem)
                // Se sua logo for um widget personalizado, use-o aqui
                // Atualmente, usando um placeholder de contêiner com bordas arredondadas
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A7C5A),
                    borderRadius: BorderRadius.circular(45),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'RS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // Substitua por Image.asset()
                  ),
                ),
                // Ícone do perfil
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'RF ToolTec',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Widget para o corpo principal da tela
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.15, // Altura dos Botões de categoria
              children: [
                _buildButtonCard(
                  Icons.electrical_services,
                  'Elétrica',
                  Colors.amber,
                ),
                _buildButtonCard(Icons.build, 'Mecânica', Colors.amber),
                _buildButtonCard(Icons.computer, 'TI', Colors.amber),
                _buildButtonCard(Icons.settings, 'Outras', Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Expanded(flex: 2, child: _buildLibraryCard()),
        ],
      ),
    );
  }

  // Widget para cada botão de categoria com gradiente
  Widget _buildButtonCard(IconData icon, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(118, 129, 163, 117), // Cor de início do gradiente
            Color.fromARGB(255, 38, 43, 38), // Cor de fim do gradiente
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          // Sombra escura para o efeito de elevação
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(-4, -4),
          ),
          // Brilho claro para o efeito de relevo
          BoxShadow(
            color: Color.fromARGB(31, 10, 10, 10),
            blurRadius: 8,
            offset: Offset(-2, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors
            .transparent, // Torna o material transparente para mostrar o gradiente
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(15),
          splashColor: Colors.white24,
          highlightColor: Colors.white12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }

  // Widget para o card da Biblioteca Técnica com gradiente
  Widget _buildLibraryCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF86A386), // Cor de início do gradiente
            Color.fromARGB(255, 40, 46, 40), // Cor de fim do gradiente
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          // Sombra escura
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(-5, -4),
          ),
          // Brilho claro
          BoxShadow(
            color: Colors.white12,
            blurRadius: 8,
            offset: Offset(-2, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(15),
          splashColor: Colors.white24,
          highlightColor: Colors.white12,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.menu_book, size: 70, color: Colors.brown),
                const SizedBox(width: 20),
                const Expanded(
                  child: Text(
                    'Biblioteca Técnica',
                    style: TextStyle(
                      fontSize: 22,
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

  // Widget para a barra de navegação inferior
  Widget _buildBottomNavigationBar() {
    return Container(
      height: 90, // Define a altura total do container da barra
      decoration: const BoxDecoration(
        color: Color(0xFF5A7C5A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 20.0,
        ), // Ajusta o padding para centralizar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.settings, 'Configurações'),
            _buildBottomNavItem(Icons.folder, 'Arquivo'),
            _buildBottomNavItem(Icons.assignment, 'OS'),
            _buildBottomNavItem(Icons.calendar_month, 'Agenda'),
          ],
        ),
      ),
    );
  }

  // Widget para cada item da barra de navegação inferior
  Widget _buildBottomNavItem(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
