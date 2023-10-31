import 'package:caronas_utfpr/database/db_firestore.dart';
import 'package:caronas_utfpr/models/usuario.dart';
import 'package:caronas_utfpr/models/veiculo.dart';
import 'package:caronas_utfpr/repositories/veiculo_repository.dart';
import 'package:caronas_utfpr/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsuarioRepository extends ChangeNotifier {
  static List<Usuario> listUsuarios = [
    Usuario(
        id: "",
        email: 'gabriel@gmail.com',
        fotoPerfil: 'images/cat.png',
        nome: 'Gabriel',
        ra: '2406764',
        senha: '123123',
        telefone: '(41) 9 9899-5100',
        veiculo: null),
    Usuario(
        id: "",
        email: 'rick@gmail.com',
        fotoPerfil: 'images/man.png',
        nome: 'Rick',
        ra: '2443456',
        senha: '123123',
        telefone: '(42) 9 9527-6429',
        veiculo: VeiculoRepository.veiculos[0]),
    Usuario(
        id: "",
        email: 'dogg@gmail.com',
        fotoPerfil: 'images/dog.png',
        nome: 'Dogg Snoop',
        ra: '24045324',
        senha: '123123',
        telefone: '(42) 9 1794-5063',
        veiculo: VeiculoRepository.veiculos[1]),
    Usuario(
        id: "",
        email: 'osama@gmail.com',
        fotoPerfil: 'images/man2.png',
        nome: 'Barack Osama',
        ra: '2432464',
        senha: '123123',
        telefone: '(42) 9 6358-6690',
        veiculo: VeiculoRepository.veiculos[2]),
    Usuario(
        id: "",
        email: 'random@gmail.com',
        fotoPerfil: 'images/profile.png',
        nome: 'Random',
        ra: '2432466',
        senha: '123123',
        telefone: '(42) 9 9152-5868',
        veiculo: VeiculoRepository.veiculos[3]),
  ];
  late FirebaseFirestore db;
  late AuthService auth;

  UsuarioRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    //descomentar e rodar a primeira vez para adicionar os exemplos. (comentar depois de fazer login)
    //await _addExemplo();
    await listarUsuarios();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  atribuirVeiculo(String? id, Veiculo veiculo) async {
    try {
      if (id != null && id.isNotEmpty) {
        if (auth.usuario != null) {
          final userRef = db.collection('Usuarios').doc(id);

          final veiculoData = {
            'modelo': veiculo.modelo,
            'placa': veiculo.placa,
            'cor': veiculo.cor,
          };

          await userRef.update({
            'veiculo': veiculoData,
          });

          final usuarioAtualizado = usuarioLogado();
          usuarioAtualizado.veiculo = veiculo;

          notifyListeners();
        }
      }
    } catch (e) {
      print('Erro ao atribuir veículo: $e');
      throw e;
    }
  }

  getUsuarioAnonimo() {
    return Usuario(
      id: "",
      nome: 'Anônimo',
      email: 'anonimo@example.com',
      ra: '0000000',
      fotoPerfil: 'profile.png',
      senha: 'senha_padrao',
      telefone: '0000-0000',
      veiculo: null,
    );
  }

  Usuario usuarioLogado() {
    if (auth.usuario != null) {
      String emailLogado = auth.getEmailLogado();
      for (var element in listUsuarios) {
        if (element.email == emailLogado) {
          print('usuario logado ${element.nome}');
          return element;
        }
      }
    }
    return getUsuarioAnonimo();
  }

  _addExemplo() {
    listUsuarios.forEach((element) {
      criarUsuario(element);
    });
  }

  void criarUsuario(Usuario novoUsuario) async {
    Map<String, dynamic> usuarioMap = novoUsuario.toMap();

    await db.collection('Usuarios').add(usuarioMap);
  }

  Future<List<Usuario>> listarUsuarios() async {
    print("Usuario no Listar/usuario: ${auth.usuario}");
    try {
      if (auth.usuario != null) {
        final querySnapshot = await db.collection('Usuarios').get();
        final usuarios = querySnapshot.docs.map((doc) async {
          final data = doc.data() as Map<String, dynamic>;

          final veiculoData = data['veiculo'] as Map<String, dynamic>?;

          final usuarioId = doc.id;

          final veiculo = veiculoData != null
              ? Veiculo(
                  modelo: veiculoData['modelo'] ?? '',
                  placa: veiculoData['placa'] ?? '',
                  cor: veiculoData['cor'] ?? '',
                )
              : null;

          Usuario usuario = Usuario(
            id: usuarioId,
            email: data['email'] ?? '',
            fotoPerfil: data['fotoPerfil'] ?? 'profile.png',
            nome: data['nome'] ?? '',
            ra: data['ra'] ?? '',
            senha: data['senha'] ?? '',
            telefone: data['telefone'] ?? '',
            veiculo: veiculo,
          );
          return usuario;
        }).toList();

        final usuariosCompletos = await Future.wait(usuarios);

        listUsuarios = usuariosCompletos;

        print("Número de usuarios no Firestore: ${usuariosCompletos.length}");

        return usuariosCompletos;
      } else {
        print("Erro na autenticação");
        return [];
      }
    } catch (e) {
      print('Erro ao listar usuarios: $e');
      throw e;
    }
  }

  static Future<Usuario?> buscarUsuarioPorRA(String ra) async {
    Usuario? usuarioEncontrado;
    try {
      usuarioEncontrado = listUsuarios.firstWhere(
        (usuario) => usuario.ra == ra,
      );
    } catch (e) {
      usuarioEncontrado = null;
    }
    return usuarioEncontrado;
  }
}
