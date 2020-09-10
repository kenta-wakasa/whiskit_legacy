import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/main_model.dart';

void main() {
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
                    child: Text('ボタン'),
                    onPressed: () {
                      // ここでなにかやる
                      model.changeText();
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
