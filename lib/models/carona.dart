import 'package:caronas_utfpr/models/usuario.dart';

class Carona {
  String? id;
  Usuario condutor;
  List<Usuario> passageiros = [];
  String local;
  int vagas;
  double preco;
  String dia;
  String hora;
  bool sentidoUtf;
  bool finalizado;

  Carona({
    required this.condutor,
    required this.local,
    required this.vagas,
    required this.preco,
    required this.dia,
    required this.hora,
    required this.sentidoUtf,
    required this.finalizado,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'condutor': condutor.toMap(),
      'passageiros': passageiros.map((usuario) => usuario.toMap()).toList(),
      'local': local,
      'vagas': vagas,
      'preco': preco,
      'dia': dia,
      'hora': hora,
      'sentidoUtf': sentidoUtf,
      'finalizado': finalizado,
    };
  }

  void adicionarPassageiro(Usuario passageiro) {
    if (passageiros.length < 4) {
      passageiros.add(passageiro);
    } else {
      print("A carona já está com a capacidade máxima de passageiros.");
    }
  }

  void removerPassageiro(Usuario passageiro) {
    if (passageiros.length > 0) passageiros.remove(passageiro);
  }
}
