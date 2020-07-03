import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:fast_app/cache/fast_cache.dart';
import 'package:fast_app/fast_app.dart';
import 'package:fast_app/notice/fast_notification.dart';

class FastActions {
  static String userId() => 'userId';

  static String userIcon() => 'userIcon';

  static String token() => 'loginToken';

  static String loginAccount() => 'loginAccount';

  static String isLogin() => 'isLogin';

  static String userName() => 'userName';

  static String password() => 'password';

  static String nickName() => 'nickName';

  static String toTab(int index) => 'toTab$index';

  static String toTabBar() => 'toTabBar';

  static String loginInfo() => 'loginInfo';

  static String isShowStartup() => 'isShowStartup';

  static String globeLanguage() => 'globeLanguage';

  static String currentTheme() => 'currentTheme';

  static String languageChangeRefresh() => 'languageChangeRefresh';

  static String gesturePassword() => 'gesturePassword';

  static String role() => 'role';

  static String shopId() => 'shopId';

  static String imageHost() => 'imageHost';

  static String timer() => 'fastTimer';

  static String isGuest() => 'isGuest';
}

Map userStoreData = new Map();

class FastData {
  static initData() async {
    String login = await getStoreValue(FastActions.isLogin());
    FastCache(FastActions.isLogin()).value = login == '1';

    getStoreValue(FastActions.loginInfo()).then((onValue) {
      if (onValue != null) {
        Map data = jsonDecode(onValue);
        userStoreData = data;
        FastCache(FastActions.isLogin()).value = true;
        FastCache(FastActions.token()).value = data['token'];
        FastCache(FastActions.userId()).value = data["userInfo"]['userId'];
        FastCache(FastActions.loginAccount()).value = data["userInfo"]["phone"];
        FastCache(FastActions.userName()).value = data["userInfo"]["username"];
      }
    });
  }

  static int get userId => FastCache(FastActions.userId()).value ?? 0;

  static setUserId(userId) =>
      FastCache(FastActions.userId()).value = userId;

  static int get shopId => FastCache(FastActions.shopId()).value ?? 0;

  static setShopId(shopId) =>
      FastCache(FastActions.shopId()).value = shopId;

  static bool get isLogin => FastCache(FastActions.isLogin()).value ?? false;

  static setIsLogin([isLogin = true]) {
    FastCache(FastActions.isLogin()).value = isLogin;
    FastNotification.push(FastActions.isLogin(), isLogin);
    if (isLogin) {
      storeString(FastActions.isLogin(), '1');
      popToRootPage();
    } else {
      storeString(FastActions.isLogin(), '0');
      popToRootPage();
      FastNotification.push(FastActions.toTabBar(), 0);
    }
    if (!isLogin) {
      FastApp.reCoverEnvironment();
    }
  }

  static loginOut([isLogin = false]) {
    FastCache(FastActions.isLogin()).value = isLogin;
    FastNotification.push(FastActions.isLogin(), isLogin);
    if (isLogin) {
      storeString(FastActions.isLogin(), '1');
    } else {
      storeString(FastActions.isLogin(), '0');
      popToRootPage();
      FastNotification.push(FastActions.toTabBar(), 0);
    }
    if (!isLogin) {
      FastApp.reCoverEnvironment();
    }
  }

  static String get token => FastCache(FastActions.token()).value ?? '';

  static void setToken(token) {
    FastCache(FastActions.token()).value = token;
    userStoreData['token'] = token;
    storeString(FastActions.loginInfo(), jsonEncode(userStoreData));
  }

  static String get username => FastCache(FastActions.userName()).value ?? '';

  static void setUsername(username) =>
      FastCache(FastActions.userName()).value = username;

  static String get password => FastCache(FastActions.password()).value ?? '';

  static int get role => FastCache(FastActions.role()).value;

  static String get imageHost => FastCache(FastActions.imageHost()).value ?? '';

  static void setImageHost(imageHost) {
    FastCache(FastActions.imageHost()).value = imageHost;
  }

  static String image(String imageUrl) {
    if (imageUrl == null || imageUrl == '') {
      return null;
    } else if (imageUrl.contains('http')) {
      return imageUrl;
    } else {
      return '${FastCache(FastActions.imageHost()).value}$imageUrl';
    }
  }

  static String get imageDemo =>
      "http://pic1.win4000.com/mobile/2020-02-28/5e5876a79a76e_200_300.jpg";

  static bool get isGuest => FastCache(FastActions.isGuest()).value ?? false;

  static void setIsGuest() {
    FastCache(FastActions.isGuest()).value = true;
  }
}
