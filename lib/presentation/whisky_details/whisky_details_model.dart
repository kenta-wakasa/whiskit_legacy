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
            await _getFavorite(doc.id),
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

  // 自分がそのレビューをいいねしているか
  Future<bool> _getFavorite(String reviewID) async {
    final dataLikedReview = await FirebaseFirestore.instance
        .collection('users')
        .doc(this.uid)
        .collection('likedReview')
        .doc(reviewID)
        .get();
    return dataLikedReview.exists;
  }

  // レビューに対して自分がいいねしていなければいいねを追加
  Future addFavorite(WhiskyReview whiskyReview) async {
    whiskyReview.isFavorite = true;
    notifyListeners();

    // reviewにいいねをぶら下げる
    // whisky/{whiskyDoc}/review/{reviewDoc}/likedUsers
    final docLikedUsers = FirebaseFirestore.instance
        .collection('whisky')
        .doc(whiskyReview.whiskyID)
        .collection('review')
        .doc(whiskyReview.reviewID)
        .collection('likedUsers')
        .doc(this.uid);

    // usersにいいねをぶら下げる
    // users/{usersDoc}/likedReview
    // whiskyIDを要素に持たせると検索が楽か
    final docLikedReview = FirebaseFirestore.instance
        .collection('users')
        .doc(this.uid)
        .collection('likedReview')
        .doc(whiskyReview.reviewID);

    // 処理をバッチでまとめる
    WriteBatch _batch = FirebaseFirestore.instance.batch();
    _batch.set(
      docLikedUsers,
      {
        'uid': this.uid,
        'createdAt': Timestamp.now(),
      },
    );
    _batch.set(
      docLikedReview,
      {
        'uid': this.uid,
        'reviewID': whiskyReview.reviewID,
        'whiskyID': whiskyReview.whiskyID,
        'createdAt': Timestamp.now(),
      },
    );

    // favoriteCount を増やす
    final docReview = FirebaseFirestore.instance
        .collection('whisky')
        .doc(whiskyReview.whiskyID)
        .collection('review')
        .doc(whiskyReview.reviewID);

    whiskyReview.favoriteCount += 1;
    _batch.update(
      docReview,
      {
        'favoriteCount': whiskyReview.favoriteCount,
      },
    );

    await _batch.commit().then((value) => print('success!'));

    notifyListeners();
  }

  // レビューに対して自分がいいねしていなければいいねを追加
  Future deleteFavorite(WhiskyReview whiskyReview) async {
    whiskyReview.isFavorite = false;
    notifyListeners();

    final docLikedUsers = FirebaseFirestore.instance
        .collection('whisky')
        .doc(whiskyReview.whiskyID)
        .collection('review')
        .doc(whiskyReview.reviewID)
        .collection('likedUsers')
        .doc(this.uid);
    final docLikedReview = FirebaseFirestore.instance
        .collection('users')
        .doc(this.uid)
        .collection('likedReview')
        .doc(whiskyReview.reviewID);

    // 処理をバッチでまとめる
    WriteBatch _batch = FirebaseFirestore.instance.batch();
    _batch.delete(docLikedUsers);
    _batch.delete(docLikedReview);

    // favoriteCount を減らす
    final docReview = FirebaseFirestore.instance
        .collection('whisky')
        .doc(whiskyReview.whiskyID)
        .collection('review')
        .doc(whiskyReview.reviewID);

    whiskyReview.favoriteCount -= 1;
    _batch.update(
      docReview,
      {
        'favoriteCount': whiskyReview.favoriteCount,
      },
    );

    await _batch.commit().then((value) => print('success!'));

    notifyListeners();
  }
}
