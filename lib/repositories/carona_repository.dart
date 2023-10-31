import 'package:caronas_utfpr/database/db_firestore.dart';
import 'package:caronas_utfpr/models/carona.dart';
import 'package:caronas_utfpr/models/usuario.dart';
import 'package:caronas_utfpr/repositories/usuario_repository.dart';
import 'package:caronas_utfpr/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CaronaRepository extends ChangeNotifier {
  static List<Carona> tabela = [
    Carona(
        id: "",
        condutor: UsuarioRepository.listUsuarios[1],
        local: 'Condor',
        vagas: 3,
        preco: 2.00,
        dia: '27/09',
        hora: '14:15',
        sentidoUtf: true,
        finalizado: false),
    Carona(
        id: "",
        condutor: UsuarioRepository.listUsuarios[2],
        local: 'Tozetto',
        vagas: 1,
        preco: 6.00,
        dia: '27/09',
        hora: '18:20',
        sentidoUtf: false,
        finalizado: false),
    Carona(
        id: "",
        condutor: UsuarioRepository.listUsuarios[3],
        local: 'Monteiro Lobato',
        vagas: 1,
        preco: 3.00,
        dia: '27/09',
        hora: '07:00',
        sentidoUtf: true,
        finalizado: false),
    Carona(
        id: "",
        condutor: UsuarioRepository.listUsuarios[4],
        local: 'Centro',
        vagas: 3,
        preco: 10.00,
        dia: '27/09',
        hora: '09:30',
        sentidoUtf: false,
        finalizado: false)
  ];
  late FirebaseFirestore db;
  late AuthService auth;

  CaronaRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    //descomentar e rodar a primeira vez para adicionar os exemplos. (comentar depois de fazer login)
    //await _addExemplo();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  _addExemplo() {
    tabela.forEach((element) {
      criarCarona(element);
    });
  }

  void criarCarona(Carona novaCarona) async {
    Map<String, dynamic> caronaMap = novaCarona.toMap();

    await db.collection('Caronas').add(caronaMap);
  }

  Future<void> reservarCarona(int indice, Usuario passageiro) async {
    if (indice >= 0 && indice < tabela.length) {
      if (tabela[indice].vagas > 0) {
        tabela[indice].vagas--;
        tabela[indice].adicionarPassageiro(passageiro);

        final carona = tabela[indice];
        await db.collection('Caronas').doc(carona.id).update({
          'vagas': carona.vagas,
          'passageiros':
              carona.passageiros.map((usuario) => usuario.toMap()).toList(),
        });
      }
    }
  }

  Future<void> cancelarPassageiro(int indice, Usuario passageiro) async {
    if (indice >= 0 && indice < tabela.length) {
      final carona = tabela[indice];

      if (carona.passageiros.contains(passageiro)) {
        carona.removerPassageiro(passageiro);
        carona.vagas++;

        await db.collection('Caronas').doc(carona.id).update({
          'vagas': carona.vagas,
          'passageiros':
              carona.passageiros.map((usuario) => usuario.toMap()).toList(),
        });
      }
    }
  }

  Future<void> excluirCarona(int indice) async {
    if (indice >= 0 && indice < tabela.length) {
      final carona = tabela[indice];

      tabela.removeAt(indice);

      await db.collection('Caronas').doc(carona.id).delete();
    }
  }

  Future<void> finalizarCarona(int indice) async {
    if (indice >= 0 && indice < tabela.length) {
      final carona = tabela[indice];

      carona.finalizado = true;

      await db
          .collection('Caronas')
          .doc(carona.id)
          .update({'finalizado': true});
    }
  }

  Future<List<Carona>> listarCaronas() async {
    print("Usuario no Listar/carona: ${auth.usuario}");
    try {
      if (auth.usuario != null) {
        final querySnapshot = await db.collection('Caronas').get();

        final caronas = querySnapshot.docs.map((doc) async {
          final data = doc.data() as Map<String, dynamic>;
          final condutor = await UsuarioRepository.buscarUsuarioPorRA(
              data['condutor']['ra']);

          final caronaId = doc.id;

          final passageirosList = data['passageiros'] as List<dynamic>;

          final passageiros =
              await Future.wait(passageirosList.map((passageiroData) async {
            final passageiro = await UsuarioRepository.buscarUsuarioPorRA(
                passageiroData['ra']);
            return passageiro ??
                Usuario(
                  id: "",
                  email: 'ERRO',
                  nome: 'ERRO',
                  ra: passageiroData['ra'],
                  fotoPerfil: 'profile.png',
                  senha: 'ERRO',
                  telefone: 'ERRO',
                  veiculo: null,
                );
          }));

          Carona carona = Carona(
            id: caronaId,
            condutor: condutor ??
                Usuario(
                  id: "",
                  email: 'ERRO',
                  nome: 'ERRO',
                  ra: data['condutor']['ra'],
                  fotoPerfil: 'profile.png',
                  senha: 'ERRO',
                  telefone: 'ERRO',
                  veiculo: null,
                ),
            local: data['local'],
            vagas: data['vagas'] ?? 0,
            preco: data['preco'] ?? 0.0,
            dia: data['dia'] ?? 'DataPadrao',
            hora: data['hora'] ?? 'HoraPadrao',
            sentidoUtf: data['sentidoUtf'] ?? false,
            finalizado: data['finalizado'] ?? false,
          );
          passageiros.forEach((element) {
            carona.adicionarPassageiro(element);
          });

          return carona;
        }).toList();

        final caronasCompletas = await Future.wait(caronas);

        tabela = caronasCompletas;

        print("Número de caronas no Firestore: ${caronasCompletas.length}");

        return caronasCompletas;
      } else {
        print("Erro na autenticação de caronas");
        return [];
      }
    } catch (e) {
      print('Erro ao listar caronas: $e');
      throw e;
    }
  }
}
