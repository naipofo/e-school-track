import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var noSpecialFormat =
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9.]"));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: loginController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Username'),
                  ),
                  inputFormatters: [noSpecialFormat],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Password'),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () {
                    context
                        .read<ClientModel>()
                        .login(loginController.text, passwordController.text)
                        .then(
                      (_) {
                        if (context.read<ClientModel>().type !=
                            AccountType.guest) {
                          context.go("/dashboard");
                        }
                      },
                    );
                  },
                  child: const Text('login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
