import 'package:caronas_utfpr/models/veiculo.dart';

class Usuario {
  String? id;
  String nome;
  String email;
  String ra;
  String fotoPerfil;
  String senha;
  String telefone;
  Veiculo? veiculo;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.ra,
    required this.fotoPerfil,
    required this.senha,
    required this.telefone,
    required this.veiculo,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'ra': ra,
      'fotoPerfil': fotoPerfil,
      'telefone': telefone,
      'veiculo': veiculo != null ? veiculo!.toMap() : null,
    };
  }
}
