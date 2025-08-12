import 'package:flutter/material.dart';
import 'dart:math';

class QuedaTensaoPage extends StatefulWidget {
  const QuedaTensaoPage({super.key});

  @override
  State<QuedaTensaoPage> createState() => _QuedaTensaoPageState();
}

class _QuedaTensaoPageState extends State<QuedaTensaoPage> {
  // Cores e gradientes (reutilizados das telas anteriores)
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

  // Variáveis de estado do formulário
  String? _tensaoSelecionada = '127 V';
  String? _secaoSelecionada = '1,5 mm²';
  String? _tipoCondutorSelecionado = 'Cobre';
  String? _faseSelecionada = 'Monofásico';

  // Controladores para campos de texto
  final TextEditingController _correnteController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _fatorPotenciaController =
      TextEditingController();

  double? _quedaDeTensaoAbsoluta;
  double? _quedaDeTensaoPercentual;
  static const double _quedaAceitavel = 4.0;

  final List<String> tensoes = ['127 V', '220 V', '380 V', '440 V'];
  final List<String> secoes = [
    '1,5 mm²',
    '2,5 mm²',
    '4,0 mm²',
    '6,0 mm²',
    '10,0 mm²',
    '16,0 mm²',
    '25,0 mm²',
    '35,0 mm²',
    '50,0 mm²',
  ];
  final List<String> tiposCondutor = ['Cobre', 'Alumínio'];
  final List<String> fases = ['Monofásico', 'Bifásico', 'Trifásico'];

  // Tabela simplificada de resistência e reatância por tipo/seção do condutor (dados expandidos)
  final Map<String, Map<String, Map<String, double>>> dadosCondutor = {
    'Cobre': {
      '1,5 mm²': {'R': 12.1, 'X': 0.08},
      '2,5 mm²': {'R': 7.41, 'X': 0.07},
      '4,0 mm²': {'R': 4.61, 'X': 0.07},
      '6,0 mm²': {'R': 3.08, 'X': 0.07},
      '10,0 mm²': {'R': 1.83, 'X': 0.07},
      '16,0 mm²': {'R': 1.15, 'X': 0.07},
      '25,0 mm²': {'R': 0.727, 'X': 0.06},
      '35,0 mm²': {'R': 0.524, 'X': 0.06},
      '50,0 mm²': {'R': 0.387, 'X': 0.06},
    },
    'Alumínio': {
      '2,5 mm²': {'R': 12.4, 'X': 0.08},
      '4,0 mm²': {'R': 7.6, 'X': 0.08},
      '6,0 mm²': {'R': 5.0, 'X': 0.08},
      '10,0 mm²': {'R': 3.0, 'X': 0.08},
      '16,0 mm²': {'R': 1.91, 'X': 0.08},
      '25,0 mm²': {'R': 1.2, 'X': 0.07},
      '35,0 mm²': {'R': 0.868, 'X': 0.07},
      '50,0 mm²': {'R': 0.641, 'X': 0.07},
    },
  };

  @override
  void initState() {
    super.initState();
    _correnteController.text = '10';
    _distanciaController.text = '20';
    _fatorPotenciaController.text = '0.92';
  }

  @override
  void dispose() {
    _correnteController.dispose();
    _distanciaController.dispose();
    _fatorPotenciaController.dispose();
    super.dispose();
  }

  void _calcularQuedaDeTensao() {
    try {
      final double corrente = double.parse(
        _correnteController.text.replaceAll(',', '.'),
      );
      final double distancia = double.parse(
        _distanciaController.text.replaceAll(',', '.'),
      );
      final double fatorPotencia = double.parse(
        _fatorPotenciaController.text.replaceAll(',', '.'),
      );
      final double tensaoNominal = double.parse(
        _tensaoSelecionada!.split(' ')[0],
      );

      final String tipo = _tipoCondutorSelecionado!;
      final String secao = _secaoSelecionada!;
      final double resistencia = dadosCondutor[tipo]![secao]!['R']!;
      final double reatancia = dadosCondutor[tipo]![secao]!['X']!;

      double quedaDeTensaoAbsoluta;
      double k = 1.0;

      if (_faseSelecionada == 'Monofásico' || _faseSelecionada == 'Bifásico') {
        k = 2;
      } else if (_faseSelecionada == 'Trifásico') {
        k = sqrt(3);
      }

      quedaDeTensaoAbsoluta =
          (k *
              distancia *
              corrente *
              (resistencia * fatorPotencia +
                  reatancia * sin(acos(fatorPotencia)))) /
          1000;
      final double quedaDeTensaoPercentual =
          (quedaDeTensaoAbsoluta / tensaoNominal) * 100;

      setState(() {
        _quedaDeTensaoAbsoluta = quedaDeTensaoAbsoluta;
        _quedaDeTensaoPercentual = quedaDeTensaoPercentual;
      });
    } catch (e) {
      setState(() {
        _quedaDeTensaoAbsoluta = null;
        _quedaDeTensaoPercentual = null;
      });
    }
  }

  // Widget para exibir o resultado com destaque e alerta
  Widget _buildResultDisplay() {
    if (_quedaDeTensaoAbsoluta == null || _quedaDeTensaoPercentual == null) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 120, 137, 120),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Text(
          'Aguardando o cálculo...',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    final Color corResultado = (_quedaDeTensaoPercentual! > _quedaAceitavel)
        ? Colors.red
        : Colors.greenAccent;
    final String status = (_quedaDeTensaoPercentual! > _quedaAceitavel)
        ? 'ACIMA DO LIMITE RECOMENDADO!'
        : 'DENTRO DO LIMITE RECOMENDADO.';

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
              text:
                  'Queda de Tensão Absoluta: ${_quedaDeTensaoAbsoluta!.toStringAsFixed(2)} V\n',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text:
                  'Queda de Tensão Percentual: ${_quedaDeTensaoPercentual!.toStringAsFixed(2)} %\n',
              style: TextStyle(
                color: corResultado,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextSpan(
              text: 'Queda Aceitável: $_quedaAceitavel % - $status',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cálculo de Queda de Tensão',
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
                  label: 'Tensão (V)',
                  value: _tensaoSelecionada,
                  items: tensoes,
                  onChanged: (v) => setState(() => _tensaoSelecionada = v),
                ),
                _buildTextField(
                  label: 'Corrente (A)',
                  hint: 'Digite a corrente em Ampères',
                  controller: _correnteController,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  label: 'Distância do Circuito (m)',
                  hint: 'Digite a distância em metros',
                  controller: _distanciaController,
                  keyboardType: TextInputType.number,
                ),
                _buildDropdownField(
                  label: 'Seção do Condutor (mm²)',
                  value: _secaoSelecionada,
                  items: secoes,
                  onChanged: (v) => setState(() => _secaoSelecionada = v),
                ),
                _buildDropdownField(
                  label: 'Tipo de Condutor',
                  value: _tipoCondutorSelecionado,
                  items: tiposCondutor,
                  onChanged: (v) =>
                      setState(() => _tipoCondutorSelecionado = v),
                ),
                _buildTextField(
                  label: 'Fator de Potência',
                  hint: 'Ex: 0.92',
                  controller: _fatorPotenciaController,
                  keyboardType: TextInputType.number,
                ),
                _buildDropdownField(
                  label: 'Fase',
                  value: _faseSelecionada,
                  items: fases,
                  onChanged: (v) => setState(() => _faseSelecionada = v),
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
          onTap: _calcularQuedaDeTensao,
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
}
