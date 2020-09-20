import 'package:flutter/material.dart';

// ミックスイン：クラスのコードを複数のクラス階層で再利用する方法です。
// ミックスインするにはwithキーワードに続けて1つ以上のつ以上のクラスを指定します。
// ChangeNotifierをmixinするだけで、ViewModelとして機能します。
// ロジック実行後にnotifyListeners()を呼ぶことで、View側に変更を通知できます。

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;
  get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    // View側に変更を通知
    notifyListeners();
  }
}
