import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/auth_state.dart';
import 'product_page.dart';
import '../viewmodels/product_viewmodel.dart';

class LoginPage extends StatefulWidget {
  final AuthViewModel authViewModel;
  final ProductViewModel productViewModel;

  const LoginPage({
    super.key,
    required this.authViewModel,
    required this.productViewModel,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await widget.authViewModel.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProductPage(viewModel: widget.productViewModel),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login DummyJSON")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Bem-vindo",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // CORRIGIDO: de 'Center' para 'TextAlign.center'
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuário',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira o seu usuário';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira a sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ValueListenableBuilder<AuthState>(
                valueListenable: widget.authViewModel.state,
                builder: (context, state, _) {
                  if (state.error != null) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center, // CORRIGIDO: de 'Center' para 'TextAlign.center'
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              ValueListenableBuilder<AuthState>(
                valueListenable: widget.authViewModel.state,
                builder: (context, state, _) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Entrar', style: TextStyle(fontSize: 16)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
