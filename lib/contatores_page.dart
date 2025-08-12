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

  String? _potenciaSelecionada = '1 HP';
  String? _tensaoSelecionada = '220 V';
  String? _faseSelecionada = 'Monofásico';
  String? _categoriaSelecionada = 'AC-3';

  final List<String> potencias = [
    '1/4 HP',
    '1/2 HP',
    '1 HP',
    '2 HP',
    '5 HP',
    '10 HP',
  ];
  final List<String> tensoes = ['127 V', '220 V', '380 V', '440 V'];
  final List<String> fases = ['Monofásico', 'Bifásico', 'Trifásico'];
  final List<String> categorias = ['AC-1', 'AC-3', 'AC-4'];

  String _resultadoCalculo = 'Aguardando o cálculo...';

  // Tabela simplificada de corrente nominal de motores em A para 220V e AC-3
  final Map<String, double> tabelaCorrente220V = {
    '1/4 HP': 1.6,
    '1/2 HP': 2.5,
    '1 HP': 4.5,
    '2 HP': 7.5,
    '5 HP': 15,
    '10 HP': 28,
  };

  // Tabela simplificada de dimensionamento de contatores por categoria e corrente nominal
  final Map<String, Map<int, String>> tabelaDimensionamentoContator = {
    'AC-3': {9: '9A', 12: '12A', 18: '18A', 25: '25A'},
    'AC-4': {9: '9A', 12: '12A', 18: '18A', 25: '25A'},
  };

  void _calcularContator() {
    try {
      final double correnteNominal = tabelaCorrente220V[_potenciaSelecionada!]!;
      final int disjuntorRecomendado = (correnteNominal * 1.5).ceil();

      String? contatorRecomendado;
      final Map<int, String> tabelaContator =
          tabelaDimensionamentoContator[_categoriaSelecionada!]!;
      for (final int amp in tabelaContator.keys.toList()..sort()) {
        if (amp >= correnteNominal) {
          contatorRecomendado = tabelaContator[amp];
          break;
        }
      }

      setState(() {
        if (contatorRecomendado != null) {
          _resultadoCalculo =
              'Corrente nominal: ${correnteNominal.toStringAsFixed(2)} A\nDisjuntor recomendado: $disjuntorRecomendado A\nContator recomendado: $contatorRecomendado';
        } else {
          _resultadoCalculo = 'Não foi encontrado um contator adequado.';
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
                _buildDropdownField(
                  label: 'Potência do Motor',
                  value: _potenciaSelecionada,
                  items: potencias,
                  onChanged: (v) => setState(() => _potenciaSelecionada = v),
                ),
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
                _buildDropdownField(
                  label: 'Categoria de Emprego',
                  value: _categoriaSelecionada,
                  items: categorias,
                  onChanged: (v) => setState(() => _categoriaSelecionada = v),
                ),
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
