import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whiskit_app/domain/home_card.dart';
import 'package:whiskit_app/domain/users.dart';

class HomeModel extends ChangeNotifier {
  List<HomeCard> homeCard = [];
  Users users;
  String uid = FirebaseAuth.instance.currentUser.uid;

  Future fetchWhiskyReview() async {
    // ウィスキーのレビュー取得
    final reviewSnapshots = await FirebaseFirestore.instance
        .collectionGroup('review')
        .orderBy('createdAt', descending: true)
        .get();
    this.homeCard = await Future.wait(
      reviewSnapshots.docs
          .map(
            (doc) async => HomeCard(
              doc.id,
              doc.data()['uid'],
              await _getData('users', doc.data()['uid'], 'avatarPhotoURL'),
              await _getData('users', doc.data()['uid'], 'userName'),
              doc.data()['whiskyID'],
              await _getData('whisky', doc.data()['whiskyID'], 'imageURL'),
              await _getData('whisky', doc.data()['whiskyID'], 'name'),
              doc.data()['text'],
              await _getFavorite(doc.id),
              doc.data()['favoriteCount'],
            ),
          )
          .toList(),
    );
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
  Future addFavorite(HomeCard homeCard) async {
    homeCard.isFavorite = true;
    notifyListeners();

    // reviewにいいねをぶら下げる
    // whisky/{whiskyDoc}/review/{reviewDoc}/likedUsers
    final docLikedUsers = FirebaseFirestore.instance
        .collection('whisky')
        .doc(homeCard.whiskyID)
        .collection('review')
        .doc(homeCard.reviewID)
        .collection('likedUsers')
        .doc(this.uid);

    // usersにいいねをぶら下げる
    // users/{usersDoc}/likedReview
    // whiskyIDを要素に持たせると検索が楽か
    final docLikedReview = FirebaseFirestore.instance
        .collection('users')
        .doc(this.uid)
        .collection('likedReview')
        .doc(homeCard.reviewID);

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
        'reviewID': homeCard.reviewID,
        'whiskyID': homeCard.whiskyID,
        'createdAt': Timestamp.now(),
      },
    );

    // favoriteCount を増やす
    final docReview = FirebaseFirestore.instance
        .collection('whisky')
        .doc(homeCard.whiskyID)
        .collection('review')
        .doc(homeCard.reviewID);

    homeCard.favoriteCount += 1;
    _batch.update(
      docReview,
      {
        'favoriteCount': homeCard.favoriteCount,
      },
    );

    await _batch.commit().then((value) => print('success!'));

    notifyListeners();
  }

  // レビューに対して自分がいいねしていなければいいねを追加
  Future deleteFavorite(HomeCard homeCard) async {
    homeCard.isFavorite = false;
    notifyListeners();

    final docLikedUsers = FirebaseFirestore.instance
        .collection('whisky')
        .doc(homeCard.whiskyID)
        .collection('review')
        .doc(homeCard.reviewID)
        .collection('likedUsers')
        .doc(this.uid);
    final docLikedReview = FirebaseFirestore.instance
        .collection('users')
        .doc(this.uid)
        .collection('likedReview')
        .doc(homeCard.reviewID);

    // 処理をバッチでまとめる
    WriteBatch _batch = FirebaseFirestore.instance.batch();
    _batch.delete(docLikedUsers);
    _batch.delete(docLikedReview);

    // favoriteCount を減らす
    final docReview = FirebaseFirestore.instance
        .collection('whisky')
        .doc(homeCard.whiskyID)
        .collection('review')
        .doc(homeCard.reviewID);

    homeCard.favoriteCount -= 1;
    _batch.update(
      docReview,
      {
        'favoriteCount': homeCard.favoriteCount,
      },
    );

    await _batch.commit().then((value) => print('success!'));

    notifyListeners();
  }
}
