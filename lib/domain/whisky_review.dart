import 'package:cloud_firestore/cloud_firestore.dart';

class WhiskyReview {
  String text = '';
  Timestamp timestamp;
  String userName = '';
  String avatarPhotoURL = '';
  WhiskyReview(this.text, this.timestamp, this.userName, this.avatarPhotoURL);
}
