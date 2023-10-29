import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/graphql/generated/messages.data.gql.dart';
import 'package:school_track_front/graphql/generated/messages.req.gql.dart';
import 'package:school_track_front/graphql/generated/schema.schema.gql.dart';
import 'package:school_track_front/util/collections.dart';

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
        builder: (context, data) => SendMessageForm(
          title: title ?? "",
          recepient: recepient ?? 0,
          data: data,
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
  Set<int> recepientUsers = {};
  Set<int> recepientGroups = {};

  get noRecepients => (recepientGroups.length + recepientUsers.length) == 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => showDialog<RecepientsDialogResult>(
              context: context,
              builder: (context) => RecepientsDialog(
                data: widget.data,
                initialRecepientUsers: recepientUsers.toList(),
                initialRecepientGroups: recepientGroups.toList(),
              ),
            ).then(
              (value) => setState(
                () {
                  if (value == null) return;
                  final (:users, :groups) = value;
                  for (var e in groups.entries) {
                    var gUsers = widget.data.groups
                        .firstWhere((g) => g.id == e.key)
                        .user_groups
                        .map((p0) => p0.user.id);
                    for (var u in gUsers) {
                      users.remove(u);
                    }
                  }
                  recepientGroups.editWithMap(groups);
                  recepientUsers.editWithMap(users);
                },
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  if (noRecepients)
                    const Text("Recepients")
                  else
                    ...recepientGroups.map(
                      (gId) => Chip(
                        label: Text(
                          widget.data.groups
                              .firstWhere((g) => g.id == gId)
                              .name,
                        ),
                      ),
                    ),
                  ...recepientUsers.map(
                    (uId) => Chip(
                      label: Text(
                        widget.data.users
                            .firstWhere((u) => u.id == uId)
                            .full_name!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: widget.title,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Title'),
              ),
              onChanged: (value) => title = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: contentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Content'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: FilledButton(
              onPressed: () {
                context.go("/messages");
                var clientModel = context.read<ClientModel>();
                clientModel.client
                    .request(GSendMessageReq(
                      (g) => g.vars
                        ..title = title ?? widget.title
                        ..content = contentController.text
                        ..sender_id = clientModel.userId
                        ..recipient_groups = ListBuilder(recepientGroups.map(
                            (e) => Grecipient_group_insert_input(
                                (g) => g..group_id = e)))
                        ..recipient_users = ListBuilder(recepientUsers.map(
                            (e) => Grecipient_user_insert_input(
                                (g) => g..user_id = e))),
                    ))
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

typedef RecepientsDialogResult = ({
  Map<int, bool> users,
  Map<int, bool> groups
});

class RecepientsDialog extends StatefulWidget {
  const RecepientsDialog({
    super.key,
    required this.data,
    required this.initialRecepientUsers,
    required this.initialRecepientGroups,
  });

  final List<int> initialRecepientUsers;
  final List<int> initialRecepientGroups;

  final GGetPossibleRecipientsData data;

  @override
  State<RecepientsDialog> createState() => RecepientsDialogState();
}

class RecepientsDialogState extends State<RecepientsDialog> {
  Set<int> expanded = {};

  Map<int, bool> recepientUsers = {};
  Map<int, bool> recepientGroups = {};

  bool? groupSelected(int id) {
    var users = widget.data.groups
        .firstWhere((g) => g.id == id)
        .user_groups
        .map((p0) => p0.user.id);
    return recepientGroups[id] == true
        ? true
        : users.any((u) => userSelectedOrgin(u))
            ? null
            : false;
  }

  bool userSelectedOrgin(int id) => recepientUsers.containsKey(id)
      ? recepientUsers[id]!
      : widget.initialRecepientUsers.contains(id);

  bool userSelectedDisplay(int id) =>
      userSelectedOrgin(id) ||
      recepientGroups.entries
          .where((element) => element.value == true)
          .map((e) => e.key)
          .followedBy(widget.initialRecepientGroups)
          .any((gId) => groupSelected(gId) ?? false);

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Recepients'),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop<RecepientsDialogResult>(
                  (users: recepientUsers, groups: recepientGroups),
                ),
                child: const Text("Save"),
              )
            ],
          ),
          body: ListView(
            children: [
              ...widget.data.groups.map(
                (g) {
                  var isExpanded = expanded.contains(g.id);
                  return Column(
                    children: [
                      ListTile(
                        title: Text(g.name),
                        leading: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                        ),
                        trailing: Checkbox(
                          value: groupSelected(g.id),
                          tristate: true,
                          onChanged: (v) => setState(() {
                            if (v != null) {
                              recepientGroups[g.id] = v;
                            } else {
                              recepientGroups.remove(g.id);
                            }
                          }),
                        ),
                        onTap: () => toggleExpand(g.id),
                      ),
                      if (isExpanded)
                        ...g.user_groups
                            .map<Widget>(
                          (u) => CheckboxListTile(
                            title: Row(
                              children: [
                                const SizedBox(width: 32.0),
                                Text(u.user.full_name ?? ""),
                              ],
                            ),
                            value: userSelectedDisplay(u.user.id),
                            onChanged: (v) => setState(() {
                              recepientUsers[u.user.id] = v!;
                            }),
                          ),
                        )
                            .followedBy([const Divider(height: 0)]),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void toggleExpand(int gId) => setState(() => expanded.toggle(gId));
}
