import 'package:shared_preferences/shared_preferences.dart';

class AppShared {
  static SharedPreferences? localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
    AppShared.localStorage!.getInt('notes') == null
        ? AppShared.localStorage!.setInt('notes', 0)
        : null;
  }
}
