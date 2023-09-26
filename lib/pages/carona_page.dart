import 'package:caronas_utfpr/controllers/login_controller.dart';
import 'package:caronas_utfpr/pages/home_page.dart';
import 'package:caronas_utfpr/pages/my_caronas_page.dart';
import 'package:flutter/material.dart';
import 'package:caronas_utfpr/models/carona.dart';
import 'package:caronas_utfpr/repositories/carona_repository.dart';
import 'package:provider/provider.dart';

class CaronaPage extends StatefulWidget {
  final Carona carona;
  final int caronaIndex;

  const CaronaPage({Key? key, required this.carona, required this.caronaIndex})
      : super(key: key);

  @override
  _CaronaPageState createState() => _CaronaPageState();
}

class _CaronaPageState extends State<CaronaPage> {
  int vagasDisponiveis = 0;
  late LoginController logado;

  @override
  void initState() {
    super.initState();
    vagasDisponiveis = widget.carona.vagas;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logado = Provider.of<LoginController>(context);
  } //só funcionou o provider usando esse metodo por conta do reservarcarona estar fora do build

  void reservarCarona() {
    setState(() {
      if (vagasDisponiveis > 0) {
        vagasDisponiveis--;
        CaronaRepository.reservarCarona(
            widget.caronaIndex, logado.usuarioLogado);
      }
    });
  }

  void cancelarPassageiro() {
    setState(() {
      vagasDisponiveis++;
      CaronaRepository.cancelarPassageiro(
          widget.caronaIndex, logado.usuarioLogado);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool condutor = widget.carona.condutor.ra == logado.usuarioLogado.ra;
    bool naoReservado = widget.carona.condutor.ra != logado.usuarioLogado.ra &&
        !widget.carona.passageiros
            .any((passageiro) => passageiro.ra == logado.usuarioLogado.ra);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Carona'),
        backgroundColor: Colors.yellow.shade400,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.yellow.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Local: ${widget.carona.local}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Dia: ${widget.carona.dia}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Hora: ${widget.carona.hora}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Preço: R\$ ${widget.carona.preco.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Vagas Disponíveis: $vagasDisponiveis',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Informações do condutor:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage(widget.carona.condutor.fotoPerfil),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nome: ${widget.carona.condutor.nome}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Número: ${widget.carona.condutor.telefone}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '\nVeículo: ${widget.carona.condutor.veiculo?.modelo} ${widget.carona.condutor.veiculo?.cor}\nPlaca: ${widget.carona.condutor.veiculo?.placa}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: naoReservado
                  ? ElevatedButton(
                      onPressed: () {
                        if (vagasDisponiveis > 0) {
                          reservarCarona();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyCaronasPage(),
                            ),
                          );
                        }
                      },
                      child: Text('Reservar'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow),
                      ),
                    )
                  : SizedBox(),
            ),
            if (condutor && !widget.carona.finalizado)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.carona.finalizado = true;
                  });
                  CaronaRepository.finalizarCarona(widget.caronaIndex);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                },
                child: Text('Finalizar Carona'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                ),
              ),
            if (!naoReservado && !widget.carona.finalizado)
              ElevatedButton(
                onPressed: () {
                  if (condutor) {
                    CaronaRepository.excluirCarona(widget.caronaIndex);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyCaronasPage(),
                      ),
                    );
                  } else {
                    cancelarPassageiro();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyCaronasPage(),
                      ),
                    );
                  }
                },
                child: Text('Cancelar carona'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
