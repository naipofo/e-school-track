import 'package:shared_preferences/shared_preferences.dart';

const savedLoginsKey = "savedlg";

Future<Map<String, String>> getSavedLogins() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final l = (prefs.getStringList(savedLoginsKey) ?? []).map((e) {
    final g = e.split(":");
    return {g[0]: g[1]};
  });
  return {for (var e in l) ...e};
}

_modifyLogins(Function(Map<String, String>) transformer) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var l = await getSavedLogins();
  transformer(l);
  prefs.setStringList(
    savedLoginsKey,
    l.entries.map((k) => "${k.key}:${k.value}").toList(),
  );
}

saveLogin(String name, String jwt) async => _modifyLogins((l) => l[name] = jwt);
removeLogin(String name) async => _modifyLogins((l) => l.remove(name));
