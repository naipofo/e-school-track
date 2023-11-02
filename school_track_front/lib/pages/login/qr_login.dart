import 'dart:async';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/openapi/generated/schema.swagger.dart';
import 'package:uuid/uuid.dart';

class QrLoginScreen extends StatefulWidget {
  const QrLoginScreen({super.key});

  @override
  State<QrLoginScreen> createState() => _QrLoginScreenState();
}

class _QrLoginScreenState extends State<QrLoginScreen> {
  late String loginUuid;
  late String loginHash;

  Timer? timer;

  @override
  void initState() {
    loginUuid = const Uuid().v4();
    loginHash = BCrypt.hashpw(loginUuid, BCrypt.gensalt());

    timer = Timer.periodic(const Duration(seconds: 2), (_) => tryLogin());

    super.initState();
  }

  void tryLogin() => context
      .read<Schema>()
      .qrPost(body: TryQr(hash: loginHash, uuid: loginUuid))
      .then((res) => context.read<ClientModel>().loginJwt(res.body ?? ""));

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Login"),
        actions: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.password),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 255, maxWidth: 255),
            child: QrImageView(
              data: loginHash,
            ),
          ),
        ),
      ),
    );
  }
}
