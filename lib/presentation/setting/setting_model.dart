import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingModel extends ChangeNotifier {
  Future signOut() async {
    // サイアウト
    await FirebaseAuth.instance.signOut();
    // 端末からuidを削除
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', '');
  }
}
