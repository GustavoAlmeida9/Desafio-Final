import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/api_service.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/cliente_card.dart';
import '../widgets/navigation_drawer.dart' as nav;
import 'cliente_form_screen.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  late Future<List<Cliente>> clientes;

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  void _loadClientes() {
    setState(() {
      clientes = ApiService.getClientes();
    });
  }

  Future<void> _deleteCliente(Cliente cliente) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir o cliente ${cliente.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.deleteCliente(cliente.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente excluído com sucesso!')),
          );
          _loadClientes();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir cliente: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Clientes', showDrawer: true),
      drawer: const nav.AppNavigationDrawer(),
      body: FutureBuilder<List<Cliente>>(
        future: clientes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data!;
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum cliente cadastrado',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toque no botão + para adicionar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                _loadClientes();
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final cliente = list[index];
                  return ClienteCard(
                    nome: cliente.nome,
                    sobrenome: cliente.sobrenome,
                    email: cliente.email,
                    idade: cliente.idade,
                    fotoUrl: cliente.foto,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClienteFormScreen(cliente: cliente),
                        ),
                      );
                      _loadClientes();
                    },
                    onDelete: () => _deleteCliente(cliente),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erro: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadClientes,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ClienteFormScreen()),
          );
          _loadClientes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
