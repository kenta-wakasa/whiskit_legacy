import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/domain/whisky.dart';
import 'package:whiskit_app/presentation/whisky_details/whisky_details_page.dart';
import 'package:whiskit_app/presentation/whisky_list/whisky_list_model.dart';

class WhiskyListPage extends StatelessWidget {
  final _tab = <Tab>[
    Tab(
      icon: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Flag_of_Ireland.svg/1600px-Flag_of_Ireland.svg.png'),
    ),
    Tab(
      icon: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Flag_of_Scotland.svg/600px-Flag_of_Scotland.svg.png'),
    ),
    Tab(
      icon: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Flag_of_Japan.svg/1599px-Flag_of_Japan.svg.png'),
    ),
    Tab(
      icon: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Flag_of_the_United_States.svg/1600px-Flag_of_the_United_States.svg.png'),
    ),
    Tab(
      icon: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Flag_of_Canada.svg/1600px-Flag_of_Canada.svg.png'),
    ),
  ];

  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 2,
      length: _tab.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: TabBar(
            tabs: _tab,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            TabPage(country: 'IRISH'),
            TabPage(country: 'SCOTCH'),
            TabPage(country: 'JAPANESE'),
            TabPage(country: 'AMERICAN'),
            TabPage(country: 'CANADIAN'),
          ],
        ),
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  final String country;
  const TabPage({Key key, this.country}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WhiskyListModel>(
      create: (_) => WhiskyListModel()..fetchWhisky(country),
      child: Scaffold(
        body: Consumer<WhiskyListModel>(
          builder: (context, model, child) {
            return model.whisky == null
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : GridView.builder(
                    // ToDo: ページングに対応する
                    // controller: _getItem(model),z
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      childAspectRatio: 2 / 5,
                    ),
                    itemCount: model.whisky.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _whiskyCard(context, model.whisky[index]);
                    });
          },
        ),
      ),
    );
  }

  // スクロールを監視してページングする
  _getItem(WhiskyListModel model) {
    ScrollController _scrollController = ScrollController();
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentPosition = _scrollController.position.pixels;
      if (maxScrollExtent > 0 && (maxScrollExtent + 50.0) <= currentPosition) {
        // model.item += 50;
        model.fetchWhisky(country);
      }
    });
    return _scrollController;
  }

  Widget _whiskyCard(BuildContext context, Whisky whisky) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 2,
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WhiskyDetailsPage(
                  documentID: whisky.documentID,
                  name: whisky.name,
                ),
              ));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.network(whisky.imageURL),
            ),
          ],
        ),
      ),
    );
  }
}
