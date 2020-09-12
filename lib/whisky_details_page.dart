import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WhiskyDetailsPage extends StatelessWidget {
  final String name;
  // 値を受け取る
  WhiskyDetailsPage({Key key, @required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text(this.name),
    );
  }
}
