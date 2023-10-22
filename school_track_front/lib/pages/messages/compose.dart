import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/graphql/generated/messages.data.gql.dart';
import 'package:school_track_front/graphql/generated/messages.req.gql.dart';

import '../../gql_client.dart';

class MessageComposeScreen extends StatelessWidget {
  const MessageComposeScreen({
    super.key,
    this.recepient,
    this.title,
  });

  final int? recepient;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Message')),
      body: GqlFetch(
        operationRequest: GGetPossibleRecipientsReq(),
        builder: (context, data) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SendMessageForm(
            title: title ?? "",
            recepient: recepient ?? 0,
            data: data,
          ),
        ),
      ),
    );
  }
}

class SendMessageForm extends StatefulWidget {
  const SendMessageForm(
      {super.key,
      required this.title,
      required this.recepient,
      required this.data});

  final String title;
  final int recepient;
  final GGetPossibleRecipientsData data;

  @override
  State<SendMessageForm> createState() => _SendMessageFormState();
}

class _SendMessageFormState extends State<SendMessageForm> {
  final _formKey = GlobalKey<FormState>();
  final contentController = TextEditingController();
  String? title;
  int recepient = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownMenu(
            dropdownMenuEntries: widget.data.users
                .map((u) =>
                    DropdownMenuEntry(value: u.id, label: u.full_name ?? ""))
                .toList(),
            label: const Text('Recepient'),
            initialSelection: widget.recepient,
            onSelected: (value) => recepient = value ?? 0,
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: widget.title,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Title'),
            ),
            onChanged: (value) => title = value,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: contentController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Content'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FilledButton(
              onPressed: () {
                context.go("/messages");
                context
                    .read<ClientModel>()
                    .client
                    .request(
                      GSendMessageReq(
                        (g) => g.vars
                          ..sender_id = 2
                          ..recipient_id = recepient
                          ..title = title ?? widget.title
                          ..content = contentController.text,
                      ),
                    )
                    .listen((event) {});
              },
              child: const Text('Send'),
            ),
          )
        ],
      ),
    );
  }
}
