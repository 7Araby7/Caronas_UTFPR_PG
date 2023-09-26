
import 'package:caronas_utfpr/models/usuario.dart';
import 'package:caronas_utfpr/repositories/veiculo_repository.dart';

class UsuarioRepository {
  static List<Usuario> usuarios = [
    Usuario(
        fotoPerfil: 'images/cat.png',
        nome: 'Gabriel',
        ra: '2406764',
        senha: '123',
        telefone: '(41) 9 9899-5100',
        veiculo: null),
    Usuario(
        fotoPerfil: 'images/man.png',
        nome: 'Rick',
        ra: '2443456',
        senha: '123',
        telefone: '(42) 9 9527-6429',
        veiculo: VeiculoRepository.veiculos[0]),
    Usuario(
        fotoPerfil: 'images/dog.png',
        nome: 'Dogg Snoop',
        ra: '24045324',
        senha: '123',
        telefone: '(42) 9 1794-5063',
        veiculo: VeiculoRepository.veiculos[1]),
    Usuario(
        fotoPerfil: 'images/man2.png',
        nome: 'Barack Osama',
        ra: '2432464',
        senha: '123',
        telefone: '(42) 9 6358-6690',
        veiculo: VeiculoRepository.veiculos[2]),
    Usuario(
        fotoPerfil: 'images/profile.png',
        nome: 'Random',
        ra: '2432466',
        senha: '123',
        telefone: '(42) 9 9152-5868',
        veiculo: VeiculoRepository.veiculos[3]),
  ];
}
