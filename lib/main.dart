import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/main_model.dart';
import 'package:whiskit_app/singup_page.dart';
import 'package:whiskit_app/whisky_list_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whiskit',
      home: ChangeNotifierProvider<MainModel>(
        create: (_) => MainModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'ウイスキット'
            ),
          ),
          body: Consumer<MainModel>( builder: (context, model, child) {
            return Center(
              child: Column(
                children: [
                  Text(
                    model.testText,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  RaisedButton(
                    child: Text('ウイスキ一覧'),
                    onPressed: () {
                      // 画面遷移
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WhiskyListPage() )
                      );
                    },
                  ),
                  RaisedButton(
                    child: Text('新規登録'),
                    onPressed: () {
                      // 画面遷移
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage() )
                      );
                    },
                  ),
                  RaisedButton(
                    child: Text('ログイン'),
                    onPressed: () {
                      // 画面遷移
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage() )
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
