import 'package:flutter/material.dart';
import 'dart:math';

class CorrenteMotorPage extends StatefulWidget {
  const CorrenteMotorPage({super.key});

  @override
  State<CorrenteMotorPage> createState() => _CorrenteMotorPageState();
}

class _CorrenteMotorPageState extends State<CorrenteMotorPage> {
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
  String? _unidadePotenciaSelecionada = 'HP';
  String _tipoCorrente = 'CA'; // NOVIDADE: Tipo de corrente

  final TextEditingController _potenciaController = TextEditingController();
  final TextEditingController _fatorPotenciaController =
      TextEditingController();
  final TextEditingController _eficienciaController = TextEditingController();

  String _resultadoCalculo = 'Aguardando o cálculo...';

  final List<String> unidadesPotencia = ['HP', 'CV', 'kW', 'W'];
  final List<String> tensoes = ['127 V', '220 V', '380 V', '440 V'];
  final List<String> fases = ['Monofásico', 'Bifásico', 'Trifásico'];
  final List<String> tiposCorrente = ['CA', 'CC']; // NOVIDADE

  @override
  void initState() {
    super.initState();
    _fatorPotenciaController.text = '0.85';
    _eficienciaController.text = '0.90';
  }

  @override
  void dispose() {
    _potenciaController.dispose();
    _fatorPotenciaController.dispose();
    _eficienciaController.dispose();
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

  void _calcularCorrenteMotor() {
    try {
      final double valorPotencia = double.parse(
        _potenciaController.text.replaceAll(',', '.'),
      );
      final double potenciaEmWatts = _converterParaWatts(
        valorPotencia,
        _unidadePotenciaSelecionada!,
      );
      final double tensao = double.parse(_tensaoSelecionada!.split(' ')[0]);

      double corrente;

      if (_tipoCorrente == 'CA') {
        final double fatorPotencia = double.parse(
          _fatorPotenciaController.text.replaceAll(',', '.'),
        );
        final double eficiencia = double.parse(
          _eficienciaController.text.replaceAll(',', '.'),
        );
        if (_faseSelecionada == 'Monofásico') {
          corrente = potenciaEmWatts / (tensao * fatorPotencia * eficiencia);
        } else if (_faseSelecionada == 'Trifásico') {
          corrente =
              potenciaEmWatts / (tensao * sqrt(3) * fatorPotencia * eficiencia);
        } else {
          corrente = potenciaEmWatts / (tensao * fatorPotencia * eficiencia);
        }
      } else {
        // 'CC'
        corrente = potenciaEmWatts / tensao;
      }

      setState(() {
        _resultadoCalculo =
            'Corrente do motor: ${corrente.toStringAsFixed(2)} A';
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
          'Corrente do Motor',
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
                _buildCurrentTypeSelector(), // NOVIDADE
                _buildPowerInput(),
                _buildDropdownField(
                  label: 'Tensão',
                  value: _tensaoSelecionada,
                  items: tensoes,
                  onChanged: (v) => setState(() => _tensaoSelecionada = v),
                ),
                if (_tipoCorrente == 'CA') ...[
                  // NOVIDADE: Condição para CA
                  _buildDropdownField(
                    label: 'Fase',
                    value: _faseSelecionada,
                    items: fases,
                    onChanged: (v) => setState(() => _faseSelecionada = v),
                  ),
                  _buildTextField(
                    label: 'Fator de Potência',
                    hint: 'Ex: 0.85',
                    controller: _fatorPotenciaController,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    label: 'Eficiência do Motor',
                    hint: 'Ex: 0.90',
                    controller: _eficienciaController,
                    keyboardType: TextInputType.number,
                  ),
                ],
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

  // NOVIDADE: Seletor de Tipo de Corrente
  Widget _buildCurrentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            'Tipo de Corrente',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('CA', style: TextStyle(color: Colors.white)),
                value: 'CA',
                groupValue: _tipoCorrente,
                onChanged: (value) {
                  setState(() {
                    _tipoCorrente = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('CC', style: TextStyle(color: Colors.white)),
                value: 'CC',
                groupValue: _tipoCorrente,
                onChanged: (value) {
                  setState(() {
                    _tipoCorrente = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
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
          onTap: _calcularCorrenteMotor,
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
