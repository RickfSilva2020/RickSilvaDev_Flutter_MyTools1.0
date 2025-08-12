import 'package:flutter/material.dart';
import 'dart:math';

class SecaoCondutoresPage extends StatefulWidget {
  const SecaoCondutoresPage({super.key});

  @override
  State<SecaoCondutoresPage> createState() => _SecaoCondutoresPageState();
}

class _SecaoCondutoresPageState extends State<SecaoCondutoresPage> {
  // Cores e gradientes
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

  // Variáveis para o estado dos campos do formulário
  String? _tensaoSelecionada = '127 V';
  String? _faseSelecionada = 'Monofásico';
  String? _tipoCondutorSelecionado = 'Cobre';
  String? _materialIsolanteSelecionado = 'PVC';
  String? _metodoInstalacaoSelecionado = 'Eletroduto';
  String _modoCalculo = 'potencia';

  // Controladores para os campos de texto
  final TextEditingController _potenciaController = TextEditingController();
  final TextEditingController _correnteController = TextEditingController();
  final TextEditingController _fatorPotenciaController =
      TextEditingController();
  final TextEditingController _fatorCargaController = TextEditingController();
  final TextEditingController _temperaturaController = TextEditingController();

  // Variável para armazenar e exibir o resultado
  String _resultadoCalculo = 'Aguardando o cálculo...';

  // Listas de itens para os Dropdowns
  final List<String> tensoes = ['127 V', '220 V', '380 V', '440 V'];
  final List<String> fases = ['Monofásico', 'Bifásico', 'Trifásico'];
  final List<String> tiposCondutor = ['Cobre', 'Alumínio'];
  final List<String> materiaisIsolantes = ['PVC', 'EPR', 'XLPE'];
  final List<String> metodosInstalacao = [
    'Eletroduto',
    'Bandeja',
    'Direto no solo',
  ];

  // Tabelas de capacidade de corrente para Cobre e Alumínio
  final Map<String, Map<double, double>> tabelasCapacidadeCorrente = {
    'Cobre': {1.5: 15.5, 2.5: 21, 4.0: 28, 6.0: 36, 10.0: 50},
    'Alumínio': {2.5: 16, 4.0: 22, 6.0: 29, 10.0: 40, 16.0: 54},
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
    _correnteController.dispose();
    _fatorPotenciaController.dispose();
    _fatorCargaController.dispose();
    _temperaturaController.dispose();
    super.dispose();
  }

  void _calcularSecao() {
    try {
      final double tensao = double.parse(_tensaoSelecionada!.split(' ')[0]);
      final double fatorPotencia = double.parse(
        _fatorPotenciaController.text.replaceAll(',', '.'),
      );
      final double fatorCarga = double.parse(
        _fatorCargaController.text.replaceAll(',', '.'),
      );
      final double temperatura = double.parse(
        _temperaturaController.text.replaceAll(',', '.'),
      );

      double corrente;

      if (_modoCalculo == 'potencia') {
        final double potencia = double.parse(
          _potenciaController.text.replaceAll(',', '.'),
        );
        if (_faseSelecionada == 'Monofásico') {
          corrente = potencia / (tensao * fatorPotencia * fatorCarga);
        } else if (_faseSelecionada == 'Trifásico') {
          corrente = potencia / (tensao * sqrt(3) * fatorPotencia * fatorCarga);
        } else {
          corrente = potencia / (tensao * fatorPotencia * fatorCarga);
        }
      } else {
        // _modoCalculo == 'corrente'
        corrente = double.parse(_correnteController.text.replaceAll(',', '.'));
      }

      double fatorCorrecaoTemp = 1.0;
      if (temperatura > 30) {
        fatorCorrecaoTemp = 0.94;
      }
      final double correnteCorrigida = corrente / fatorCorrecaoTemp;

      final Map<double, double> tabela =
          tabelasCapacidadeCorrente[_tipoCondutorSelecionado!]!;

      double? secaoRecomendada;
      for (final secao in tabela.keys.toList()..sort()) {
        final double capacidade = tabela[secao]!;
        if (capacidade >= correnteCorrigida) {
          secaoRecomendada = secao;
          break;
        }
      }

      setState(() {
        if (secaoRecomendada != null) {
          _resultadoCalculo =
              'Corrente calculada: ${corrente.toStringAsFixed(2)} A\nSeção de condutor recomendada: $secaoRecomendada mm²';
        } else {
          _resultadoCalculo =
              'Não foi encontrada uma seção adequada. A corrente calculada é ${corrente.toStringAsFixed(2)} A';
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
          'Seção de Condutores',
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
                _buildModeSelector(),
                if (_modoCalculo == 'potencia')
                  _buildTextField(
                    label: 'Potência (W)',
                    hint: 'Digite a potência em Watts',
                    controller: _potenciaController,
                    keyboardType: TextInputType.number,
                  ),
                if (_modoCalculo == 'corrente')
                  _buildTextField(
                    label: 'Corrente (A)',
                    hint: 'Digite a corrente em Ampères',
                    controller: _correnteController,
                    keyboardType: TextInputType.number,
                  ),
                _buildDropdownField(
                  label: 'Tensão (V)',
                  value: _tensaoSelecionada,
                  items: tensoes,
                  onChanged: (newValue) {
                    setState(() {
                      _tensaoSelecionada = newValue;
                    });
                  },
                ),
                // NOVIDADE: Condição para exibir o campo de Fase
                if (_modoCalculo == 'potencia')
                  _buildDropdownField(
                    label: 'Fase',
                    value: _faseSelecionada,
                    items: fases,
                    onChanged: (newValue) {
                      setState(() {
                        _faseSelecionada = newValue;
                      });
                    },
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
                _buildDropdownField(
                  label: 'Tipo de Condutor',
                  value: _tipoCondutorSelecionado,
                  items: tiposCondutor,
                  onChanged: (newValue) {
                    setState(() {
                      _tipoCondutorSelecionado = newValue;
                    });
                  },
                ),
                _buildDropdownField(
                  label: 'Material Isolante',
                  value: _materialIsolanteSelecionado,
                  items: materiaisIsolantes,
                  onChanged: (newValue) {
                    setState(() {
                      _materialIsolanteSelecionado = newValue;
                    });
                  },
                ),
                _buildDropdownField(
                  label: 'Método de Instalação',
                  value: _metodoInstalacaoSelecionado,
                  items: metodosInstalacao,
                  onChanged: (newValue) {
                    setState(() {
                      _metodoInstalacaoSelecionado = newValue;
                    });
                  },
                ),
                _buildTextField(
                  label: 'Temperatura Ambiente (°C)',
                  hint: 'Ex: 30',
                  controller: _temperaturaController,
                  keyboardType: TextInputType.number,
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

  Widget _buildModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            'Modo de Cálculo',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text(
                  'Potência',
                  style: TextStyle(color: Colors.white),
                ),
                value: 'potencia',
                groupValue: _modoCalculo,
                onChanged: (value) {
                  setState(() {
                    _modoCalculo = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text(
                  'Corrente',
                  style: TextStyle(color: Colors.white),
                ),
                value: 'corrente',
                groupValue: _modoCalculo,
                onChanged: (value) {
                  setState(() {
                    _modoCalculo = value!;
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
          onTap: _calcularSecao,
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
