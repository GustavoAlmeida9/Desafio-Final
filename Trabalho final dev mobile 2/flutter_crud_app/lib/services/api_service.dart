import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';
import '../models/produto.dart';

class ApiService {
  // Para Android Emulator use: http://10.0.2.2:3000
  // Para iOS Simulator use: http://localhost:3000
  // Para dispositivo físico use: http://SEU_IP_LOCAL:3000
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  // Clientes
  static Future<List<Cliente>> getClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/clientes'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Cliente.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar clientes');
    }
  }

  static Future<void> addCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clientes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao adicionar cliente');
    }
  }

  static Future<void> updateCliente(Cliente cliente) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clientes/${cliente.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cliente.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar cliente');
    }
  }

  static Future<void> deleteCliente(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/clientes/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar cliente');
    }
  }

  // Produtos
  static Future<List<Produto>> getProdutos() async {
    final response = await http.get(Uri.parse('$baseUrl/produtos'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Produto.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar produtos');
    }
  }

  static Future<void> addProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produtos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao adicionar produto');
    }
  }

  static Future<void> updateProduto(Produto produto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/produtos/${produto.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar produto');
    }
  }

  static Future<void> deleteProduto(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/produtos/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar produto');
    }
  }
}
