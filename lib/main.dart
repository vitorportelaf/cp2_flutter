import 'package:flutter/material.dart';

void main() {
  runApp(const CadastroEventoApp());
}

class CadastroEventoApp extends StatelessWidget {
  const CadastroEventoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Evento',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const CadastroScreen(),
    );
  }
}

// ============================================================
// ENUM - Tipo de ingresso (item 3)
// ============================================================
enum TicketType {
  padrao(title: 'Padrão'),
  vip(title: 'VIP'),
  estudante(title: 'Estudante');

  final String title;
  const TicketType({required this.title});
}

// ============================================================
// ENUM - Atividades de interesse (item 4)
// ============================================================
enum Activity {
  palestras(title: 'Palestras'),
  workshops(title: 'Workshops'),
  networking(title: 'Networking');

  final String title;
  const Activity({required this.title});
}

// ============================================================
// TELA DO FORMULÁRIO
// ============================================================
class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _groupSizeController = TextEditingController();

  // Estado dos componentes
  TicketType _selectedTicket = TicketType.padrao;

  final Map<Activity, bool> _selectedActivities = {
    for (var a in Activity.values) a: false,
  };

  bool _participaEmGrupo = false;
  double _interesse = 5;

  @override
  void dispose() {
    _nameController.dispose();
    _groupSizeController.dispose();
    super.dispose();
  }

  void _confirmarInscricao() {
    final atividades = _selectedActivities.entries
        .where((e) => e.value)
        .map((e) => e.key.title)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResumoScreen(
          nome: _nameController.text,
          tipoIngresso: _selectedTicket.title,
          atividades: atividades,
          participaEmGrupo: _participaEmGrupo,
          quantidadePessoas: _participaEmGrupo
              ? _groupSizeController.text
              : '',
          nivelInteresse: _interesse.toInt(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==========================================
                      // 1. HEADER (1,5 pts)
                      // ==========================================
                      Row(
                        children: const [
                          Icon(Icons.event_note),
                          SizedBox(width: 8),
                          Text(
                            'Cadastro de Evento',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ==========================================
                      // 2. CAMPO NOME (1,0 pt)
                      // ==========================================
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome completo',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ==========================================
                      // 3. TIPO DE INGRESSO - RadioButton (1,5 pts)
                      // ==========================================
                      const Text('Tipo de ingresso'),
                      ...TicketType.values.map((type) {
                        return RadioListTile<TicketType>(
                          contentPadding: EdgeInsets.zero,
                          value: type,
                          groupValue: _selectedTicket,
                          title: Text(type.title),
                          onChanged: (value) {
                            setState(() {
                              _selectedTicket = value!;
                            });
                          },
                        );
                      }),
                      const SizedBox(height: 8),

                      // ==========================================
                      // 4. ATIVIDADES DE INTERESSE - Checkbox (1,0 pt)
                      // ==========================================
                      const Text('Atividades de interesse'),
                      ...Activity.values.map((activity) {
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: _selectedActivities[activity],
                          onChanged: (value) {
                            setState(() {
                              _selectedActivities[activity] = value ?? false;
                            });
                          },
                          title: Text(activity.title),
                          controlAffinity: ListTileControlAffinity.trailing,
                        );
                      }),
                      const SizedBox(height: 8),

                      // ==========================================
                      // 5. PARTICIPAÇÃO EM GRUPO - Switch (2,0 pts)
                      // ==========================================
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Participar em grupo'),
                          ),
                          Switch(
                            value: _participaEmGrupo,
                            onChanged: (value) {
                              setState(() {
                                _participaEmGrupo = value;
                              });
                            },
                          ),
                        ],
                      ),

                      // Campo de quantidade só aparece se Switch estiver ativado
                      if (_participaEmGrupo) ...[
                        const SizedBox(height: 8),
                        TextField(
                          controller: _groupSizeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantidade de pessoas',
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // ==========================================
                      // 6. NÍVEL DE INTERESSE - Slider (1,0 pt)
                      // ==========================================
                      Text('Nível de interesse: ${_interesse.toInt()}'),
                      Slider(
                        value: _interesse,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: _interesse.toInt().toString(),
                        onChanged: (value) {
                          setState(() {
                            _interesse = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // ==========================================
              // 7. BOTÃO CONFIRMAR INSCRIÇÃO (2,0 pts)
              // ==========================================
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _confirmarInscricao,
                  child: const Text(
                    'Confirmar inscrição',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TELA DE RESUMO
// ============================================================
class ResumoScreen extends StatelessWidget {
  final String nome;
  final String tipoIngresso;
  final List<String> atividades;
  final bool participaEmGrupo;
  final String quantidadePessoas;
  final int nivelInteresse;

  const ResumoScreen({
    super.key,
    required this.nome,
    required this.tipoIngresso,
    required this.atividades,
    required this.participaEmGrupo,
    required this.quantidadePessoas,
    required this.nivelInteresse,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (igual a tela 1)
                      Row(
                        children: const [
                          Icon(Icons.event_note),
                          SizedBox(width: 8),
                          Text(
                            'Cadastro de Evento',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Resumo da inscrição',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text('Nome: $nome'),
                      Text('Ingresso: $tipoIngresso'),
                      Text(
                        'Atividades: ${atividades.isEmpty ? "Nenhuma" : atividades.join(", ")}',
                      ),
                      Text(
                        'Participação em grupo: ${participaEmGrupo ? "Sim" : "Não"}',
                      ),
                      if (participaEmGrupo)
                        Text(
                          'Quantidade de pessoas: ${quantidadePessoas.isEmpty ? "Não informado" : quantidadePessoas}',
                        ),
                      Text('Nível de interesse: $nivelInteresse'),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Voltar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
