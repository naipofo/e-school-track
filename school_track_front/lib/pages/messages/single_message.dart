import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/messages.req.gql.dart';

class SingleMessageScreen extends StatelessWidget {
  const SingleMessageScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GReadMessageReq((g) => g.vars..id = id),
      builder: (context, data) {
        final message = data.message!;
        return Scaffold(
          appBar: AppBar(title: Text(message.title)),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                context.go("/messages/compose?recepient=${message.sender?.id}"
                    "&title=Re: ${message.title}"),
            child: const Icon(Icons.reply),
          ),
          body: Text("From ${message.sender?.full_name}\n\n"
              "${message.content}"),
        );
      },
    );
  }
}
