import 'package:caronas_utfpr/models/veiculo.dart';

class Usuario {
  String nome;
  String ra;
  String fotoPerfil;
  String senha;
  String telefone;
  Veiculo? veiculo;

  Usuario({
    required this.nome,
    required this.ra,
    required this.fotoPerfil,
    required this.senha,
    required this.telefone,
    required this.veiculo,
  });
}
