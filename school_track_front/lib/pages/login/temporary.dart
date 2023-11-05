import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/openapi/generated/schema.swagger.dart';
import 'package:school_track_front/pages/login/thin_from.dart';

class TemporaryPasswordScreen extends StatefulWidget {
  const TemporaryPasswordScreen({
    super.key,
    required this.tempPassword,
    required this.login,
  });

  final String tempPassword;
  final String login;

  @override
  State<TemporaryPasswordScreen> createState() =>
      _TemporaryPasswordScreenState();
}

class _TemporaryPasswordScreenState extends State<TemporaryPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.temporaryPassword),
      ),
      body: ThinForm(
        errorMessage: errorMessage,
        children: [
          Text(
            "",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(AppLocalizations.of(context)!.password),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: true,
            controller: confirmPasswordController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(AppLocalizations.of(context)!.confirmPassword),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: () {
                  if (passwordController.text.isEmpty ||
                      passwordController.text !=
                          confirmPasswordController.text) {
                    setState(() {
                      errorMessage = AppLocalizations.of(context)!.passNoMatch;
                    });
                    return;
                  }
                  context
                      .read<Schema>()
                      .temporaryPost(
                        body: UpdateTemporary(
                          username: widget.login,
                          tempPassword: widget.tempPassword,
                          newPassword: passwordController.text,
                        ),
                      )
                      .then((_) => context.pop());
                },
                child: Text(AppLocalizations.of(context)!.setPassAction),
              ),
            ],
          )
        ],
      ),
    );
  }
}
