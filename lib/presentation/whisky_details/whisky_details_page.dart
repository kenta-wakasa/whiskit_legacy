import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whiskit_app/domain/whisky_review.dart';
import 'package:whiskit_app/presentation/whisky_details/whisky_details_model.dart';
import 'package:whiskit_app/presentation/whisky_review/whisky_review_page.dart';

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not Launch $url';
  }
}

class WhiskyDetailsPage extends StatelessWidget {
  final String documentID;
  final String name;
  String rakuten = '';
  String amazon = '';
  // 値を受け取る
  WhiskyDetailsPage({Key key, this.documentID, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WhiskyDetailsModel>(
      create: (_) => WhiskyDetailsModel()..fetchWhiskyDetails(documentID),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Colors.black54,
            title: Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Consumer<WhiskyDetailsModel>(builder: (context, model, child) {
          // ?.を使うことでnullならよばれなくなる
          final imageURL = model.whiskyDetails?.imageURL;
          final name = model.whiskyDetails?.name;
          final style = model.whiskyDetails?.style;
          final distillery = model.whiskyDetails?.distillery;
          final alcohol = model.whiskyDetails?.alcohol;
          this.rakuten = model.whiskyDetails?.rakuten;
          this.amazon = model.whiskyDetails?.amazon;

          final sizedBoxWidth = 250.0;
          // 三項演算子で値がnullならContainerを実行するように
          return imageURL == null
              ? Center(child: Container(child: CircularProgressIndicator()))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(children: <Widget>[
                      Image.network(
                        imageURL,
                        height: 150,
                      ),
                      SizedBox(height: 15),
                      Text(
                        name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      DefaultTextStyle.merge(
                        style: TextStyle(fontSize: 12),
                        child: Column(
                          children: [
                            SizedBox(
                              width: sizedBoxWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('蒸溜所'),
                                  Text(distillery)
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            SizedBox(
                              width: sizedBoxWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[Text('スタイル'), Text(style)],
                              ),
                            ),
                            SizedBox(height: 5),
                            SizedBox(
                              width: sizedBoxWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('アルコール度数'),
                                  Text(alcohol + '%')
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Expanded(child: Consumer<WhiskyDetailsModel>(
                        builder: (context, model, child) {
                          final whiskyReview = model.whiskyReview;
                          return ListView.builder(
                              itemCount: whiskyReview.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _reviewCard(whiskyReview[index], model);
                              });
                        },
                      )),
                    ]),
                  ),
                );
        }),
        persistentFooterButtons: <Widget>[
          RaisedButton(
            onPressed: () {
              _launchURL(amazon);
            },
            child: Text("Amazonで見る",
                style: TextStyle(fontWeight: FontWeight.bold)),
            color: Colors.deepOrangeAccent,
            shape: StadiumBorder(),
          ),
          RaisedButton(
            onPressed: () {
              _launchURL(rakuten);
            },
            child: Text("楽天で見る", style: TextStyle(fontWeight: FontWeight.bold)),
            color: Colors.red,
            shape: StadiumBorder(),
          ),
        ],
        floatingActionButton:
            Consumer<WhiskyDetailsModel>(builder: (context, model, child) {
          return IconButton(
            icon: Icon(Icons.rate_review),
            onPressed: () async {
              // 下から上にせりあがる画面遷移
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WhiskyReviewPage(documentID: documentID, name: name),
                  fullscreenDialog: true,
                ), //以下を追加
              );
              model.fetchWhiskyDetails(documentID);
            },
            iconSize: 35,
            color: Colors.blue,
          );
        }),
      ),
    );
  }

  Widget _reviewCard(WhiskyReview whiskyReview, WhiskyDetailsModel model) {
    return Card(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(whiskyReview.avatarPhotoURL),
            maxRadius: 12,
          ),
          Text(whiskyReview.userName),
          Text(whiskyReview.text),
          FlatButton(
              height: 5,
              minWidth: 1,
              child: Icon(
                whiskyReview.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 16,
              ),
              onPressed: () async {
                model.changeFavorite(
                  whiskyReview.documentID,
                );
                whiskyReview.isFavorite = !whiskyReview.isFavorite;
              }),
        ],
      ),
    );
  }
}
