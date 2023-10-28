import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/accounts.req.gql.dart';
import 'package:school_track_front/util/auth.dart';
import 'package:school_track_front/util/dialogs.dart';

class AddAuthDialog extends StatefulWidget {
  const AddAuthDialog({
    super.key,
    required this.userId,
  });

  final int userId;

  @override
  State<AddAuthDialog> createState() => _AddAuthDialogState();
}

class _AddAuthDialogState extends State<AddAuthDialog> {
  final usernameController = TextEditingController();
  final pass = generateTempPassword();

  @override
  Widget build(BuildContext context) {
    return ConfirmDialog(
      title: 'Add login',
      message: TextField(
        controller: usernameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text('Username'),
        ),
        inputFormatters: [noSpecialFormat],
      ),
      onConfirm: () {
        context
            .read<ClientModel>()
            .client
            .request(
              GAddAuthReq(
                (g) => g.vars
                  ..user_id = widget.userId
                  ..nickname = usernameController.text
                  ..hash = pass,
              ),
            )
            .listen((event) {});
        showDialog(
          context: context,
          builder: (context) => TempPasswordDialog(pass: pass),
        );
      },
    );
  }
}

class TempPasswordDialog extends StatelessWidget {
  const TempPasswordDialog({
    super.key,
    required this.pass,
  });

  final String pass;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Temporary password"),
      content: SelectableText(pass),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
