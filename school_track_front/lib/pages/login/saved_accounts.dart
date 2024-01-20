import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/pages/login/saved_logins.dart';

class SavedAccountsScreen extends StatefulWidget {
  const SavedAccountsScreen({super.key});

  @override
  State<SavedAccountsScreen> createState() => _SavedAccountsScreenState();
}

class _SavedAccountsScreenState extends State<SavedAccountsScreen> {
  Future<Map<String, String>> accountData = getSavedLogins();
  List<String> justRemoved = [];

  @override
  Widget build(BuildContext context) {
    final clientModel = context.read<ClientModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved accounts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              children: [
                FutureBuilder(
                  future: accountData,
                  builder: (context, snapshot) => Column(
                    children: [
                      if (snapshot.data != null)
                        for (var user in snapshot.data!.entries.where(
                          (element) => !justRemoved.contains(element.key),
                        ))
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    user.key,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          removeLogin(user.key);
                                          setState(() {
                                            justRemoved.add(user.key);
                                          });
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          clientModel.loginJwt(user.value);
                                        },
                                        icon: const Icon(Icons.arrow_forward),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )),
                          )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                OutlinedButton(
                  onPressed: () {
                    context.push("/login");
                  },
                  child: const Text("other account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
