import 'package:caronas_utfpr/models/carona.dart';
import 'package:caronas_utfpr/models/usuario.dart';
import 'package:caronas_utfpr/repositories/carona_repository.dart';
import 'package:caronas_utfpr/repositories/usuario_repository.dart';
import 'package:caronas_utfpr/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:caronas_utfpr/pages/carona_page.dart';
import 'package:provider/provider.dart';

class MyCaronasPage extends StatefulWidget {
  const MyCaronasPage({Key? key}) : super(key: key);

  @override
  _MyCaronasPageState createState() => _MyCaronasPageState();
}

class _MyCaronasPageState extends State<MyCaronasPage> {
  bool sentido = true;
  bool CaronaDisponivel = false;
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
        title: sentido ? Text('Sentido UTFPR') : Text('Saída UTFPR'),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 30.0),
            icon: Icon(Icons.compare_arrows_rounded),
            onPressed: () {
              setState(() {
                sentido = !sentido;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Carona>>(
        future: context.read<CaronaRepository>().listarCaronas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            final caronas = snapshot.data!;

            return ListView.separated(
              itemBuilder: (BuildContext context, int caronaIndex) {
                final carona = caronas[caronaIndex];
                final usuarioLogado = logado;

                if ((carona.condutor.ra == usuarioLogado.ra ||
                        carona.passageiros.any((passageiro) =>
                            passageiro.ra == usuarioLogado.ra)) &&
                    carona.sentidoUtf == sentido &&
                    !carona.finalizado) {
                  CaronaDisponivel = true;
                  return Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(carona.condutor.fotoPerfil),
                      ),
                      title: Text(carona.local),
                      subtitle: Text(
                          'Dia: ${carona.dia}\nHora: ${carona.hora}\nPreço: R\$ ${carona.preco}\nVagas: ${carona.vagas}'),
                      trailing: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.yellow,
                            width: 2,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CaronaPage(
                                  carona: carona,
                                  caronaIndex: caronaIndex,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Visualizar',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
              padding: const EdgeInsets.all(10),
              separatorBuilder: (_, ____) => Container(height: 0),
              itemCount: caronas.length,
            );
          }
        },
      ),
    );
  }
}
