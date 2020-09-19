import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
        appBar: AppBar(
          title: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black87,
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
                          final listTiles = whiskyReview
                              .map(
                                (whiskyReview) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(whiskyReview
                                        .avatarPhotoURL), // no matter how big it is, it won't overflow
                                  ),
                                  title: Text(
                                    whiskyReview.userName,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  subtitle: Text(whiskyReview.text),
                                  trailing: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: IconButton(
                                        padding: EdgeInsets.all(0.0),
                                        icon: Icon(
                                          Icons.favorite,
                                          size: 15,
                                        ),
                                        onPressed: () {}),
                                  ),
                                  isThreeLine: true,
                                ),
                              )
                              .toList();
                          return ListView.builder(
                              itemCount: listTiles.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _reviewCard(listTiles[index]);
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

  Widget _reviewCard(ListTile listTile) {
    return Card(child: listTile);
  }
}
