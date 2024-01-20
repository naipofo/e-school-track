import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/pages/login/saved_logins.dart';
import 'package:school_track_front/pages/login/thin_from.dart';
import 'package:school_track_front/util/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberPassword = false;

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final clientModel = context.watch<ClientModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
        actions: [
          IconButton(
            onPressed: () => context.go("/login/qr"),
            icon: const Icon(Icons.qr_code),
          ),
          IconButton(
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: "E School track",
              applicationVersion: "dev",
              applicationIcon: const Text(
                "📏",
                style: TextStyle(fontSize: 26.0),
              ),
            ),
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: ThinForm(
        errorMessage: errorMessage,
        children: [
          TextField(
            controller: loginController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(AppLocalizations.of(context)!.username),
            ),
            inputFormatters: [noSpecialFormat],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(AppLocalizations.of(context)!.password),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(child: Text("Remember account")),
              Checkbox(
                value: rememberPassword,
                onChanged: (b) => setState(() {
                  rememberPassword = b ?? false;
                }),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: () async {
                  final res = await clientModel
                      .login(
                    context,
                    loginController.text,
                    passwordController.text,
                  )
                      .whenComplete(
                    () async {
                      if (clientModel.type != AccountType.guest) {
                        context.go("/dashboard");
                        if (rememberPassword &&
                            clientModel.currentJwt != null) {
                          saveLogin(
                            loginController.text,
                            clientModel.currentJwt!,
                          );
                        }
                      }
                    },
                  );
                  setState(() {
                    if (res == 403) {
                      context
                          .go("/login/temporary?login=${loginController.text}"
                              "&password=${passwordController.text}");
                      passwordController.clear();
                    } else if (res != null && res >= 400) {
                      errorMessage = switch (res) {
                        401 => AppLocalizations.of(context)!.wrongPassword,
                        404 => AppLocalizations.of(context)!.noAccount,
                        _ => "Error: $res"
                      };
                    }
                  });
                },
                child: Text(AppLocalizations.of(context)!.loginAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
