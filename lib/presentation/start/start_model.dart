import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartModel extends ChangeNotifier {
  // APIキーを入力
  final TwitterLogin _twitterLogin = TwitterLogin(
    consumerKey: 'n6u2grmRwhTm7roImQtZmb3J6',
    consumerSecret: 'O31b9haHuCTkp1eEqUPGj2ZulUHTX15kJynGAD6FWCQCtYKhvi',
  );

  // firebase初期化
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithTwitter() async {
    // twitter認証の許可画面が出現
    final TwitterLoginResult result = await _twitterLogin.authorize();

    //Firebaseのユーザー情報にアクセス & 情報の登録 & 取得
    // Create a credential from the access token
    final AuthCredential credential = TwitterAuthProvider.credential(
      accessToken: result.session.token,
      secret: result.session.secret,
    );

    //Firebaseのuser id取得
    final User user = (await _auth.signInWithCredential(credential)).user;

    // user情報を保存
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(user.uid)
        .set({
          'userName': user.displayName, // John Doe
          'avatarPhotoURL': user.photoURL, // Stokes and Sons
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    // 端末にuidを保存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);

    notifyListeners();
  }
}
