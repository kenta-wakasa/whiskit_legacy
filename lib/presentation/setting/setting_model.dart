import 'package:flutter/cupertino.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingModel extends ChangeNotifier {
  // APIキーを入力
  final TwitterLogin _twitterLogin = TwitterLogin(
    consumerKey: 'n6u2grmRwhTm7roImQtZmb3J6',
    consumerSecret: 'O31b9haHuCTkp1eEqUPGj2ZulUHTX15kJynGAD6FWCQCtYKhvi',
  );

  Future signOutWithTwitter() async {
    await _twitterLogin.logOut();
    // 端末からuidを削除
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', '');
  }
}
