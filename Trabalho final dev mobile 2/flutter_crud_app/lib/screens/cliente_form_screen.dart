import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/cliente.dart';
import '../services/api_service.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente;

  ClienteFormScreen({super.key, this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late final TextEditingController nomeController;
  late final TextEditingController sobrenomeController;
  late final TextEditingController emailController;
  late final TextEditingController idadeController;
  File? _fotoSelecionada;
  String? _fotoUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.cliente?.nome ?? '');
    sobrenomeController =
        TextEditingController(text: widget.cliente?.sobrenome ?? '');
    emailController = TextEditingController(text: widget.cliente?.email ?? '');
    idadeController =
        TextEditingController(text: widget.cliente?.idade.toString() ?? '');
    _fotoUrl = widget.cliente?.foto;
  }

  @override
  void dispose() {
    nomeController.dispose();
    sobrenomeController.dispose();
    emailController.dispose();
    idadeController.dispose();
    super.dispose();
  }

  Future<void> _selecionarFoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _fotoSelecionada = File(image.path);
          _fotoUrl = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar foto: $e')),
        );
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final idade = int.parse(idadeController.text.trim());
        final cliente = Cliente(
          id: widget.cliente?.id,
          nome: nomeController.text.trim(),
          sobrenome: sobrenomeController.text.trim(),
          email: emailController.text.trim(),
          idade: idade,
          foto:
              _fotoUrl, // Por enquanto, apenas salva a URL. Em produção, você precisaria fazer upload da imagem
        );

        if (cliente.id != null) {
          await ApiService.updateCliente(cliente);
        } else {
          await ApiService.addCliente(cliente);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(cliente.id != null
                  ? 'Cliente atualizado com sucesso!'
                  : 'Cliente adicionado com sucesso!'),
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
    final isEditing = widget.cliente != null;
    return Scaffold(
      appBar: CustomAppBar(
        title: isEditing ? 'Editar Cliente' : 'Novo Cliente',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Foto
              Center(
                child: GestureDetector(
                  onTap: _selecionarFoto,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _fotoSelecionada != null
                            ? FileImage(_fotoSelecionada!)
                            : (_fotoUrl != null && _fotoUrl!.isNotEmpty
                                ? NetworkImage(_fotoUrl!) as ImageProvider
                                : null),
                        child: _fotoSelecionada == null &&
                                (_fotoUrl == null || _fotoUrl!.isEmpty)
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
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
                controller: sobrenomeController,
                decoration: const InputDecoration(
                  labelText: 'Sobrenome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o sobrenome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o email';
                  }
                  if (!_isValidEmail(value.trim())) {
                    return 'Digite um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: idadeController,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite a idade';
                  }
                  final idade = int.tryParse(value.trim());
                  if (idade == null || idade < 0 || idade > 150) {
                    return 'Digite uma idade válida';
                  }
                  return null;
                },
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
