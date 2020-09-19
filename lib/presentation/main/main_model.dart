import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  String testText = 'whisky';
  void changeText(){
    testText = 'ウイスキー';
    notifyListeners(); // 変更を通知する
  }
}