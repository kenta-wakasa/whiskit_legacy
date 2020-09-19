import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/presentation/setting/setting_model.dart';
import 'package:whiskit_app/presentation/start/start_page.dart';

class SettingPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingModel>(
      create: (_) => SettingModel(),
      child: Scaffold(
        body: Consumer<SettingModel>(builder: (context, model, child) {
          return Center(
            child: RaisedButton(
                child: Text("Sign out with Twitter"),
                color: Color(0xFF1DA1F2),
                textColor: Colors.white,
                onPressed: () async {
                  await model.signOutWithTwitter();
                  // StartPageに遷移する
                  await Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => StartPage()));
                }),
          );
        }),
      ),
    );
  }
}

// テンプレート
// class StartPage extends StatelessWidget {
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<SettingModel>(
//       create: (_) => SettingModel(),
//       child: Scaffold(
//         body: Consumer<SettingModel>(builder: (context, model, child) {
//           return Container();
//         }),
//       ),
//     );
//   }
// }
