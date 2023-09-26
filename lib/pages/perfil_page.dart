import 'package:caronas_utfpr/controllers/login_controller.dart';
import 'package:caronas_utfpr/pages/historico_page.dart';
import 'package:caronas_utfpr/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logado = Provider.of<LoginController>(context);
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
              backgroundImage: AssetImage(logado.usuarioLogado.fotoPerfil),
            ),
            SizedBox(height: 20),
            Text(
              logado.usuarioLogado.nome,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Número: ${logado.usuarioLogado.telefone}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'RA: a${logado.usuarioLogado.ra}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HistoricoPage(),
                  ),
                );
              },
              child: Text('Histórico'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                logado.logado = false;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LoginPage(),
                  ),
                );
              },
              child: Text('Sair'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
