import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whiskit_app/domain/whisky.dart';

class MyModel extends ChangeNotifier {
  String uid = '';
  String userName = '';
  String avatarPhotoURL = '';
  bool isMe = true;
  List<Whisky> whisky = [];
  int reviewCount = 0;
  int drankWhiskyCount = 0;
  int favoriteCount = 0;

  Future getMyInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.uid = prefs.get('uid');

    // レビューから自分のuidと一致するリストを引っ張ってくる
    final docReview = await FirebaseFirestore.instance
        .collection('review')
        .where('uid', isEqualTo: uid)
        .get();

    // レビューの数を代入する
    reviewCount = docReview.docs.length;

    List<String> drankWhisky = [];
    docReview.docs.forEach((doc) {
      drankWhisky.add(doc.data()['whiskyID']);
      favoriteCount += doc.data()['favoriteCount'];
    });

    // 重複を削除する
    drankWhisky = drankWhisky.toSet().toList();

    // 飲んだウイスキー数を代入する
    drankWhiskyCount = drankWhisky.length;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(this.uid)
        .get();

    this.userName = doc.data()['userName'];
    this.avatarPhotoURL = doc.data()['avatarPhotoURL'];

    for (String id in drankWhisky) {
      final doc =
          await FirebaseFirestore.instance.collection('whisky').doc(id).get();
      this.whisky.add(
            Whisky(
              doc.data()['name'],
              doc.data()['imageURL'],
              doc.id,
            ),
          );
    }

    notifyListeners();
  }
}
