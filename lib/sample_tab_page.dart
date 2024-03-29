import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/presentation/whisky_details/whisky_details_page.dart';
import 'package:whiskit_app/presentation/whisky_list/whisky_list_model.dart';

class SampleTabPage extends StatelessWidget {
  final _tab = <Tab>[
    Tab(
        icon: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Flag_of_Ireland.svg/1600px-Flag_of_Ireland.svg.png')),
    Tab(
        icon: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Flag_of_Scotland.svg/600px-Flag_of_Scotland.svg.png')),
    Tab(
        icon: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Flag_of_Japan.svg/1599px-Flag_of_Japan.svg.png')),
    Tab(
        icon: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Flag_of_the_United_States.svg/1600px-Flag_of_the_United_States.svg.png')),
    Tab(
        icon: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Flag_of_Canada.svg/1600px-Flag_of_Canada.svg.png')),
  ];

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: TabBar(
            tabs: _tab,
          ),
        ),
        body: TabBarView(children: <Widget>[
          TabPage(
              country: 'IRISH',
              image: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/Flag_of_Ireland.svg/1600px-Flag_of_Ireland.svg.png')),
          TabPage(
              country: 'SCOTCH',
              image: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Flag_of_Scotland.svg/600px-Flag_of_Scotland.svg.png')),
          TabPage(
              country: 'JAPANESE',
              image: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Flag_of_Japan.svg/1599px-Flag_of_Japan.svg.png')),
          TabPage(
              country: 'AMERICAN',
              image: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Flag_of_the_United_States.svg/1600px-Flag_of_the_United_States.svg.png')),
          TabPage(
              country: 'CANADIAN',
              image: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Flag_of_Canada.svg/1600px-Flag_of_Canada.svg.png')),
        ]),
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  final Image image;
  final String country;

  const TabPage({Key key, this.image, this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WhiskyListModel>(
      create: (_) => WhiskyListModel()..fetchWhisky(country),
      child: Scaffold(
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
                                WhiskyDetailsPage(documentID: whisky.name)),
                      );
                    },
                    title: Image.network(whisky.imageURL),
                  ),
                )
                .toList();
            return GridView.count(
              scrollDirection: Axis.vertical,
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
