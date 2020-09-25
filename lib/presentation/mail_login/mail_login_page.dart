import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/presentation/mail_login/mail_login_model.dart';
import 'package:whiskit_app/presentation/main/main.dart';

class MailLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();
    return ChangeNotifierProvider<MailLoginModel>(
      create: (_) => MailLoginModel(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Colors.black54,
            title: Text(
              'ログイン',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Consumer<MailLoginModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'example@test.com'),
                  controller: mailController,
                  onChanged: (text) {
                    model.mail = text;
                  },
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'password'),
                  obscureText: true,
                  controller: passwordController,
                  onChanged: (text) {
                    model.password = text;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                    child: Text(
                      'ログイン',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      try {
                        await model.login();
                        await _showDialog(context, 'ログインしました');
                        await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      } catch (e) {
                        await _showDialog(context, e.toString());
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future _showDialog(
    BuildContext context,
    String title,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
