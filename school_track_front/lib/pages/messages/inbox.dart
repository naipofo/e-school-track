import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/graphql/generated/messages.req.gql.dart';

import '../../gql_client.dart';

class MessageInboxScreen extends StatelessWidget {
  const MessageInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go("/messages/compose"),
        child: const Icon(Icons.create),
      ),
      body: GqlFetch(
        operationRequest: GGetMessagesReq(
          (g) => g.vars.user_id = context.read<ClientModel>().userId,
        ),
        builder: (context, data) => ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: data.messages.map(
              (m) => ListTile(
                title: Text(
                  m.title,
                  style: TextStyle(
                    fontWeight: m.inbox_entries.isEmpty ||
                            (m.inbox_entries.isNotEmpty &&
                                !m.inbox_entries.first.read_receipt)
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text("From: ${m.sender?.full_name}"),
                onTap: () => context.push("/messages/view/${m.id}"),
              ),
            ),
          ).toList(),
        ),
      ),
    );
  }
}
