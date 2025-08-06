import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicbox_app/app/providers.dart';
import 'package:magicbox_app/core/exceptions/api_exception.dart';
import 'package:magicbox_app/features/auth/data/auth_api.dart';
import 'package:magicbox_app/features/auth/data/auth_models.dart';
import 'package:magicbox_app/shared/widgets/app_button.dart';
import 'package:magicbox_app/shared/widgets/app_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _handleLogin() async {
    setState(() => _loading = true);
    try {
      final dio = ref.read(dioClientProvider).dio;
      final api = AuthApi(dio);
      final response = await api.login(LoginRequest(
        email: _emailController.text,
        password: _passwordController.text,
      ));

      await ref.read(authNotifierProvider.notifier)
          .login(response.accessToken, response.refreshToken);

      if (!mounted) return;

    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login error: $e')),
      );
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(label: 'Email', controller: _emailController),
        const SizedBox(height: 16),
        AppTextField(label: 'Password', controller: _passwordController, obscureText: true),
        const SizedBox(height: 20),
        AppButton(
          label: _loading ? '...' : 'Login',
          onPressed: _loading ? () {} : _handleLogin,
        ),
      ],
    );
  }
}