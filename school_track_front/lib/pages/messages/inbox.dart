import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        operationRequest: GGetMessagesReq((g) => g.vars..recipient_id = 1),
        builder: (context, data) => ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: data.messages.map(
              (m) => ListTile(
                title: Text(
                  m.title,
                  style: TextStyle(
                    fontWeight:
                        m.read_receipt ? FontWeight.normal : FontWeight.bold,
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
