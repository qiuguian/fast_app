import 'package:shared_preferences/shared_preferences.dart';

storeKV(k,v) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(k, v);
}

Future<String> getStoreByKey(String k) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get(k);
}