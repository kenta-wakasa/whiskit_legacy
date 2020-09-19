import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/presentation/whisky_review/whisky_review_model.dart';

class WhiskyReviewPage extends StatelessWidget {
  final String documentID;
  final String name;
  WhiskyReviewPage({Key key, this.documentID, this.name}) : super(key: key);
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WhiskyReviewModel>(
      create: (_) => WhiskyReviewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: <Widget>[
            Consumer<WhiskyReviewModel>(builder: (context, model, child) {
              return FlatButton(
                onPressed: () async {
                  try {
                    await model.addReviewToFirebase(documentID);
                    await _showDialog(context, '投稿しました！');
                    Navigator.of(context).pop();
                  } catch (e) {
                    _showDialog(context, e.toString());
                  }
                },
                child: Text(
                  '投稿',
                ),
              );
            })
          ],
          backgroundColor: Colors.black87,
        ),
        body: Consumer<WhiskyReviewModel>(builder: (context, model, child) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  onChanged: (text) {
                    model.reviewText = text;
                  },
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '感想を書く',
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Future _showDialog(
    BuildContext context,
    String title,
  ) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
