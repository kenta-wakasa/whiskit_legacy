import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whiskit_app/domain/users.dart';
import 'package:whiskit_app/domain/whisky_details.dart';
import 'package:whiskit_app/domain/whisky_review.dart';

class WhiskyDetailsModel extends ChangeNotifier {
  WhiskyDetails whiskyDetails;
  List<WhiskyReview> whiskyReview = [];
  Users users;

  Future fetchWhiskyDetails(String documentID) async {
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
        .where('whiskyID', isEqualTo: documentID)
        .get();

    // await Future.wait() で　値を取り出せる
    final whiskyReview = await Future.wait(docWhiskyReview.docs
        .map(
          (doc) async => WhiskyReview(
            doc.data()['text'],
            doc.data()['timestamp'],
            await getUserName(doc.data()['uid']),
            await getAvatarPhoto(doc.data()['uid']),
          ),
        )
        .toList());

    this.whiskyReview = whiskyReview;
    notifyListeners();
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
}
