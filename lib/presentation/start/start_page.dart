import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/presentation/mail_login/mail_login_page.dart';
import 'package:whiskit_app/presentation/mail_signup/mail_signup_page.dart';
import 'package:whiskit_app/presentation/start/start_model.dart';

import '../main/main.dart';

// https://whiskit-7699f.firebaseapp.com/__/auth/handler
// twitterkit-n6u2grmRwhTm7roImQtZmb3J6://
// twittersdk://

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      home: ChangeNotifierProvider<StartModel>(
        create: (_) => StartModel(),
        child: Scaffold(
          body: Consumer<StartModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 240,
                      child: RaisedButton(
                        child: Text(
                          "Twitterではじめる",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        color: Color(0xFF1DA1F2),
                        textColor: Colors.white,
                        onPressed: () async {
                          await model.signInWithTwitter();
                          await Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => MyApp()));
                        },
                      ),
                    ),
                    SizedBox(
                      width: 240,
                      child: RaisedButton(
                        child: Text(
                          "メールアドレスではじめる",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        color: Colors.amber,
                        textColor: Colors.black,
                        onPressed: () async {
                          /* mail登録画面に遷移 */
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MailSignupPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: 240,
                      child: RaisedButton(
                        child: Text(
                          "ログイン",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        color: Colors.grey,
                        textColor: Colors.black,
                        onPressed: () async {
                          /* mail_login画面に遷移 */
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MailLoginPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'ウイスキットを始める前に利用規約とプライバシーポリシーをご確認ください',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
