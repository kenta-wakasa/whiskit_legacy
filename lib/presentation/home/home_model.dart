import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whiskit_app/domain/home_card.dart';
import 'package:whiskit_app/domain/users.dart';

class HomeModel extends ChangeNotifier {
  List<HomeCard> homeCard = [];
  Users users;
  String uid;

  Future fetchWhiskyReview() async {
    // uid の取得
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.get('uid');

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
    final favorite = FirebaseFirestore.instance.collection('favorite');
    final doc = await favorite
        .where('reviewID', isEqualTo: reviewID)
        .where('uid', isEqualTo: this.uid)
        .get();
    return doc.docs.isNotEmpty;
  }

  Future changeFavorite(HomeCard homeCard) async {
    // レビューに対するいいねがあれば削除、なければ追加する
    final favorite = FirebaseFirestore.instance.collection('favorite');
    final docFavorite = await favorite
        .where('reviewID', isEqualTo: homeCard.reviewID)
        .where('uid', isEqualTo: this.uid)
        .get();

    final review = FirebaseFirestore.instance
        .collection('whisky')
        .doc(homeCard.whiskyID)
        .collection('review')
        .doc(homeCard.reviewID);

    // 自分がいいねしていないなら、いいねを追加する
    if (!homeCard.isFavorite) {
      return FirebaseFirestore.instance
          .runTransaction((transaction) async {
            await favorite.add(
              {
                'uid': uid,
                'reviewID': homeCard.reviewID,
              },
            );
            homeCard.favoriteCount += 1;
            // Get the document
            transaction.update(
              review,
              {
                'favoriteCount': homeCard.favoriteCount,
              },
            );
            homeCard.isFavorite = true;
            // Return the new count
            return;
          })
          .then((value) => notifyListeners())
          .catchError((error) => print("いいねを追加できませんでした : $error"));
      // docsに値があればそれらを削除
    } else {
      // reviewのfavorite数を減らす
      return FirebaseFirestore.instance
          .runTransaction((transaction) async {
            for (DocumentSnapshot ds in docFavorite.docs) {
              ds.reference.delete();
            }
            homeCard.favoriteCount -= 1;
            transaction.update(
              review,
              {
                'favoriteCount': homeCard.favoriteCount,
              },
            );
            homeCard.isFavorite = false;
            return;
          })
          .then((value) => notifyListeners())
          .catchError((error) => print("いいねを追加できませんでした : $error"));
    }
  }
}
