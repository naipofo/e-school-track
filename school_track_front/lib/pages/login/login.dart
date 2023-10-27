import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/api.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/pages/login/thin_from.dart';

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

    var noSpecialFormat =
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9.]"));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code))
        ],
      ),
      body: ThinForm(
        errorMessage: errorMessage,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: () async {
                  try {
                    await clientModel
                        .login(
                      context,
                      loginController.text,
                      passwordController.text,
                    )
                        .whenComplete(
                      () {
                        if (clientModel.type != AccountType.guest) {
                          context.go("/dashboard");
                        }
                      },
                    );
                  } on ApiException catch (e) {
                    setState(() {
                      if (e.code == 403) {
                        context
                            .go("/login/temporary?login=${loginController.text}"
                                "&password=${passwordController.text}");
                        passwordController.clear();
                      } else {
                        errorMessage = switch (e.code) {
                          401 => "Wrong password",
                          404 => "Account not found",
                          _ => "Error: ${e.message}"
                        };
                      }
                    });
                  }
                },
                child: const Text('login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
