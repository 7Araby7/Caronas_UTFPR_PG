import 'package:caronas_utfpr/models/usuario.dart';
import 'package:caronas_utfpr/pages/novaCarona_page.dart';
import 'package:caronas_utfpr/repositories/usuario_repository.dart';
import 'package:caronas_utfpr/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:caronas_utfpr/models/veiculo.dart';
import 'package:provider/provider.dart';

class CadastrarVeiculoPage extends StatefulWidget {
  @override
  _CadastrarVeiculoPageState createState() => _CadastrarVeiculoPageState();
}

class _CadastrarVeiculoPageState extends State<CadastrarVeiculoPage> {
  final _formKey = GlobalKey<FormState>();
  final _modeloController = TextEditingController();
  final _placaController = TextEditingController();
  final _corController = TextEditingController();
  late UsuarioRepository usuarioRepository;

  @override
  void initState() {
    super.initState();
    usuarioRepository = UsuarioRepository(auth: context.read<AuthService>());
  }

  @override
  Widget build(BuildContext context) {
    Usuario logado = usuarioRepository.usuarioLogado();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Veículo'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _modeloController,
                decoration: InputDecoration(labelText: 'Modelo'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Informe o modelo do veículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _corController,
                decoration: InputDecoration(labelText: 'Cor'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Informe a cor do veículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _placaController,
                decoration: InputDecoration(labelText: 'Placa'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Informe a placa do veículo';
                  } else if (value!.length > 8 || value.length < 7) {
                    return 'Modelos aceitos: ABC-1234 | ABC1D23';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final novoVeiculo = Veiculo(
                      modelo: _modeloController.text,
                      placa: _placaController.text,
                      cor: _corController.text,
                    );
                    print('id logado ${logado.id}');
                    usuarioRepository.atribuirVeiculo(logado.id, novoVeiculo);

                    logado.veiculo = novoVeiculo;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NovaCaronaPage(),
                      ),
                    );
                  }
                },
                child: Text('Cadastrar Veículo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _modeloController.dispose();
    _placaController.dispose();
    _corController.dispose();
    super.dispose();
  }
}
