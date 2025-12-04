class Produto {
  int? id;
  String nome;
  String descricao;
  double preco;
  DateTime? dataAtualizado;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    this.dataAtualizado,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic dateValue) {
      if (dateValue == null) return null;
      try {
        if (dateValue is String) {
          // Tenta parsear diferentes formatos
          if (dateValue.contains('T')) {
            return DateTime.parse(dateValue);
          } else if (dateValue.contains(' ')) {
            // Formato MySQL: 'YYYY-MM-DD HH:mm:ss'
            return DateTime.parse(dateValue.replaceAll(' ', 'T'));
          } else {
            return DateTime.parse(dateValue);
          }
        }
        return null;
      } catch (e) {
        return null;
      }
    }

    // Parse do preço - pode vir como String ou num do backend
    double parsePreco(dynamic precoValue) {
      if (precoValue == null) return 0.0;
      if (precoValue is double) return precoValue;
      if (precoValue is int) return precoValue.toDouble();
      if (precoValue is String) {
        return double.tryParse(precoValue.replaceAll(',', '.')) ?? 0.0;
      }
      return 0.0;
    }

    return Produto(
      id: json['id'],
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      preco: parsePreco(json['preco']),
      dataAtualizado: parseDate(json['data_atualizado']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'data_atualizado': dataAtualizado?.toIso8601String(),
    };
  }
}
