import 'package:caronas_utfpr/controllers/login_controller.dart';
import 'package:caronas_utfpr/repositories/carona_repository.dart';
import 'package:flutter/material.dart';
import 'package:caronas_utfpr/pages/carona_page.dart';
import 'package:provider/provider.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({Key? key}) : super(key: key);

  @override
  _HistoricoPageState createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  bool sentido = true;

  @override
  Widget build(BuildContext context) {
    final tabela = CaronaRepository.tabela;
    final logado = Provider.of<LoginController>(context);
    bool historico = tabela.any((carona) =>
        (carona.condutor.ra == logado.usuarioLogado.ra ||
            carona.passageiros.any(
                (passageiro) => passageiro.ra == logado.usuarioLogado.ra)) &&
        carona.sentidoUtf == sentido &&
        carona.finalizado);
    Widget appBarTitulo = sentido ? Text('Sentido UTFPR') : Text('Saída UTFPR');

    return Scaffold(
      appBar: AppBar(title: appBarTitulo, actions: [
        IconButton(
          padding: EdgeInsets.only(right: 30.0),
          icon: Icon(Icons.compare_arrows_rounded),
          onPressed: () {
            setState(() {
              sentido = !sentido;
            });
            print(sentido);
          },
        ),
      ]),
      body: historico
          ? ListView.separated(
              itemBuilder: (BuildContext context, int carona) {
                if ((tabela[carona].condutor.ra == logado.usuarioLogado.ra ||
                        tabela[carona].passageiros.any((passageiro) =>
                            passageiro.ra == logado.usuarioLogado.ra)) &&
                    tabela[carona].sentidoUtf == sentido &&
                    tabela[carona].finalizado) {
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
                        backgroundImage:
                            AssetImage(tabela[carona].condutor.fotoPerfil),
                      ),
                      title: Text(tabela[carona].local),
                      subtitle: Text(
                          'Dia: ${tabela[carona].dia}\nHora: ${tabela[carona].hora}\nPreço: R\$ ${tabela[carona].preco}\nVagas: ${tabela[carona].vagas}'),
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
                                    carona: tabela[carona],
                                    caronaIndex: carona),
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
              itemCount: tabela.length,
            )
          : Center(
              child: Text("Historico vazio."),
            ),
    );
  }
}
