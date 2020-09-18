import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whiskit_app/whisky.dart';

class WhiskyListModel extends ChangeNotifier {
  List<Whisky> whisky = [];
  bool isLoading = false;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future fetchWhisky(String country) async {
    startLoading();
    final docs = await FirebaseFirestore.instance
        .collection('whisky')
        .where('country', isEqualTo: country)
        .get();
    final whisky = docs.docs
        .map(
          (doc) => Whisky(doc.data()['name'], doc.data()['imageURL']),
        )
        .toList();
    this.whisky = whisky;
    endLoading();
    notifyListeners();
  }
}
