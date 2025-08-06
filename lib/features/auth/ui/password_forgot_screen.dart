import 'package:flutter/material.dart';
import 'package:magicbox_app/shared/widgets/app_button.dart';
import 'package:magicbox_app/shared/widgets/app_text_field.dart';

class PasswordForgotScreen extends StatefulWidget {
  const PasswordForgotScreen({super.key});

  @override
  State<PasswordForgotScreen> createState() => _PasswordForgotScreenScreenState();
}

class _PasswordForgotScreenScreenState extends State<PasswordForgotScreen> {
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
