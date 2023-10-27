import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/api.dart';
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

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final clientModel = context.watch<ClientModel>();
    if (clientModel.type != AccountType.guest) {
      context.go("/dashboard");
    }

    var noSpecialFormat =
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9.]"));
    var theme = Theme.of(context);
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
                  onPressed: () async {
                    try {
                      await clientModel.login(
                        loginController.text,
                        passwordController.text,
                      );
                    } on ApiException catch (e) {
                      setState(() {
                        errorMessage = switch (e.code) {
                          401 => "Wrong password",
                          404 => "Account not found",
                          _ => "Error: ${e.message}"
                        };
                      });
                    }
                  },
                  child: const Text('login'),
                ),
                const SizedBox(height: 8),
                if (errorMessage != null)
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      color: theme.colorScheme.error,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Error: ${errorMessage!}",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.colorScheme.onError),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
