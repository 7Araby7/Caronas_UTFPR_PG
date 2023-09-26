import 'package:caronas_utfpr/models/usuario.dart';

class Mensagem {
  final Usuario remetente;
  final String mensagem;
  final DateTime dataHora;

  Mensagem({
    required this.remetente,
    required this.mensagem,
    required this.dataHora,
  });
}
