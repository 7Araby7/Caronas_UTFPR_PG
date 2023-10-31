import 'package:caronas_utfpr/models/usuario.dart';
import 'package:caronas_utfpr/pages/historico_page.dart';
import 'package:caronas_utfpr/repositories/usuario_repository.dart';
import 'package:caronas_utfpr/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
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
        title: Text('Perfil de Usuário'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(logado.fotoPerfil),
            ),
            SizedBox(height: 20),
            Text(
              logado.nome,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Número: ${logado.telefone}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'RA: a${logado.ra}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoricoPage(),
                  ),
                );
              },
              child: Text('Histórico'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<AuthService>().logout(),
              child: Text('Sair'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
