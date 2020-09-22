import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whiskit_app/domain/whisky.dart';

class WhiskyListModel extends ChangeNotifier {
  List<Whisky> whisky = [];
  bool isLoading = false;
  int item = 50;

  Future fetchWhisky(String country) async {
    final docs = await FirebaseFirestore.instance
        .collection('whisky')
        .where('country', isEqualTo: country)
        .get();
    this.whisky = docs.docs
        .map(
          (doc) => Whisky(
            doc.data()['name'],
            doc.data()['imageURL'],
            doc.id,
          ),
        )
        .toList();
    notifyListeners();
  }
}
