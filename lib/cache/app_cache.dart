import 'package:shared_preferences/shared_preferences.dart';

storeKV(k, v) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(k, v);
}

Future<String> getStoreByKey(String k) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get(k);
}

class AppCache {
  static SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static save(k, v) {
    _prefs.setString(k, v);
  }

  static saveBool(k, v) {
    _prefs.setBool(k, v);
  }

  static dynamic get(k) {
    return _prefs.get(k);
  }
}
