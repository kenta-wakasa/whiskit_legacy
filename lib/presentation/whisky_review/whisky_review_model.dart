import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhiskyReviewModel extends ChangeNotifier {
  String reviewText = '';
  String uid = '';

  Future addReviewToFirebase(String whiskyID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');

    // ToDo: 文字数制限をかける
    if (reviewText.isEmpty) {
      throw ('感想を入力してください');
    }
    // whisky以下のサブコレクションとしてreviewを追加する
    FirebaseFirestore.instance
        .collection('whisky')
        .doc(whiskyID)
        .collection('review')
        .add({
      'text': reviewText,
      'createdAt': Timestamp.now(),
      'uid': uid,
      'whiskyID': whiskyID,
      'favoriteCount': 0,
    });
  }
}
