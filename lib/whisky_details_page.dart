import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/whisky_details_model.dart';

class WhiskyDetailsPage extends StatelessWidget {
  final String name;
  // 値を受け取る
  WhiskyDetailsPage({Key key, @required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WhiskyDetailsModel>(
      create: (_) => WhiskyDetailsModel()..fetchWhiskyDetails(name),
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: Consumer<WhiskyDetailsModel>(builder: (context, model, child) {
          // ?.を使うことでnullならよばれなくなる
          final imgaeURL = model?.whiskyDetails[0]?.imageURL;
          // 三項演算子で値がnullならContainerを実行するように
          return imgaeURL == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          imgaeURL,
                          height: 150,
                        ),
                      ],
                      //Image.network(whiskyDetails[0].imageURL),
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
