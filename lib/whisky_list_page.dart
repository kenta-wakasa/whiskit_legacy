import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/whisky_list_model.dart';

class WhiskyListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WhiskyListModel>(
      create: (_) => WhiskyListModel()..fetchWhisky(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ウイスキ一覧'),
        ),
        body: Consumer<WhiskyListModel>(
          builder: (context, model, child) {
            final whisky = model.whisky;
            final listTiles = whisky
                .map(
                  (whisky) => ListTile(
                    title: Text(whisky.name),
                  ),
                )
                .toList();
            return ListView(
              children: listTiles,
            );
          },
        ),
      ),
    );
  }
}
