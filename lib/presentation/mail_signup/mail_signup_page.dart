import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/presentation/main/main.dart';
import 'mail_signup_model.dart';

class MailSignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();
    return ChangeNotifierProvider<MailSignupModel>(
      create: (_) => MailSignupModel(),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Colors.black54,
            title: Text(
              'ユーザー登録',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Consumer<MailSignupModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        model?.imageFile == null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/whiskit-7699f.appspot.com/o/users%2FdefaultUserIcon.jpg?alt=media&token=c12e1323-ec81-4adf-972b-204932f8e330',
                                ),
                                maxRadius: 48,
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(
                                  model?.imageFile,
                                ),
                                maxRadius: 48,
                              ),
                        RawMaterialButton(
                          onPressed: () async {
                            await model.showImagePicker();
                          },
                          child: Container(
                            width: 96.0, // CircleAvatarのradiusの2倍
                            height: 96.0,
                          ),
                          shape: new CircleBorder(),
                          elevation: 0.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(hintText: 'ユーザーネーム'),
                        onChanged: (text) {
                          model.userName = text;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
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
                          '登録',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          try {
                            await model.Signup();
                            await _showDialog(context, '登録しました');
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyApp(),
                              ),
                            );
                          } catch (e) {
                            _showDialog(context, e.toString());
                          }
                        },
                      ),
                    ),
                  ],
                ),
                model.isUploading
                    ? Container(
                        color: Colors.grey.withOpacity(0.7),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Center(
                        child: SizedBox(),
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
