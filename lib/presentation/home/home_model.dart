import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whiskit_app/domain/home_card.dart';
import 'package:whiskit_app/domain/users.dart';

class HomeModel extends ChangeNotifier {
  List<HomeCard> homeCard = [];
  Users users;
  String uid;
  bool isFavorite = false;

  Future fetchWhiskyReview() async {
    // uid の取得
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.get('uid');

    // ウィスキーのレビュー取得
    final docWhiskyReview = await FirebaseFirestore.instance
        .collection('review')
        .orderBy('timestamp', descending: true)
        .get();

    // await Future.wait() で　値を取り出せる
    final homeCard = await Future.wait(docWhiskyReview.docs
        .map(
          (doc) async => HomeCard(
            doc.id,
            await getAvatarPhoto(doc.data()['uid']),
            await getUserName(doc.data()['uid']),
            doc.data()['whiskyID'],
            await getWhiskyImageURL(doc.data()['whiskyID']),
            await getWhiskyName(doc.data()['whiskyID']),
            doc.data()['text'],
            await getFavorite(doc.data()['uid'], doc.id),
            doc.data()['favoriteCount'],
          ),
        )
        .toList());

    this.homeCard = homeCard;
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

  // whiskyNameを取得する
  Future<String> getWhiskyName(String whiskyID) async {
    final docUsers = await FirebaseFirestore.instance
        .collection('whisky')
        .doc(whiskyID)
        .get();
    return docUsers.data()['name'];
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
    notifyListeners();
    // レビューに対するいいねがあれば削除、なければ追加する
    final favorite = FirebaseFirestore.instance.collection('favorite');
    final docFavorite = await favorite
        .where('reviewID', isEqualTo: documentID)
        .where('uid', isEqualTo: uid)
        .get();

    final review =
        FirebaseFirestore.instance.collection('review').doc(documentID);
    // docsが空なら新規で追加
    if (docFavorite.docs.isEmpty) {
      await favorite.add({
        'uid': uid,
        'reviewID': documentID,
      });
      // reviewのfavorite数を増やす
      return FirebaseFirestore.instance
          .runTransaction((transaction) async {
            // Get the document
            DocumentSnapshot snapshot = await transaction.get(review);

            if (!snapshot.exists) {
              throw Exception("User does not exist!");
            }

            // Update the follower count based on the current count
            // Note: this could be done without a transaction
            // by updating the population using FieldValue.increment()

            int favoriteCount = snapshot.data()['favoriteCount'] + 1;

            // Perform an update on the document
            transaction.update(review, {'favoriteCount': favoriteCount});

            // Return the new count
            return favoriteCount;
          })
          .then((value) => print("Favorite count updated to $value"))
          .catchError(
              (error) => print("Failed to update user Favorite : $error"));
      // docsに値があればそれらを削除
    } else {
      for (DocumentSnapshot ds in docFavorite.docs) {
        ds.reference.delete();
        // reviewのfavorite数を減らす
        return FirebaseFirestore.instance
            .runTransaction((transaction) async {
              // Get the document
              DocumentSnapshot snapshot = await transaction.get(review);

              if (!snapshot.exists) {
                throw Exception("User does not exist!");
              }

              // Update the follower count based on the current count
              // Note: this could be done without a transaction
              // by updating the population using FieldValue.increment()

              int favoriteCount = snapshot.data()['favoriteCount'] - 1;

              // Perform an update on the document
              transaction.update(review, {'favoriteCount': favoriteCount});

              // Return the new count
              return favoriteCount;
            })
            .then((value) => print("Follower count updated to $value"))
            .catchError(
                (error) => print("Failed to update user followers: $error"));
      }
    }
  }
}
