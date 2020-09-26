import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whiskit_app/domain/users.dart';
import 'package:whiskit_app/domain/whisky.dart';

class UserModel extends ChangeNotifier {
  List<Whisky> whisky = [];

  String uid = FirebaseAuth.instance.currentUser.uid;
  Users users = Users('', '');

  bool isLoading = false;

  int reviewCount;
  int drankWhiskyCount;
  int favoriteCount;

  Future getUserInfo(String userID) async {
    // ロード中の識別
    this.isLoading = true;

    // 値の初期化
    this.reviewCount = 0;
    this.drankWhiskyCount = 0;
    this.favoriteCount = 0;
    List<String> _drankWhiskyID = [];
    List<Whisky> _whisky = [];

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    this.users = Users(
      await doc.data()['avatarPhotoURL'],
      await doc.data()['userName'],
    );

    // レビューから自分のuidと一致するリストを引っ張ってくる
    final docReview = await FirebaseFirestore.instance
        .collectionGroup('review')
        .where('uid', isEqualTo: userID)
        .get();

    // レビューの数を代入する
    this.reviewCount = docReview.docs.length;

    docReview.docs.forEach((doc) {
      _drankWhiskyID.add(doc.data()['whiskyID']);
      this.favoriteCount += doc.data()['favoriteCount'];
    });

    // 重複を削除する
    _drankWhiskyID = _drankWhiskyID.toSet().toList();
    // 飲んだウイスキー数を代入する
    this.drankWhiskyCount = _drankWhiskyID.length;

    // ウィスキーリストの作成
    for (String id in _drankWhiskyID) {
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
