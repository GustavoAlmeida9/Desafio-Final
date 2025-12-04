import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/api_service.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';

class ProdutoFormScreen extends StatefulWidget {
  final Produto? produto;

  ProdutoFormScreen({super.key, this.produto});

  @override
  State<ProdutoFormScreen> createState() => _ProdutoFormScreenState();
}

class _ProdutoFormScreenState extends State<ProdutoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nomeController;
  late final TextEditingController descricaoController;
  late final TextEditingController precoController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.produto?.nome ?? '');
    descricaoController =
        TextEditingController(text: widget.produto?.descricao ?? '');
    precoController = TextEditingController(
        text: widget.produto?.preco.toString() ?? '');
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    precoController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final preco = double.parse(precoController.text.replaceAll(',', '.'));
        final produto = Produto(
          id: widget.produto?.id,
          nome: nomeController.text.trim(),
          descricao: descricaoController.text.trim(),
          preco: preco,
          dataAtualizado: DateTime.now(),
        );

        if (produto.id != null) {
          await ApiService.updateProduto(produto);
        } else {
          await ApiService.addProduto(produto);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(produto.id != null
                  ? 'Produto atualizado com sucesso!'
                  : 'Produto adicionado com sucesso!'),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.produto != null;
    return Scaffold(
      appBar: CustomAppBar(
        title: isEditing ? 'Editar Produto' : 'Novo Produto',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite a descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: precoController,
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o preço';
                  }
                  final preco = double.tryParse(value.replaceAll(',', '.'));
                  if (preco == null || preco <= 0) {
                    return 'Digite um preço válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Mostrar data de atualização se estiver editando
              if (widget.produto?.dataAtualizado != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.update, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Última atualização: ${_formatDate(widget.produto!.dataAtualizado!)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              CustomButton(
                text: _isLoading ? 'Salvando...' : 'Salvar',
                onPressed: _isLoading ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
