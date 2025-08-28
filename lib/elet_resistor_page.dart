import 'package:flutter/material.dart';

class ResistorPage extends StatefulWidget {
  const ResistorPage({super.key});

  @override
  State<ResistorPage> createState() => _ResistorPageState();
}

class _ResistorPageState extends State<ResistorPage> {
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

  // Dados do código de cores de resistor (expandido para 5 e 6 bandas)
  final List<Map<String, dynamic>> bandData = [
    {
      'color': 'Preto',
      'digit': 0,
      'multiplier': 1,
      'tolerance': null,
      'tempCoefficient': null,
      'colorValue': Colors.black,
    },
    {
      'color': 'Marrom',
      'digit': 1,
      'multiplier': 10,
      'tolerance': 1.0,
      'tempCoefficient': 100,
      'colorValue': Colors.brown,
    },
    {
      'color': 'Vermelho',
      'digit': 2,
      'multiplier': 100,
      'tolerance': 2.0,
      'tempCoefficient': 50,
      'colorValue': Colors.red,
    },
    {
      'color': 'Laranja',
      'digit': 3,
      'multiplier': 1000,
      'tolerance': null,
      'tempCoefficient': 15,
      'colorValue': Colors.orange,
    },
    {
      'color': 'Amarelo',
      'digit': 4,
      'multiplier': 10000,
      'tolerance': null,
      'tempCoefficient': 25,
      'colorValue': Colors.yellow,
    },
    {
      'color': 'Verde',
      'digit': 5,
      'multiplier': 100000,
      'tolerance': 0.5,
      'tempCoefficient': 20,
      'colorValue': Colors.green,
    },
    {
      'color': 'Azul',
      'digit': 6,
      'multiplier': 1000000,
      'tolerance': 0.25,
      'tempCoefficient': 10,
      'colorValue': Colors.blue,
    },
    {
      'color': 'Violeta',
      'digit': 7,
      'multiplier': 10000000,
      'tolerance': 0.1,
      'tempCoefficient': 5,
      'colorValue': Colors.purple,
    },
    {
      'color': 'Cinza',
      'digit': 8,
      'multiplier': 100000000,
      'tolerance': 0.05,
      'tempCoefficient': null,
      'colorValue': Colors.grey,
    },
    {
      'color': 'Branco',
      'digit': 9,
      'multiplier': 1000000000,
      'tolerance': null,
      'tempCoefficient': null,
      'colorValue': Colors.white,
    },
    {
      'color': 'Ouro',
      'digit': null,
      'multiplier': 0.1,
      'tolerance': 5.0,
      'tempCoefficient': null,
      'colorValue': Colors.amber,
    },
    {
      'color': 'Prata',
      'digit': null,
      'multiplier': 0.01,
      'tolerance': 10.0,
      'tempCoefficient': null,
      'colorValue': Colors.grey.shade400,
    },
  ];

  String? _band1 = 'Marrom';
  String? _band2 = 'Preto';
  String? _band3 = 'Vermelho';
  String? _band4 = 'Ouro';
  String? _band5 = 'Marrom';
  String? _band6 = 'Marrom';

  int _numberOfBands = 4;
  String _resistencia = '0 Ω';
  String _tolerancia = '±?%';
  String _tempCoefficient = '';

  @override
  void initState() {
    super.initState();
    _calcularResistencia();
  }

  void _calcularResistencia() {
    final Map<String, dynamic> band1Data = bandData.firstWhere(
      (element) => element['color'] == _band1,
    );
    final Map<String, dynamic> band2Data = bandData.firstWhere(
      (element) => element['color'] == _band2,
    );
    Map<String, dynamic>? band3Data;
    Map<String, dynamic>? band4Data;
    Map<String, dynamic>? band5Data;
    Map<String, dynamic>? band6Data;

    double valor;
    double? multiplier;
    double? tolerance;
    int? tempCoefficientPPM;

    if (_numberOfBands == 4) {
      band3Data = bandData.firstWhere((element) => element['color'] == _band3);
      band4Data = bandData.firstWhere((element) => element['color'] == _band4);
      valor = (band1Data['digit'] * 10 + band2Data['digit']).toDouble();
      multiplier = (band3Data['multiplier'] as num).toDouble();
      tolerance = (band4Data['tolerance'] as num?)?.toDouble();
    } else if (_numberOfBands == 5) {
      band3Data = bandData.firstWhere((element) => element['color'] == _band3);
      band4Data = bandData.firstWhere((element) => element['color'] == _band4);
      band5Data = bandData.firstWhere((element) => element['color'] == _band5);
      valor =
          (band1Data['digit'] * 100 +
                  band2Data['digit'] * 10 +
                  band3Data['digit'])
              .toDouble();
      multiplier = (band4Data['multiplier'] as num).toDouble();
      tolerance = (band5Data['tolerance'] as num?)?.toDouble();
    } else {
      // 6 bandas
      band3Data = bandData.firstWhere((element) => element['color'] == _band3);
      band4Data = bandData.firstWhere((element) => element['color'] == _band4);
      band5Data = bandData.firstWhere((element) => element['color'] == _band5);
      band6Data = bandData.firstWhere((element) => element['color'] == _band6);
      valor =
          (band1Data['digit'] * 100 +
                  band2Data['digit'] * 10 +
                  band3Data['digit'])
              .toDouble();
      multiplier = (band4Data['multiplier'] as num).toDouble();
      tolerance = (band5Data['tolerance'] as num?)?.toDouble();
      tempCoefficientPPM = band6Data['tempCoefficient'];
    }

    // >>> Alteração: Remove o operador ??
    final double resistencia = valor * multiplier;

    setState(() {
      _resistencia = '${resistencia.toStringAsFixed(0)} Ω';
      _tolerancia = tolerance != null ? '±$tolerance%' : '±?%';
      _tempCoefficient = tempCoefficientPPM != null
          ? ' - $tempCoefficientPPM PPM/°C'
          : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cores de Resistor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: greenGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildResistorVisual(),
                const SizedBox(height: 20),
                const Text(
                  'Selecione o tipo de resistor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  value: _numberOfBands,
                  decoration: InputDecoration(
                    labelText: 'Número de Bandas',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 120, 137, 120),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [4, 5, 6].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        '$value Bandas',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _numberOfBands = newValue!;
                      _band5 = newValue >= 5 ? 'Marrom' : null;
                      _band6 = newValue == 6 ? 'Marrom' : null;
                      _calcularResistencia();
                    });
                  },
                  dropdownColor: const Color.fromARGB(255, 120, 137, 120),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                _buildBandDropdown(
                  label: 'Banda 1 (Dígito)',
                  value: _band1,
                  items: bandData
                      .where((e) => e['digit'] != null)
                      .map((e) => e['color'] as String)
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _band1 = newValue;
                      _calcularResistencia();
                    });
                  },
                ),
                _buildBandDropdown(
                  label: 'Banda 2 (Dígito)',
                  value: _band2,
                  items: bandData
                      .where((e) => e['digit'] != null)
                      .map((e) => e['color'] as String)
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _band2 = newValue;
                      _calcularResistencia();
                    });
                  },
                ),
                _buildBandDropdown(
                  label:
                      'Banda 3 (${_numberOfBands >= 5 ? 'Dígito' : 'Multiplicador'})',
                  value: _band3,
                  items: bandData
                      .where(
                        (e) => e['digit'] != null || e['multiplier'] != null,
                      )
                      .map((e) => e['color'] as String)
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _band3 = newValue;
                      _calcularResistencia();
                    });
                  },
                ),
                _buildBandDropdown(
                  label:
                      'Banda 4 (${_numberOfBands <= 4 ? 'Tolerância' : 'Multiplicador'})',
                  value: _band4,
                  items: bandData
                      .where(
                        (e) =>
                            e['tolerance'] != null || e['multiplier'] != null,
                      )
                      .map((e) => e['color'] as String)
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _band4 = newValue;
                      _calcularResistencia();
                    });
                  },
                ),
                if (_numberOfBands >= 5)
                  _buildBandDropdown(
                    label: 'Banda 5 (Tolerância)',
                    value: _band5,
                    items: bandData
                        .where((e) => e['tolerance'] != null)
                        .map((e) => e['color'] as String)
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _band5 = newValue;
                        _calcularResistencia();
                      });
                    },
                  ),
                if (_numberOfBands == 6)
                  _buildBandDropdown(
                    label: 'Banda 6 (Coeficiente de Temperatura)',
                    value: _band6,
                    items: bandData
                        .where((e) => e['tempCoefficient'] != null)
                        .map((e) => e['color'] as String)
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _band6 = newValue;
                        _calcularResistencia();
                      });
                    },
                  ),
                const SizedBox(height: 30),
                _buildResultDisplay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResistorVisual() {
    // Lista para armazenar as cores das bandas ativas
    List<Color> activeBandsColors = [];

    // Posições e larguras aproximadas das faixas na imagem do resistor (ajuste conforme sua imagem)
    // Estes valores são EXTREMAMENTE dependentes da sua imagem de base.
    // Você precisará experimentar com `left` e `width` para que as faixas se encaixem perfeitamente.
    List<Map<String, double>> bandPositions = [];

    if (_numberOfBands == 4) {
      bandPositions = [
        {'left': 0.28, 'width': 0.05}, // Banda 1
        {'left': 0.35, 'width': 0.05}, // Banda 2
        {'left': 0.42, 'width': 0.05}, // Multiplicador (Banda 3)
        {'left': 0.65, 'width': 0.05}, // Tolerância (Banda 4)
      ];
    } else if (_numberOfBands == 5) {
      bandPositions = [
        {'left': 0.28, 'width': 0.05}, // Banda 1
        {'left': 0.35, 'width': 0.05}, // Banda 2
        {'left': 0.42, 'width': 0.05}, // Banda 3
        {'left': 0.49, 'width': 0.05}, // Multiplicador (Banda 4)
        {'left': 0.68, 'width': 0.05}, // Tolerância (Banda 5)
      ];
    } else {
      // 6 bandas
      bandPositions = [
        {'left': 0.25, 'width': 0.04}, // Banda 1
        {'left': 0.31, 'width': 0.04}, // Banda 2
        {'left': 0.37, 'width': 0.04}, // Banda 3
        {'left': 0.43, 'width': 0.04}, // Multiplicador (Banda 4)
        {'left': 0.58, 'width': 0.04}, // Tolerância (Banda 5)
        {'left': 0.64, 'width': 0.04}, // Coeficiente de Temperatura (Banda 6)
      ];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double resistorWidth =
            constraints.maxWidth; // Largura total disponível para o resistor
        double resistorHeight =
            resistorWidth * (0.8); // Ajuste a proporção da sua imagem

        return Container(
          height:
              resistorHeight +
              10, // Altura para o resistor + um pouco de margem
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Imagem de base do resistor
              Image.asset(
                'assets/images/Resistor.png', // Substitua pelo caminho da sua imagem PNG de base
                width: resistorWidth,
                height: resistorHeight,
                fit: BoxFit.fill, // A imagem preencherá a área definida
              ),
              // Desenhar as faixas coloridas sobre a imagem
              ...List.generate(activeBandsColors.length, (index) {
                // Ajuste para não tentar acessar um índice que não existe em bandPositions
                if (index >= bandPositions.length) {
                  return const SizedBox.shrink();
                }

                double bandLeft = resistorWidth * bandPositions[index]['left']!;
                double bandWidth =
                    resistorWidth * bandPositions[index]['width']!;

                return Positioned(
                  left: bandLeft,
                  child: Container(
                    width: bandWidth,
                    height:
                        resistorHeight *
                        0.7, // Altura da faixa (70% da altura do resistor)
                    color: activeBandsColors[index],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /*
  Widget _buildBand(Color color) {
    return Container(
      width: 12,
      height: 25,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
*/
  Widget _buildBandDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 120, 137, 120),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
          items: items.map((colorName) {
            final colorData = bandData.firstWhere(
              (element) => element['color'] == colorName,
            );
            return DropdownMenuItem(
              value: colorName,
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: colorData['colorValue'],
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(colorName, style: const TextStyle(color: Colors.white)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: const Color.fromARGB(255, 120, 137, 120),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildResultDisplay() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 120, 137, 120),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resistência: $_resistencia',
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tolerância: $_tolerancia',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          if (_tempCoefficient.isNotEmpty)
            Text(
              'Coeficiente de Temperatura: $_tempCoefficient',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
        ],
      ),
    );
  }
}
