import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/whisky_details_page.dart';
import 'package:whiskit_app/whisky_list_model.dart';

class WhiskyListPage extends StatelessWidget {
  final country = 'japanese';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WhiskyListModel>(
      create: (_) => WhiskyListModel()..fetchWhisky(country),
      child: Scaffold(
        appBar: AppBar(
            // title: Text('ジャパニーズ'),
            ),
        body: Consumer<WhiskyListModel>(
          builder: (context, model, child) {
            final whisky = model.whisky;
            final listTiles = whisky
                .map(
                  (whisky) => ListTile(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WhiskyDetailsPage(name: whisky.name)),
                      );
                    },
                    title: Image.network(whisky.imageURL),
                  ),
                )
                .toList();
            return GridView.count(
              crossAxisCount: 5,
              padding: const EdgeInsets.all(10),
              childAspectRatio: 4 / 5,
              children: listTiles,
            );
          },
        ),
      ),
    );
  }
}
