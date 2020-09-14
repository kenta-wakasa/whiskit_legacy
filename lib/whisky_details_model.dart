import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whiskit_app/whisky_details.dart';

class WhiskyDetailsModel extends ChangeNotifier {
  List<WhiskyDetails> whiskyDetails = List<WhiskyDetails>(1);
  Future fetchWhiskyDetails(String name) async {
    final docs = await FirebaseFirestore.instance
        .collection('whisky')
        .where('name', isEqualTo: name)
        .get();
    final whiskyDetails = docs.docs
        .map(
          (doc) => WhiskyDetails(doc.data()['name'], doc.data()['imageURL']),
        )
        .toList();
    this.whiskyDetails = whiskyDetails;
    notifyListeners();
  }
}
