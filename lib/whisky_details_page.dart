import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whiskit_app/whisky_details_model.dart';

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not Launch $url';
  }
}

class WhiskyDetailsPage extends StatelessWidget {
  final String name;
  String rakuten;
  String amazon;
  // 値を受け取る
  WhiskyDetailsPage({Key key, @required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: Colors.white70);
    return ChangeNotifierProvider<WhiskyDetailsModel>(
      create: (_) => WhiskyDetailsModel()..fetchWhiskyDetails(name),
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
          final imgaeURL = model?.whiskyDetails[0]?.imageURL;
          final name = model?.whiskyDetails[0]?.name;
          final style = model?.whiskyDetails[0]?.style;
          final distillery = model?.whiskyDetails[0]?.distillery;
          final alcohol = model?.whiskyDetails[0]?.alcohol;
          this.rakuten = model?.whiskyDetails[0]?.rakuten;
          this.amazon = model?.whiskyDetails[0]?.amazon;
          final sizedBoxWidth = 250.0;
          // 三項演算子で値がnullならContainerを実行するように
          return imgaeURL == null
              ? Center(child: Container(child: CircularProgressIndicator()))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          imgaeURL,
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
                        Expanded(
                          //最大の高さを指定
                          child: ListView(children: <Widget>[
                            Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://pbs.twimg.com/profile_images/1242426611862867968/GKZzdK6u_reasonably_small.jpg'), // no matter how big it is, it won't overflow
                                ),
                                title: Text(
                                  'こんぶ',
                                  style: TextStyle(fontSize: 12),
                                ),
                                subtitle: Text(
                                  'すっきりしていて繊細な味わい。ストレートでゆっくり楽しみたい感じです。',
                                  style: TextStyle(fontSize: 10),
                                ),
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
                            ),
                            Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://pbs.twimg.com/profile_images/1242426611862867968/GKZzdK6u_reasonably_small.jpg'), // no matter how big it is, it won't overflow
                                ),
                                title: Text(
                                  'こんぶ',
                                  style: TextStyle(fontSize: 12),
                                ),
                                subtitle: Text(
                                  'すっきりしていて繊細な味わい。ストレートでゆっくり楽しみたい感じです。',
                                  style: TextStyle(fontSize: 10),
                                ),
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
                            ),
                            Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://pbs.twimg.com/profile_images/1242426611862867968/GKZzdK6u_reasonably_small.jpg'), // no matter how big it is, it won't overflow
                                ),
                                title: Text(
                                  'こんぶ',
                                  style: TextStyle(fontSize: 12),
                                ),
                                subtitle: Text(
                                  'すっきりしていて繊細な味わい。ストレートでゆっくり楽しみたい感じです。',
                                  style: TextStyle(fontSize: 10),
                                ),
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
                            ),
                            Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://pbs.twimg.com/profile_images/1242426611862867968/GKZzdK6u_reasonably_small.jpg'), // no matter how big it is, it won't overflow
                                ),
                                title: Text(
                                  'こんぶ',
                                  style: TextStyle(fontSize: 12),
                                ),
                                subtitle: Text(
                                  'すっきりしていて繊細な味わい。ストレートでゆっくり楽しみたい感じです。',
                                  style: TextStyle(fontSize: 10),
                                ),
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
                            ),
                          ]),
                        )
                      ], //Image.network(whiskyDetails[0].imageURL),
                    ),
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
          IconButton(
            icon: Icon(Icons.rate_review),
            onPressed: () {
              //ToDo: レビュー投稿機能
            },
            iconSize: 35,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
