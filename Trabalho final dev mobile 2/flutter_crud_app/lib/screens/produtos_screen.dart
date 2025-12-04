import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/api_service.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_card.dart';
import '../widgets/navigation_drawer.dart' as nav;
import 'produto_form_screen.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  late Future<List<Produto>> produtos;

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  void _loadProdutos() {
    setState(() {
      produtos = ApiService.getProdutos();
    });
  }

  Future<void> _deleteProduto(Produto produto) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir o produto ${produto.nome}?'),
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
        await ApiService.deleteProduto(produto.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produto excluído com sucesso!')),
          );
          _loadProdutos();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir produto: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Produtos', showDrawer: true),
      drawer: const nav.AppNavigationDrawer(),
      body: FutureBuilder<List<Produto>>(
        future: produtos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data!;
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum produto cadastrado',
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
                _loadProdutos();
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final produto = list[index];
                  String dataFormatada = '';
                  if (produto.dataAtualizado != null) {
                    final date = produto.dataAtualizado!;
                    dataFormatada =
                        'Atualizado: ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                  }
                  return CustomCard(
                    title: produto.nome,
                    subtitle:
                        '${produto.descricao}\nR\$ ${produto.preco.toStringAsFixed(2)}${dataFormatada.isNotEmpty ? '\n$dataFormatada' : ''}',
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProdutoFormScreen(produto: produto),
                        ),
                      );
                      _loadProdutos();
                    },
                    onDelete: () => _deleteProduto(produto),
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
                    onPressed: _loadProdutos,
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
            MaterialPageRoute(builder: (_) => ProdutoFormScreen()),
          );
          _loadProdutos();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
