import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whiskit_app/domain/whisky.dart';

class MyModel extends ChangeNotifier {
  List<Whisky> whisky = [];

  String uid = '';
  String userName = '';
  String avatarPhotoURL = '';

  bool isMe = true;
  bool isLoading = false;

  int reviewCount;
  int drankWhiskyCount;
  int favoriteCount;

  Future getMyInfo() async {
    this.isLoading = true;

    // 値の初期化
    this.reviewCount = 0;
    this.drankWhiskyCount = 0;
    this.favoriteCount = 0;
    List<String> _drankWhisky = [];
    List<Whisky> _whisky = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.uid = prefs.get('uid');

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(this.uid)
        .get();
    this.userName = doc.data()['userName'];
    this.avatarPhotoURL = doc.data()['avatarPhotoURL'];

    // レビューから自分のuidと一致するリストを引っ張ってくる
    final docReview = await FirebaseFirestore.instance
        .collection('review')
        .where('uid', isEqualTo: uid)
        .get();

    // レビューの数を代入する
    reviewCount = docReview.docs.length;

    docReview.docs.forEach((doc) {
      _drankWhisky.add(doc.data()['whiskyID']);
      favoriteCount += doc.data()['favoriteCount'];
    });

    // 重複を削除する
    _drankWhisky = _drankWhisky.toSet().toList();
    // 飲んだウイスキー数を代入する
    drankWhiskyCount = _drankWhisky.length;

    // ウィスキーリストの作成
    for (String id in _drankWhisky) {
      final doc =
          await FirebaseFirestore.instance.collection('whisky').doc(id).get();
      _whisky.add(
        Whisky(
          doc.data()['name'],
          doc.data()['imageURL'],
          doc.id,
        ),
      );
    }
    this.whisky = _whisky;

    this.isLoading = false;
    notifyListeners();
  }
}
