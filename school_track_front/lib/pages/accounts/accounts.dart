import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/accounts.data.gql.dart';
import 'package:school_track_front/graphql/generated/accounts.req.gql.dart';
import 'package:school_track_front/graphql/generated/schema.schema.gql.dart';
import 'package:school_track_front/pages/accounts/add_account.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  Set<int> selected = {};
  bool isSelecting = false;

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GGetAccountsReq(),
      builder: (context, data) => Scaffold(
        appBar: AppBar(
          title: const Text('Accounts'),
          actions: isSelecting
              ? [
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => GroupManagmentDialog(
                        ids: selected.toList(),
                        data: data,
                      ),
                    ),
                    icon: const Icon(Icons.group_add),
                  ),
                  IconButton(
                    onPressed: () {
                      var names = selected
                          .toList()
                          .map(
                            (e) => data.users
                                .firstWhere((u) => u.id == e)
                                .full_name!,
                          )
                          .join(", ");
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: 'Delete user',
                          message: Text(
                              'Are you sure you want to delete users "$names"?'),
                          onConfirm: () => context
                              .read<ClientModel>()
                              .client
                              .request(
                                GDeleteUsersReq(
                                  (g) => g.vars
                                    ..ids = ListBuilder(selected.toList()),
                                ),
                              )
                              .listen((event) {}),
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete),
                  )
                ]
              : null,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const AddAccountDialog(),
          ),
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: DataTable(
              columns: [
                const DataColumn(label: Text('id'), numeric: true),
                const DataColumn(label: Text('first')),
                const DataColumn(label: Text('last')),
                const DataColumn(label: Text('has auth')),
                const DataColumn(label: Text('groups')),
                if (!isSelecting) const DataColumn(label: Text('')),
              ],
              rows: data.users
                  .map(
                    (u) => DataRow(
                      cells: [
                        DataCell(Text(u.id.toString())),
                        DataCell(Text(u.first_name)),
                        DataCell(Text(u.last_name)),
                        DataCell(Text(
                          u.auth == null
                              ? "none"
                              : u.auth!.temporary
                                  ? "temp"
                                  : "set",
                        )),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 140),
                            child: Text(
                              u.user_groups.map((g) => g.group.name).join(", "),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => GroupManagmentDialog(
                              data: data,
                              ids: [u.id],
                              name: u.full_name,
                            ),
                          ),
                        ),
                        if (!isSelecting)
                          DataCell(Row(children: [
                            IconButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    ConfirmDialog(
                                  title: 'Delete user',
                                  message: Text(
                                      'Are you sure you want to delete user "${u.full_name!}"?'),
                                  onConfirm: () => context
                                      .read<ClientModel>()
                                      .client
                                      .request(
                                        GDeleteUsersReq(
                                          (g) =>
                                              g.vars..ids = ListBuilder([u.id]),
                                        ),
                                      )
                                      .listen((event) {}),
                                ),
                              ),
                              icon: const Icon(Icons.delete_outline),
                            ),
                            IconButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => SimpleDialog(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Text(u.auth == null
                                          ? "This account does not have a login."
                                          : u.auth!.temporary
                                              ? "This account has a temporary password set."
                                              : "This account has a password."),
                                    ),
                                    if (u.auth == null)
                                      SimpleDialogOption(
                                        child: const Text("Create login"),
                                        onPressed: () {},
                                      )
                                    else ...[
                                      SimpleDialogOption(
                                        child: const Text("Reset password"),
                                        onPressed: () {},
                                      ),
                                      SimpleDialogOption(
                                        child: const Text("Remove login"),
                                        onPressed: () {
                                          context.pop();
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const Text('awe'));
                                        },
                                      )
                                    ]
                                  ],
                                ),
                              ),
                              icon: const Icon(Icons.lock_reset),
                            ),
                          ])),
                      ],
                      onLongPress: !isSelecting
                          ? () => setState(() {
                                isSelecting = true;
                                selected.add(u.id);
                              })
                          : null,
                      selected: selected.contains(u.id),
                      onSelectChanged: isSelecting
                          ? (v) => setState(() {
                                if (!v!) {
                                  selected.remove(u.id);
                                  if (selected.isEmpty) isSelecting = false;
                                } else {
                                  selected.add(u.id);
                                }
                              })
                          : null,
                    ),
                  )
                  .toList(),
              showCheckboxColumn: isSelecting,
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  final String title;
  final Widget message;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: message,
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            onConfirm();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class GroupManagmentDialog extends StatefulWidget {
  const GroupManagmentDialog({
    super.key,
    required this.data,
    required this.ids,
    this.name,
  });

  final List<int> ids;
  final GGetAccountsData data;
  final String? name;

  get multiple => ids.length > 1;

  @override
  State<GroupManagmentDialog> createState() => _GroupManagmentDialogState();
}

class _GroupManagmentDialogState extends State<GroupManagmentDialog> {
  Map<int, bool> modifications = {};

  @override
  Widget build(BuildContext context) {
    return GqlFetch(
      operationRequest: GListGroupsReq(),
      builder: (context, groups) => ConfirmDialog(
        title:
            "Groups ${widget.name != null ? "for ${widget.name}" : "${widget.ids.length} accounts"}",
        message: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          child: SingleChildScrollView(
            child: Column(
              children: groups.groups.map(
                (g) {
                  final amountHaving = widget.data.users
                      .where((u) => widget.ids.contains(u.id))
                      .map((e) =>
                          e.user_groups.map((g) => g.group.id).contains(g.id)
                              ? 1
                              : 0)
                      .reduce((a, b) => a + b);
                  return CheckboxListTile(
                    title: Text(g.name),
                    value: modifications.containsKey(g.id)
                        ? modifications[g.id]
                        : amountHaving == widget.ids.length
                            ? true
                            : amountHaving > 0
                                ? null
                                : false,
                    tristate: !(amountHaving == widget.ids.length ||
                            amountHaving == 0) &&
                        widget.multiple,
                    onChanged: (v) => setState(
                      () {
                        if (modifications.containsKey(g.id)) {
                          if (amountHaving > 0 && widget.multiple) {
                            if (modifications[g.id]!) {
                              modifications.remove(g.id);
                            } else {
                              modifications[g.id] = true;
                            }
                          } else {
                            modifications.remove(g.id);
                          }
                        } else {
                          modifications[g.id] = v!;
                        }
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        onConfirm: () {
          List<Guser_group_insert_input> addObjects = [];

          for (var uId in widget.ids) {
            for (var gId in modifications.entries
                .where((e) => e.value)
                .map((e) => e.key)) {
              addObjects.add(Guser_group_insert_input((g) => g
                ..group_id = gId
                ..user_id = uId));
            }
          }

          context
              .read<ClientModel>()
              .client
              .request(
                GModifyGroupsReq(
                  (g) => g.vars
                    ..users = ListBuilder(widget.ids)
                    ..delete_groups = ListBuilder(
                      modifications.entries
                          .where((e) => !e.value)
                          .map((e) => e.key)
                          .toList(),
                    )
                    ..insert_objects = ListBuilder(addObjects),
                ),
              )
              .listen((event) {});
        },
      ),
    );
  }
}
