import 'package:caronas_utfpr/models/usuario.dart';
import 'package:caronas_utfpr/pages/home_page.dart';
import 'package:caronas_utfpr/repositories/usuario_repository.dart';
import 'package:caronas_utfpr/services/auth_service.dart';
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
  late CaronaRepository caronaRepository;
  late UsuarioRepository usuarioRepository;

  @override
  void initState() {
    super.initState();
    vagasDisponiveis = widget.carona.vagas;
    caronaRepository = CaronaRepository(auth: context.read<AuthService>());
    usuarioRepository = UsuarioRepository(auth: context.read<AuthService>());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void reservarCarona(Usuario logado) {
    setState(() {
      if (vagasDisponiveis > 0) {
        vagasDisponiveis--;
        caronaRepository.reservarCarona(widget.caronaIndex, logado);
      }
    });
  }

  void cancelarPassageiro(Usuario logado) {
    setState(() {
      vagasDisponiveis++;
      caronaRepository.cancelarPassageiro(widget.caronaIndex, logado);
    });
  }

  @override
  Widget build(BuildContext context) {
    Usuario logado = usuarioRepository.usuarioLogado();
    bool condutor = widget.carona.condutor.ra == logado.ra;
    bool naoReservado = widget.carona.condutor.ra != logado.ra &&
        !widget.carona.passageiros
            .any((passageiro) => passageiro.ra == logado.ra);
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
                    widget.carona.sentidoUtf
                        ? '${widget.carona.local} sentido UTFPR'
                        : 'UTFPR sentido ${widget.carona.local}',
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
                    widget.carona.finalizado
                        ? 'Carona Finalizada'
                        : 'Vagas Disponíveis: $vagasDisponiveis',
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
                          reservarCarona(logado);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(initialPage: 1),
                            ),
                            (route) => false,
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
                  caronaRepository.finalizarCarona(widget.caronaIndex);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(initialPage: 0),
                    ),
                    (route) => false,
                  );
                },
                child: Text('Finalizar Carona'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                ),
              ),
            SizedBox(
              height: 20,
            ),
            if (!naoReservado && !widget.carona.finalizado)
              ElevatedButton(
                onPressed: () {
                  if (condutor) {
                    caronaRepository.excluirCarona(widget.caronaIndex);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(initialPage: 0),
                      ),
                      (route) => false,
                    );
                  } else {
                    cancelarPassageiro(logado);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(initialPage: 0),
                      ),
                      (route) => false,
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
