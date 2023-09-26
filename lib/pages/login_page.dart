import 'package:flutter/material.dart';
import 'package:caronas_utfpr/controllers/login_controller.dart';
import 'package:caronas_utfpr/pages/home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key});

  final TextEditingController _raController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LoginController _loginController =
        Provider.of<LoginController>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logoUTFPR.png',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _raController,
              decoration: InputDecoration(
                labelText: 'RA',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final String ra = _raController.text;
                final String senha = _senhaController.text;

                final bool loginValido =
                    await _loginController.validarLogin(ra, senha);

                if (loginValido) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('RA ou senha inválidos'),
                    ),
                  );
                }
              },
              child: Text('Fazer Login'),
            ),
          ],
        ),
      ),
    );
  }
}
