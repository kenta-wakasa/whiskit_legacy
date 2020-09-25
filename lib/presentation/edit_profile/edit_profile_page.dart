import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile_model.dart';

class EditProfilePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditProfileModel>(
      create: (_) => EditProfileModel()..getUserInfo(),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Colors.black54,
            title: Text(
              '編集',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Consumer<EditProfileModel>(builder: (context, model, child) {
          return model?.user?.avatarPhotoURL == null
              ? Container()
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              model?.imageFile == null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          model?.user?.avatarPhotoURL),
                                      maxRadius: 48,
                                    )
                                  : CircleAvatar(
                                      backgroundImage: FileImage(
                                        model?.imageFile,
                                      ),
                                      maxRadius: 48,
                                    ),
                              RawMaterialButton(
                                onPressed: () {
                                  model.showImagePicker();
                                },
                                child: Container(
                                  width: 96.0, // CircleAvatarのradiusの2倍
                                  height: 96.0,
                                ),
                                shape: new CircleBorder(),
                                elevation: 0.0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.bottom,
                            textAlign: TextAlign.center,
                            initialValue: model.user.userName,
                            onChanged: (text) {
                              model.user.userName = text;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RaisedButton(
                            onPressed: () async {
                              try {
                                await model.updateUserInfo();
                                await _showDialog(context, '更新しました！');
                                Navigator.of(context).pop();
                              } catch (e) {
                                await _showDialog(context, e.toString());
                              }
                            },
                            child: Text('更新する'),
                          ),
                        ),
                      ],
                    ),
                    model.isUploading
                        ? Container(
                            color: Colors.grey.withOpacity(0.7),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Center(
                            child: SizedBox(),
                          ),
                  ],
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
