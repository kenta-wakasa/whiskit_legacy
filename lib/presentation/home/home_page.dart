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
              return ListView.builder(
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
              ));
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
                          style: TextStyle(fontSize: 12),
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
                            model.changeFavorite(
                              homeCard.reviewID,
                            );
                            homeCard.isFavorite = !homeCard.isFavorite;
                          },
                        ),
                      ),
                      Text('120'),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    homeCard.whiskyImageURL,
                    width: 64,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
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
                        height: 12,
                      ),
                      Text(homeCard.text),
                    ],
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
