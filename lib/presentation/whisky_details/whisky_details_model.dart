import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whiskit_app/domain/users.dart';
import 'package:whiskit_app/domain/whisky_details.dart';
import 'package:whiskit_app/domain/whisky_review.dart';

class WhiskyDetailsModel extends ChangeNotifier {
  WhiskyDetails whiskyDetails;
  List<WhiskyReview> whiskyReview = [];
  Users users;
  String uid;
  bool isFavorite = false;

  Future fetchWhiskyDetails(String documentID) async {
    // uid の取得
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.get('uid');

    // ウィスキーの基本情報取得
    final docWhiskyDetails = await FirebaseFirestore.instance
        .collection('whisky')
        .doc(documentID)
        .get();

    this.whiskyDetails = WhiskyDetails(
      docWhiskyDetails.data()['brand'],
      docWhiskyDetails.data()['imageURL'],
      docWhiskyDetails.data()['name'],
      docWhiskyDetails.data()['distillery'],
      docWhiskyDetails.data()['style'],
      docWhiskyDetails.data()['alcohol'],
      docWhiskyDetails.data()['rakuten'],
      docWhiskyDetails.data()['amazon'],
    );

    // ウィスキーのレビュー取得
    final docWhiskyReview = await FirebaseFirestore.instance
        .collection('review')
        .orderBy('timestamp', descending: true)
        .where('whiskyID', isEqualTo: documentID)
        .get();

    // await Future.wait() で　値を取り出せる
    final whiskyReview = await Future.wait(docWhiskyReview.docs
        .map(
          (doc) async => WhiskyReview(
            doc.id,
            await getWhiskyImageURL(doc.data()['whiskyID']),
            doc.data()['text'],
            doc.data()['timestamp'],
            await getUserName(doc.data()['uid']),
            await getAvatarPhoto(doc.data()['uid']),
            await getFavorite(doc.data()['uid'], doc.id),
          ),
        )
        .toList());

    this.whiskyReview = whiskyReview;
    notifyListeners();
  }

  // WhiskyImageURLを取得する
  Future<String> getWhiskyImageURL(String whiskyID) async {
    final docWhisky = await FirebaseFirestore.instance
        .collection('whisky')
        .doc(whiskyID)
        .get();
    return docWhisky.data()['imageURL'];
  }

  // userNameを取得する
  Future<String> getUserName(String uid) async {
    final docUsers =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return docUsers.data()['userName'];
  }

  // avatarPhotoURLを取得する
  Future<String> getAvatarPhoto(String uid) async {
    final docUsers =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return docUsers.data()['avatarPhotoURL'];
  }

  // 空でなければtrueを返す
  Future<bool> getFavorite(String uid, String reviewID) async {
    final favorite = FirebaseFirestore.instance.collection('favorite');
    final doc = await favorite
        .where('reviewID', isEqualTo: reviewID)
        .where('uid', isEqualTo: uid)
        .get();
    return doc.docs.isNotEmpty;
  }

  Future changeFavorite(String documentID) async {
    // レビューに対するいいねがあれば削除、なければ追加する
    final favorite = FirebaseFirestore.instance.collection('favorite');
    final doc = await favorite
        .where('reviewID', isEqualTo: documentID)
        .where('uid', isEqualTo: uid)
        .get();

    // docsが空なら新規で追加
    if (doc.docs.isEmpty) {
      await favorite.add({
        'uid': uid,
        'reviewID': documentID,
      });
      // docsに値があればそれらを削除
    } else {
      for (DocumentSnapshot ds in doc.docs) {
        ds.reference.delete();
      }
    }
    notifyListeners();
  }
}
