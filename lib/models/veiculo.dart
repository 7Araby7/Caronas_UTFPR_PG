class Veiculo {
  String modelo;
  String placa;
  String cor;

  Veiculo({
    required this.modelo,
    required this.placa,
    required this.cor,
  });

  Map<String, dynamic> toMap() {
    return {
      'modelo': modelo,
      'placa': placa,
      'cor': cor,
    };
  }
}
