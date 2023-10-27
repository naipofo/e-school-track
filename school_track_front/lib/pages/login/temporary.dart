import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:openapi/api.dart';
import 'package:provider/provider.dart';
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
        title: const Text("Temporary password"),
      ),
      body: ThinForm(
        errorMessage: errorMessage,
        children: [
          Text(
            "Set your new password: ",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Password'),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: true,
            controller: confirmPasswordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Confirm password'),
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
                      errorMessage = "Passwords do not match";
                    });
                    return;
                  }
                  context
                      .read<DefaultApi>()
                      .loginControllerTemporary(
                        UpdateTemporary(
                          username: widget.login,
                          tempPassword: widget.tempPassword,
                          newPassword: passwordController.text,
                        ),
                      )
                      .then((_) => context.pop());
                },
                child: const Text('set password'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
