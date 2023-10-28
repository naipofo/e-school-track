import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/accounts.req.gql.dart';

class AddAccountDialog extends StatefulWidget {
  const AddAccountDialog({
    super.key,
  });

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final firstController = TextEditingController();
  final lastController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        SimpleDialogOption(
          onPressed: () {
            context.pop();
            showDialog(
              context: context,
              builder: (context) => Dialog.fullscreen(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('Add account'),
                      centerTitle: false,
                      leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 8),
                        TextField(
                          controller: firstController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('First name'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: lastController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Last name'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed: () {
                            context.pop();
                            var clientModel = context.read<ClientModel>();
                            clientModel.client
                                .request(
                                  GAddUserReq(
                                    (g) => g.vars
                                      ..first_name = firstController.text
                                      ..last_name = lastController.text,
                                  ),
                                )
                                .listen((event) {});
                          },
                          child: const Text("Add"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: const Text("Add account"),
        ),
        SimpleDialogOption(
          onPressed: () {},
          child: const Text("Import from CSV"),
        )
      ],
    );
  }
}
