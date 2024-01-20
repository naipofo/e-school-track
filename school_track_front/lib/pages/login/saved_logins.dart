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

saveLogin(String name, String jwt) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var logins = await getSavedLogins();
  logins[name] = jwt;
  prefs.setStringList(
    savedLoginsKey,
    logins.entries.map((k) => "${k.key}:${k.value}").toList(),
  );
}
