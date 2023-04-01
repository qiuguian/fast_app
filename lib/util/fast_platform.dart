import 'package:fast_app/util/web_platform.dart'
//if(dart.library.html) "package:fast_app/util/web_platform.dart"
if(dart.library.io) "package:fast_app/util/vm_plaform.dart";

class FastPlatform {
  static String  get platformStr => getPlatform();
  static bool get isWeb => getPlatform() == "web";
  static bool get isIOS => getPlatform() == "iOS";
  static bool get isAndroid => getPlatform() == "android";
}