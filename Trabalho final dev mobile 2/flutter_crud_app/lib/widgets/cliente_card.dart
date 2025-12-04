import 'dart:io';
import 'package:flutter/material.dart';

class ClienteCard extends StatelessWidget {
  final String nome;
  final String sobrenome;
  final String email;
  final int idade;
  final String? fotoUrl;
  final File? fotoFile;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ClienteCard({
    super.key,
    required this.nome,
    required this.sobrenome,
    required this.email,
    required this.idade,
    this.fotoUrl,
    this.fotoFile,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Foto do cliente
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.transparent,
                  backgroundImage: fotoFile != null
                      ? FileImage(fotoFile!)
                      : (fotoUrl != null && fotoUrl!.isNotEmpty
                          ? NetworkImage(fotoUrl!) as ImageProvider
                          : null),
                  child: fotoFile == null &&
                          (fotoUrl == null || fotoUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 32, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              // Informações do cliente
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$nome $sobrenome',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 14, color: Color(0xFF6366F1)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.cake, size: 14, color: Color(0xFFEC4899)),
                        const SizedBox(width: 4),
                        Text(
                          '$idade anos',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Botão de deletar
              if (onDelete != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

