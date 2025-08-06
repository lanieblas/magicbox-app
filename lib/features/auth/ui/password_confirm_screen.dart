import 'package:flutter/material.dart';
import 'package:magicbox_app/shared/widgets/app_button.dart';
import 'package:magicbox_app/shared/widgets/app_text_field.dart';

class PasswordConfirmScreen extends StatefulWidget {
  const PasswordConfirmScreen({super.key});

  @override
  State<PasswordConfirmScreen> createState() => _PasswordConfirmScreenState();
}

class _PasswordConfirmScreenState extends State<PasswordConfirmScreen> {
  final _emailController = TextEditingController();
  bool _loading = false;

  void _handleRecover() {
    setState(() => _loading = true);
    // Aquí deberías llamar al API real
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _loading = false);
        // Navegar o mostrar mensaje
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(label: 'Email', controller: _emailController),
        const SizedBox(height: 20),
        AppButton(
          label: _loading ? '...' : 'Enviar',
          onPressed: _loading ? () {} : _handleRecover,
        ),
      ],
    );
  }
}
