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

  Future fetchWhiskyDetails(String whiskyID) async {
    // uid の取得
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.get('uid');

    // ウィスキーの基本情報取得
    final docWhiskyDetails = await FirebaseFirestore.instance
        .collection('whisky')
        .doc(whiskyID)
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
        .collection('whisky')
        .doc(whiskyID)
        .collection('review')
        .orderBy('createdAt', descending: true)
        .get();

    // await Future.wait() で　値を取り出せる
    this.whiskyReview = await Future.wait(docWhiskyReview.docs
        .map(
          (doc) async => WhiskyReview(
            doc.id,
            doc.data()['whiskyID'],
            doc.data()['text'],
            await _getData('users', doc.data()['uid'], 'userName'),
            await _getData('users', doc.data()['uid'], 'avatarPhotoURL'),
            await getFavorite(doc.id),
            doc.data()['favoriteCount'],
          ),
        )
        .toList());
    notifyListeners();
  }

  // collection, documentID, filed名　を渡してデータを得る
  Future _getData(
    String collectionName,
    String documentID,
    String fieldName,
  ) async {
    final doc = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentID)
        .get();
    return doc.data()[fieldName];
  }

  // 空でなければtrueを返す
  Future<bool> getFavorite(String reviewID) async {
    final favorite = FirebaseFirestore.instance.collection('favorite');
    final doc = await favorite
        .where('reviewID', isEqualTo: reviewID)
        .where('uid', isEqualTo: this.uid)
        .get();
    return doc.docs.isNotEmpty;
  }

  Future changeFavorite(WhiskyReview whiskyReview) async {
    // レビューに対するいいねがあれば削除、なければ追加する
    final favorite = FirebaseFirestore.instance.collection('favorite');
    final docFavorite = await favorite
        .where('reviewID', isEqualTo: whiskyReview.reviewID)
        .where('uid', isEqualTo: this.uid)
        .get();

    final review = FirebaseFirestore.instance
        .collection('whisky')
        .doc(whiskyReview.whiskyID)
        .collection('review')
        .doc(whiskyReview.reviewID);

    // 自分がいいねしていないなら、いいねを追加する
    if (!whiskyReview.isFavorite) {
      return FirebaseFirestore.instance
          .runTransaction((transaction) async {
            await favorite.add(
              {
                'uid': uid,
                'reviewID': whiskyReview.reviewID,
              },
            );
            whiskyReview.favoriteCount += 1;

            // いいね数を減らす
            transaction.update(
              review,
              {
                'favoriteCount': whiskyReview.favoriteCount,
              },
            );
            whiskyReview.isFavorite = true;
            // Return the new count
            return;
          })
          .then((value) => notifyListeners())
          .catchError((error) => print("いいねの更新に失敗しました : $error"));
      // docsに値があればそれらを削除
    } else {
      // reviewのfavorite数を減らす
      return FirebaseFirestore.instance
          .runTransaction((transaction) async {
            // データ削除
            docFavorite.docs[0].reference.delete();

            // いいね数を減らす
            whiskyReview.favoriteCount -= 1;
            transaction.update(
              review,
              {
                'favoriteCount': whiskyReview.favoriteCount,
              },
            );
            whiskyReview.isFavorite = false;
            return;
          })
          .then((value) => notifyListeners())
          .catchError((error) => print("いいねの更新に失敗しました : $error"));
    }
  }
}
