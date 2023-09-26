import 'package:caronas_utfpr/models/mensagens.dart';
import 'package:caronas_utfpr/repositories/usuario_repository.dart';

class MensagensRepository {
  static List<Mensagem> mensagens = [
    Mensagem(
        remetente: UsuarioRepository.usuarios[1],
        mensagem: "Olá, como você está?",
        dataHora: DateTime.now()),
    Mensagem(
        remetente: UsuarioRepository.usuarios[2],
        mensagem: "Estou bem, obrigado! E você?",
        dataHora: DateTime.now()),
    Mensagem(
        remetente: UsuarioRepository.usuarios[3],
        mensagem: "TALKEY ?",
        dataHora: DateTime.now()),
    Mensagem(
        remetente: UsuarioRepository.usuarios[4],
        mensagem: "alow ?",
        dataHora: DateTime.now()),
  ];
}
