import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhiskyReviewModel extends ChangeNotifier {
  String reviewText = '';
  String uid = '';

  Future addReviewToFirebase(String whiskyID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    if (reviewText.isEmpty) {
      throw ('感想を入力してください');
    }
    FirebaseFirestore.instance.collection('review').add({
      'text': reviewText,
      'timestamp': Timestamp.now(),
      'uid': uid,
      'whiskyID': whiskyID,
      'favoriteCount': 0,
    });
  }
}
