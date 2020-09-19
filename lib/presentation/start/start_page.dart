import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/presentation/start/start_model.dart';

import '../main/main.dart';

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
            return Center(
              child: RaisedButton(
                  child: Text("Sign in with Twitter"),
                  color: Color(0xFF1DA1F2),
                  textColor: Colors.white,
                  onPressed: () async {
                    await model.signInWithTwitter();
                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  }),
            );
          }),
        ),
      ),
    );
  }
}
