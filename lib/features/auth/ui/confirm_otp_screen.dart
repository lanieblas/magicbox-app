import 'package:flutter/material.dart';
import 'package:magicbox_app/shared/widgets/app_button.dart';
import 'package:magicbox_app/shared/widgets/app_text_field.dart';

class ConfirmOtpScreen extends StatefulWidget {
  const ConfirmOtpScreen({super.key});

  @override
  State<ConfirmOtpScreen> createState() => _ConfirmOtpScreenState();
}

class _ConfirmOtpScreenState extends State<ConfirmOtpScreen> {
  final _otpController = TextEditingController();
  bool _loading = false;

  void _handleConfirm() {
    setState(() => _loading = true);
    // Aquí deberías validar el OTP con el backend
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _loading = false);
        // Si es válido, ir a login
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(label: 'Código OTP', controller: _otpController),
        const SizedBox(height: 20),
        AppButton(
          label: _loading ? '...' : 'Validar',
          onPressed: _loading ? () {} : _handleConfirm,
        ),
      ],
    );
  }
}
