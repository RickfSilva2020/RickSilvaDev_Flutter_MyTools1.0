import 'package:flutter/material.dart';
import 'dart:math';

class ContatoresPage extends StatefulWidget {
  const ContatoresPage({super.key});

  @override
  State<ContatoresPage> createState() => _ContatoresPageState();
}

class _ContatoresPageState extends State<ContatoresPage> {
  final RadialGradient greenGradient = const RadialGradient(
    center: Alignment.center,
    radius: 1.4,
    colors: [
      Color.fromARGB(255, 158, 180, 158),
      Color.fromARGB(255, 38, 43, 38),
    ],
    stops: [0.0, 1.0],
  );

  final LinearGradient buttonGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(118, 129, 163, 117),
      Color.fromARGB(255, 38, 43, 38),
    ],
  );

  String? _tensaoSelecionada = '220 V';
  String? _faseSelecionada = 'Monofásico';
  String? _categoriaSelecionada = 'AC-3';
  String? _unidadePotenciaSelecionada = 'HP';

  final TextEditingController _potenciaController = TextEditingController();
  final TextEditingController _fatorPotenciaController =
      TextEditingController();
  final TextEditingController _fatorCargaController = TextEditingController();

  final List<String> unidadesPotencia = ['HP', 'CV', 'kW', 'W'];
  final List<String> tensoes = ['127 V', '220 V', '380 V', '440 V'];
  final List<String> fases = ['Monofásico', 'Bifásico', 'Trifásico'];

  final List<Map<String, String>> categoriasComDescricao = [
    {'value': 'AC-1', 'description': 'Cargas não-indutivas, como aquecedores.'},
    {
      'value': 'AC-3',
      'description': 'Comum para motores de gaiola de esquilo.',
    },
    {'value': 'AC-4', 'description': 'Para motores com manobras mais severas.'},
  ];

  String _resultadoCalculo = 'Aguardando o cálculo...';

  final Map<String, Map<int, String>> tabelaDimensionamentoContator = {
    'AC-3': {
      9: '9A',
      12: '12A',
      18: '18A',
      25: '25A',
      32: '32A',
      40: '40A',
      50: '50A',
      65: '65A',
      80: '80A',
      95: '95A',
      115: '115A',
      150: '150A',
      185: '185A',
      225: '225A',
      265: '265A',
      300: '300A',
      400: '400A',
    },
    'AC-4': {
      9: '9A',
      12: '12A',
      18: '18A',
      25: '25A',
      32: '32A',
      40: '40A',
      50: '50A',
      65: '65A',
      80: '80A',
      95: '95A',
      115: '115A',
      150: '150A',
      185: '185A',
      225: '225A',
      265: '265A',
      300: '300A',
      400: '400A',
    },
  };

  @override
  void initState() {
    super.initState();
    _fatorPotenciaController.text = '0.92';
    _fatorCargaController.text = '0.85';
  }

  @override
  void dispose() {
    _potenciaController.dispose();
    _fatorPotenciaController.dispose();
    _fatorCargaController.dispose();
    super.dispose();
  }

  double _converterParaWatts(double valor, String unidade) {
    switch (unidade) {
      case 'HP':
        return valor * 746;
      case 'CV':
        return valor * 736;
      case 'kW':
        return valor * 1000;
      case 'W':
        return valor;
      default:
        return 0;
    }
  }

  void _calcularContator() {
    try {
      final double valorPotencia = double.parse(
        _potenciaController.text.replaceAll(',', '.'),
      );
      final double potenciaEmWatts = _converterParaWatts(
        valorPotencia,
        _unidadePotenciaSelecionada!,
      );

      final double tensao = double.parse(_tensaoSelecionada!.split(' ')[0]);
      final double fatorPotencia = double.parse(
        _fatorPotenciaController.text.replaceAll(',', '.'),
      );
      final double fatorCarga = double.parse(
        _fatorCargaController.text.replaceAll(',', '.'),
      );

      double correnteNominal;
      if (_faseSelecionada == 'Monofásico') {
        correnteNominal =
            potenciaEmWatts / (tensao * fatorPotencia * fatorCarga);
      } else if (_faseSelecionada == 'Trifásico') {
        correnteNominal =
            potenciaEmWatts / (tensao * sqrt(3) * fatorPotencia * fatorCarga);
      } else {
        correnteNominal =
            potenciaEmWatts / (tensao * fatorPotencia * fatorCarga);
      }

      String? contatorRecomendado;
      final Map<int, String> tabelaContator =
          tabelaDimensionamentoContator[_categoriaSelecionada!]!;
      for (final int amp in tabelaContator.keys.toList()..sort()) {
        if (amp >= correnteNominal) {
          contatorRecomendado = tabelaContator[amp];
          break;
        }
      }

      String? disjuntorRecomendado = contatorRecomendado;
      String? releSobrecarga;

      if (contatorRecomendado != null) {
        // Lógica simples: o relé de sobrecarga tem a mesma amperagem do contator
        releSobrecarga = contatorRecomendado;
      }

      setState(() {
        if (contatorRecomendado != null) {
          _resultadoCalculo =
              'Corrente nominal: ${correnteNominal.toStringAsFixed(2)} A\nContator recomendado: $contatorRecomendado\nDisjuntor-Motor recomendado: $disjuntorRecomendado\nRelé de Sobrecarga recomendado: $releSobrecarga\nCategoria de Emprego: $_categoriaSelecionada';
        } else {
          _resultadoCalculo =
              'Não foi encontrado um contator adequado para esta potência. O contator necessário excede a nossa tabela de dados.';
        }
      });
    } catch (e) {
      setState(() {
        _resultadoCalculo =
            'Erro nos dados. Verifique se todos os campos estão preenchidos corretamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dimensionamento de Contator',
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
                _buildPowerInput(),
                _buildDropdownField(
                  label: 'Tensão',
                  value: _tensaoSelecionada,
                  items: tensoes,
                  onChanged: (v) => setState(() => _tensaoSelecionada = v),
                ),
                _buildDropdownField(
                  label: 'Fase',
                  value: _faseSelecionada,
                  items: fases,
                  onChanged: (v) => setState(() => _faseSelecionada = v),
                ),
                _buildTextField(
                  label: 'Fator de Potência',
                  hint: 'Ex: 0.92',
                  controller: _fatorPotenciaController,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  label: 'Fator de Carga',
                  hint: 'Ex: 0.85',
                  controller: _fatorCargaController,
                  keyboardType: TextInputType.number,
                ),
                _buildCategoriaDropdownField(),
                const SizedBox(height: 30),
                _buildCalculateButton(),
                const SizedBox(height: 20),
                _buildResultDisplay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPowerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            'Potência do Motor',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _potenciaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Digite o valor',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 120, 137, 120),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: _unidadePotenciaSelecionada,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 120, 137, 120),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: unidadesPotencia
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _unidadePotenciaSelecionada = newValue;
                  });
                },
                dropdownColor: const Color.fromARGB(255, 120, 137, 120),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            filled: true,
            fillColor: const Color.fromARGB(255, 120, 137, 120),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
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
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          dropdownColor: const Color.fromARGB(255, 120, 137, 120),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildCategoriaDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            'Categoria de Emprego',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _categoriaSelecionada,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 120, 137, 120),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
          itemHeight: 70,
          items: categoriasComDescricao.map((item) {
            return DropdownMenuItem(
              value: item['value'],
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${item['value']} -> ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: item['description']!,
                      style: const TextStyle(
                        color: Color.fromARGB(178, 255, 255, 255),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (newValue) =>
              setState(() => _categoriaSelecionada = newValue),
          dropdownColor: const Color.fromARGB(255, 120, 137, 120),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: buttonGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: _calcularContator,
          borderRadius: BorderRadius.circular(15),
          splashColor: Colors.white24,
          highlightColor: Colors.white12,
          child: const Center(
            child: Text(
              'Calcular',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultDisplay() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 120, 137, 120),
        borderRadius: BorderRadius.circular(15),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 16),
          children: [
            const TextSpan(text: 'Resultado do Cálculo:\n\n'),
            TextSpan(
              text: _resultadoCalculo,
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
