import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiskit_app/domain/whisky.dart';
import 'package:whiskit_app/presentation/edit_profile/edit_profile_page.dart';
import 'package:whiskit_app/presentation/whisky_details/whisky_details_page.dart';
import 'my_model.dart';

class MyPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'マイページ',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      home: ChangeNotifierProvider<MyModel>(
        create: (_) => MyModel()..getMyInfo(),
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              backgroundColor: Colors.black54,
              title: Text(
                'マイページ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          body: Consumer<MyModel>(builder: (context, model, child) {
            return model.isLoading
                ? Center(child: Container(child: CircularProgressIndicator()))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        model.users.avatarPhotoURL),
                                    maxRadius: 24,
                                  ),
                                ),
                                Text(
                                  model.users.userName,
                                  style: _textStyle(12),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 64,
                              child: Column(
                                children: [
                                  Text(
                                    model.reviewCount.toString(),
                                    style: _textStyle(24),
                                  ),
                                  Text(
                                    '投稿',
                                    style: _textStyle(8),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 64,
                              child: Column(
                                children: [
                                  Text(
                                    model.favoriteCount.toString(),
                                    style: _textStyle(24),
                                  ),
                                  Text(
                                    'いいね',
                                    style: _textStyle(8),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 64,
                              child: Column(
                                children: [
                                  Text(
                                    model.drankWhiskyCount.toString(),
                                    style: _textStyle(24),
                                  ),
                                  Text(
                                    '飲んだウイスキー',
                                    style: _textStyle(8),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 56,
                                child: FlatButton(
                                  minWidth: 12,
                                  height: 32,
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            // EditProfilePage(),
                                            EditProfilePage(),
                                        fullscreenDialog: true,
                                      ), //以下を追加
                                    );
                                    await model.getMyInfo();
                                  },
                                  child: Text(
                                    '編集',
                                    style: _textStyle(10),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    side: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              '飲んできたウイスキー',
                              style: TextStyle(fontSize: 10),
                            ),
                            Expanded(child: SizedBox())
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Expanded(
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                childAspectRatio: 2 / 5,
                              ),
                              itemCount: model.whisky.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _whiskyCard(
                                    context, model.whisky[index]);
                              }),
                        ),
                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }

  TextStyle _textStyle(double fontSize) {
    final size = fontSize;
    return TextStyle(
      fontSize: size,
    );
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
