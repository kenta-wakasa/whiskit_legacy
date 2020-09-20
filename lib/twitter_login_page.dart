import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TwitterLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'auth sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthPage(
        title: 'Auth Sample with Firebase',
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  AuthPage({
    Key key,
    this.title,
  }) : super(
          key: key,
        );

  final String title;

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // APIキーを入力
  final TwitterLogin twitterLogin = TwitterLogin(
    consumerKey: 'n6u2grmRwhTm7roImQtZmb3J6',
    consumerSecret: 'O31b9haHuCTkp1eEqUPGj2ZulUHTX15kJynGAD6FWCQCtYKhvi',
  );

  bool logined = false;
  String uid = '';

  void login() {
    setState(() {
      logined = true;
    });
  }

  void logout() {
    setState(() {
      logined = false;
    });
  }

  Future signInWithTwitter() async {
    // twitter認証の許可画面が出現
    final TwitterLoginResult result = await twitterLogin.authorize();

    //Firebaseのユーザー情報にアクセス & 情報の登録 & 取得
    // Create a credential from the access token

    final AuthCredential credential = TwitterAuthProvider.credential(
      accessToken: result.session.token,
      secret: result.session.secret,
    );

    //Firebaseのuser id取得
    final User user = (await _auth.signInWithCredential(credential)).user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    SharedPreferences prefsRead = await SharedPreferences.getInstance();
    uid = prefsRead.getString('uid');

    // user情報を保存
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(user.uid)
        .set({
          'userName': currentUser.displayName, // John Doe
          'avatarPhotoURL': currentUser.photoURL, // Stokes and Sons
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    // 端末にuidを保存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);
    login();

    // ページ遷移
    // await Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  void signOutTwitter() async {
    await twitterLogin.logOut();
    // 端末からuidを削除
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', '');
    logout();
    print("User Sign Out Twittter");
  }

  void readUid() async {
    SharedPreferences prefsRead = await SharedPreferences.getInstance();
    uid = prefsRead.getString('uid');
    print(uid);
  }

  @override
  Widget build(BuildContext context) {
    Widget logoutText = Text("ログアウト中");
    Widget loginText = Text("ログイン中");

    Widget loginBtnTwitter = RaisedButton(
      child: Text("Sign in with Twitter"),
      color: Color(0xFF1DA1F2),
      textColor: Colors.white,
      onPressed: signInWithTwitter,
    );
    Widget logoutBtnTwitter = RaisedButton(
      child: Text("Sign out with Twitter"),
      color: Color(0xFF1DA1F2),
      textColor: Colors.white,
      onPressed: signOutTwitter,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logined ? loginText : logoutText,
            logined ? logoutBtnTwitter : loginBtnTwitter,
            RaisedButton(onPressed: readUid),
            Text(uid ?? 'default value'),
          ],
        ),
      ),
    );
  }
}
