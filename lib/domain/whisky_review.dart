import 'package:cloud_firestore/cloud_firestore.dart';

class WhiskyReview {
  String documentID;
  String whiskyImageURL;
  String text = '';
  Timestamp timestamp;
  String userName = '';
  String avatarPhotoURL = '';
  bool isFavorite = false;

  WhiskyReview(
    this.documentID,
    this.whiskyImageURL,
    this.text,
    this.timestamp,
    this.userName,
    this.avatarPhotoURL,
    this.isFavorite,
  );
}
