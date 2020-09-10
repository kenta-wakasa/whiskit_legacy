

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class WhiskyList extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('whisky').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView(
            children: snapshot.data.docs.map( (DocumentSnapshot document) {
              return ListTile(
                title: Text(document.data()['name']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}