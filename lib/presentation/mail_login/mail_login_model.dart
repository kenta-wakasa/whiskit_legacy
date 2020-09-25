import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MailLoginModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future login() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }

    // ToDo: パスワードのバリデーションを書く
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ('このメールアドレスは登録されていません');
      } else if (e.code == 'wrong-password') {
        throw ('パスワードが異なっています');
      }
    }
    //Firebaseのuser id取得
    User user = FirebaseAuth.instance.currentUser;
    // 端末にuidを保存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);
  }
}
