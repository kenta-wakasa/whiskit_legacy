import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/domain/home_card.dart';
import 'package:whiskit_app/presentation/whisky_details/whisky_details_page.dart';
import 'home_model.dart';

// テンプレート
class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
        create: (_) => HomeModel()..fetchWhiskyReview(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              backgroundColor: Colors.black54,
              title: Text(
                'ホーム',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          body: Consumer<HomeModel>(
            builder: (context, model, child) {
              final homeCard = model.homeCard;
              return homeCard.length == 0
                  ? Center(child: Container(child: CircularProgressIndicator()))
                  : ListView.builder(
                      itemCount: homeCard.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _reviewCard(homeCard[index], model, context);
                      });
            },
          ),
        ));
  }

  Widget _reviewCard(HomeCard homeCard, HomeModel model, BuildContext context) {
    return Card(
      elevation: 2.0,
      margin:
          const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 0.0, left: 8.0),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WhiskyDetailsPage(
                documentID: homeCard.whiskyID,
                name: homeCard.whiskyName,
              ),
            ),
          );
          await model.fetchWhiskyReview();
        },
        child: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, right: 16.0, bottom: 16.0, left: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(homeCard.avatarPhotoURL),
                        maxRadius: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          homeCard.userName,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: IconButton(
                          splashRadius: 16,
                          icon: Icon(
                            homeCard.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                          ),
                          onPressed: () async {
                            await model.changeFavorite(
                              homeCard,
                            );
                          },
                        ),
                      ),
                      Text(homeCard.favoriteCount.toString()),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    homeCard.whiskyImageURL,
                    width: 40,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          homeCard.whiskyName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          homeCard.text,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
