import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final RadialGradient greenGradient = const RadialGradient(
    center: Alignment.center,
    radius: 1.4,
    colors: [
      Color.fromARGB(255, 158, 180, 158),// Cor de fundo co corpo
      Color.fromARGB(255, 38, 43, 38),
    ],
    stops: [0.0, 1.0],
  );
   final LinearGradient darkGreenGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 158, 180, 158),// Cor de fundo da barra inferior
      Color.fromARGB(255, 38, 43, 38),
    ],
  );
  // Novo gradiente radial prateado para o texto
  final RadialGradient silverTextGradient = const RadialGradient(
    center: Alignment.center,
    radius: 1.5, // Ajuste o raio para controlar a dispersão do gradiente
    colors: [
      Color.fromARGB(255, 177, 175, 175), // Cinza mais claro
      Colors.white,           // Branco para o brilho
      Colors.grey, // Cinza um pouco mais escuro
    ],
    stops: [0.0, 0.5, 1.0],
   ); // Define onde cada cor começa e termina
  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: greenGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 0), // Espaço entre o app bar e o conteúdo
             // Adicionando o widget Text com o ShaderMask para o gradiente
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return silverTextGradient.createShader(bounds);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'RF ToolTec',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inria Sans', // Use o nome da família de fontes aqui
                    color: Colors.white, // A cor base precisa ser sólida
                    fontSize: 45,
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
            ),
            Expanded(child: _buildBody()),
            const SizedBox(height:35), // Espaço entre o Barra Inferior e o Botão Bibioteca Técnica
            _buildBottomNavigationBar(),// A barra agora é um widget da Column
             // Espaço entre o conteúdo e a barra de navegação
          ],
        ),
      ),
    ),
  );
}
  // ...

 
  // Widget para a AppBar personalizada
 PreferredSizeWidget _buildAppBar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(180),
    child: Container(
      height: 180, // Adiciona esta linha para forçar a altura
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: darkGreenGradient,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                onPressed: () {},
              ),
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
                child: const Center(
                  child: Text(
                    'RS',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
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
      padding: const EdgeInsets.all(20.0), // Espaçamento entre o topo e o corpo
      child: Column(
        children: [
          Expanded(
            flex: 5, // 5 partes do total
            child: GridView.count(
              crossAxisCount: 2, // 2 colunas
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.18, // Altura dos Botões de categoria
              children: [
                _buildButtonCard(
                  'assets/images/Raio.png',
                  'Elétrica'
                ),
                _buildButtonCard('assets/images/Chave.png', 'Mecânica'),
                _buildButtonCard('assets/images/computador.png', 'TI'),
                _buildButtonCard('assets/images/Outros.png', 'Outras'),
              ],
            ),
          ),
          const SizedBox(height: 10), 
          Expanded(flex: 2, child: _buildLibraryCard()),
        ],
      ),
    );
  }

  // Widget para cada botão de categoria com gradiente
  Widget _buildButtonCard(String imagePath, String title) {
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
              Image.asset(imagePath, width: 60, height: 60), // Substitui o Icon
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
// Substitua o código completo da função _buildBottomNavigationBar
// Widget para a barra de navegação inferior
Widget _buildBottomNavigationBar() {
  return ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
    child: Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: darkGreenGradient,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem('assets/images/configuracoes.png', 'Configurações'),
            _buildBottomNavItem('assets/images/arquivos.png', 'Arquivo'),
            _buildBottomNavItem('assets/images/OS.png','OS'),
            _buildBottomNavItem('assets/images/agenda.png', 'Agenda'),
          ],
        ),
      ),
    ),
  );
}

// Widget para cada item da barra de navegação inferior
Widget _buildBottomNavItem(String imagePath, String label) {
  return Material(
    color: Colors.transparent, // Torna o material transparente
    child: InkWell(
      onTap: () {},
      splashColor: Colors.white24, // Efeito de onda branco e sutil
      highlightColor: Colors.white12, // Cor de destaque ao segurar o botão
      child: Padding( // Adicionei um Padding para um toque mais confortável
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, width: 30, height: 30),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inria Sans',
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
