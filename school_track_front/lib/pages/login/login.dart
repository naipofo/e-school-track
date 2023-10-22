import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';

import '../../conf.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String currentJwt = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownMenu(
                dropdownMenuEntries: testJwts
                    .map<DropdownMenuEntry>(
                      (e) => DropdownMenuEntry<String>(
                        value: e.$2,
                        label: e.$1,
                      ),
                    )
                    .toList(),
                onSelected: (value) => currentJwt = value,
              ),
              FilledButton(
                onPressed: () {
                  if (currentJwt.isEmpty) return;
                  context.read<ClientModel>().login(currentJwt);
                  context.go("/dashboard");
                },
                child: const Text('login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
