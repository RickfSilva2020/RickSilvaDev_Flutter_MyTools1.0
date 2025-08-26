import 'package:flutter/material.dart';
import 'dart:math';

class PotenciaMotorPage extends StatefulWidget {
  const PotenciaMotorPage({super.key});

  @override
  State<PotenciaMotorPage> createState() => _PotenciaMotorPageState();
}

class _PotenciaMotorPageState extends State<PotenciaMotorPage> {
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
  String _tipoCorrente = 'CA';

  final TextEditingController _correnteController = TextEditingController();
  final TextEditingController _fatorPotenciaController =
      TextEditingController();
  final TextEditingController _eficienciaController = TextEditingController();

  String _resultadoCalculo = 'Aguardando o cálculo...';

  final List<String> tensoes = ['127 V', '220 V', '380 V', '440 V'];
  final List<String> fases = ['Monofásico', 'Bifásico', 'Trifásico'];
  final List<String> tiposCorrente = ['CA', 'CC'];

  @override
  void initState() {
    super.initState();
    _correnteController.text = '10';
    _fatorPotenciaController.text = '0.85';
    _eficienciaController.text = '0.90';
  }

  @override
  void dispose() {
    _correnteController.dispose();
    _fatorPotenciaController.dispose();
    _eficienciaController.dispose();
    super.dispose();
  }

  void _calcularPotenciaMotor() {
    try {
      final double tensao = double.parse(_tensaoSelecionada!.split(' ')[0]);
      final double corrente = double.parse(
        _correnteController.text.replaceAll(',', '.'),
      );

      double potencia;

      if (_tipoCorrente == 'CA') {
        final double fatorPotencia = double.parse(
          _fatorPotenciaController.text.replaceAll(',', '.'),
        );
        final double eficiencia = double.parse(
          _eficienciaController.text.replaceAll(',', '.'),
        );
        if (_faseSelecionada == 'Monofásico') {
          potencia = tensao * corrente * fatorPotencia * eficiencia;
        } else if (_faseSelecionada == 'Trifásico') {
          potencia = tensao * sqrt(3) * corrente * fatorPotencia * eficiencia;
        } else {
          potencia = tensao * corrente * fatorPotencia * eficiencia;
        }
      } else {
        // CC
        potencia = tensao * corrente;
      }

      final double potenciaHP = potencia / 746;
      final double potenciaCV = potencia / 736;
      final double potenciaKW = potencia / 1000;

      setState(() {
        _resultadoCalculo =
            'Potência em W: ${potencia.toStringAsFixed(2)}\n'
            'Potência em kW: ${potenciaKW.toStringAsFixed(2)}\n'
            'Potência em HP: ${potenciaHP.toStringAsFixed(2)}\n'
            'Potência em CV: ${potenciaCV.toStringAsFixed(2)}';
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
          'Potência do Motor',
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
                _buildCurrentTypeSelector(),
                _buildTextField(
                  label: 'Corrente (A)',
                  hint: 'Digite a corrente em Ampères',
                  controller: _correnteController,
                  keyboardType: TextInputType.number,
                ),
                _buildDropdownField(
                  label: 'Tensão',
                  value: _tensaoSelecionada,
                  items: tensoes,
                  onChanged: (v) => setState(() => _tensaoSelecionada = v),
                ),
                if (_tipoCorrente == 'CA') ...[
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
          onTap: _calcularPotenciaMotor,
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
