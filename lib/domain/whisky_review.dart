import 'package:cloud_firestore/cloud_firestore.dart';

class WhiskyReview {
  String reviewID;
  String whiskyID;
  String text = '';
  String userName = '';
  String avatarPhotoURL = '';
  bool isFavorite = false;
  int favoriteCount = 0;

  WhiskyReview(
    this.reviewID,
    this.whiskyID,
    this.text,
    this.userName,
    this.avatarPhotoURL,
    this.isFavorite,
    this.favoriteCount,
  );
}
