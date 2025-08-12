import 'package:flutter/material.dart';

class OhmLawPage extends StatefulWidget {
  const OhmLawPage({super.key});

  @override
  State<OhmLawPage> createState() => _OhmLawPageState();
}

class _OhmLawPageState extends State<OhmLawPage> {
  // Cores e gradientes (reutilizados)
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

  // Controladores de texto para cada formulário
  final TextEditingController _tensaoIController = TextEditingController();
  final TextEditingController _resistenciaIController = TextEditingController();
  final TextEditingController _correnteVController = TextEditingController();
  final TextEditingController _resistenciaVController = TextEditingController();
  final TextEditingController _tensaoRController = TextEditingController();
  final TextEditingController _correnteRController = TextEditingController();

  // Variáveis de estado para os resultados
  String _resultadoCorrente = '0.0 A';
  String _resultadoTensao = '0.0 V';
  String _resultadoResistencia = '0.0 Ω';

  @override
  void dispose() {
    _tensaoIController.dispose();
    _resistenciaIController.dispose();
    _correnteVController.dispose();
    _resistenciaVController.dispose();
    _tensaoRController.dispose();
    _correnteRController.dispose();
    super.dispose();
  }

  // Lógica de cálculo para Corrente (I = V / R)
  void _calcularCorrente() {
    try {
      final double tensao = double.parse(
        _tensaoIController.text.replaceAll(',', '.'),
      );
      final double resistencia = double.parse(
        _resistenciaIController.text.replaceAll(',', '.'),
      );
      final double corrente = tensao / resistencia;
      setState(() {
        _resultadoCorrente = '${corrente.toStringAsFixed(2)} A';
      });
    } catch (e) {
      setState(() {
        _resultadoCorrente = 'Erro';
      });
    }
  }

  // Lógica de cálculo para Tensão (V = I * R)
  void _calcularTensao() {
    try {
      final double corrente = double.parse(
        _correnteVController.text.replaceAll(',', '.'),
      );
      final double resistencia = double.parse(
        _resistenciaVController.text.replaceAll(',', '.'),
      );
      final double tensao = corrente * resistencia;
      setState(() {
        _resultadoTensao = '${tensao.toStringAsFixed(2)} V';
      });
    } catch (e) {
      setState(() {
        _resultadoTensao = 'Erro';
      });
    }
  }

  // Lógica de cálculo para Resistência (R = V / I)
  void _calcularResistencia() {
    try {
      final double tensao = double.parse(
        _tensaoRController.text.replaceAll(',', '.'),
      );
      final double corrente = double.parse(
        _correnteRController.text.replaceAll(',', '.'),
      );
      final double resistencia = tensao / corrente;
      setState(() {
        _resultadoResistencia = '${resistencia.toStringAsFixed(2)} Ω';
      });
    } catch (e) {
      setState(() {
        _resultadoResistencia = 'Erro';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cálculos da Lei de Ohm',
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
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildOhmForm(
                title: 'Calcular Corrente (I)',
                label1: 'Tensão (V)',
                hint1: 'Tensão em Volts',
                controller1: _tensaoIController,
                label2: 'Resistência (R)',
                hint2: 'Resistência em Ohms',
                controller2: _resistenciaIController,
                buttonLabel: 'Calcular I',
                onTap: _calcularCorrente,
                resultado: _resultadoCorrente,
              ),
              const SizedBox(height: 20),
              _buildOhmForm(
                title: 'Calcular Tensão (V)',
                label1: 'Corrente (I)',
                hint1: 'Corrente em Ampères',
                controller1: _correnteVController,
                label2: 'Resistência (R)',
                hint2: 'Resistência em Ohms',
                controller2: _resistenciaVController,
                buttonLabel: 'Calcular V',
                onTap: _calcularTensao,
                resultado: _resultadoTensao,
              ),
              const SizedBox(height: 20),
              _buildOhmForm(
                title: 'Calcular Resistência (R)',
                label1: 'Tensão (V)',
                hint1: 'Tensão em Volts',
                controller1: _tensaoRController,
                label2: 'Corrente (I)',
                hint2: 'Corrente em Ampères',
                controller2: _correnteRController,
                buttonLabel: 'Calcular R',
                onTap: _calcularResistencia,
                resultado: _resultadoResistencia,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOhmForm({
    required String title,
    required String label1,
    required String hint1,
    required TextEditingController controller1,
    required String label2,
    required String hint2,
    required TextEditingController controller2,
    required String buttonLabel,
    required VoidCallback onTap,
    required String resultado,
  }) {
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
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: label1,
            hint: hint1,
            controller: controller1,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: label2,
            hint: hint2,
            controller: controller2,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 30),
          _buildCalculateButton(buttonLabel: buttonLabel, onTap: onTap),
          const SizedBox(height: 20),
          _buildResultDisplay(resultado),
        ],
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
            fillColor: const Color.fromARGB(255, 90, 100, 90),
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

  Widget _buildCalculateButton({
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          splashColor: Colors.white24,
          highlightColor: Colors.white12,
          child: Center(
            child: Text(
              buttonLabel,
              style: const TextStyle(
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

  Widget _buildResultDisplay(String resultado) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 90, 100, 90),
        borderRadius: BorderRadius.circular(15),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 16),
          children: [
            const TextSpan(text: 'Resultado:\n\n'),
            TextSpan(
              text: resultado,
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
