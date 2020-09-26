import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whiskit_app/domain/users.dart';

class EditProfileModel extends ChangeNotifier {
  File imageFile;
  Users user;
  String uid = FirebaseAuth.instance.currentUser.uid;
  bool isUploading = false;

  Future getUserInfo() async {
    final docUsers =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    this.user = Users(
      docUsers.data()['avatarPhotoURL'],
      docUsers.data()['userName'],
    );
    notifyListeners();
  }

  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final pickedImage = File(pickedFile.path);

    // 画像をアス比1:1で切り抜く
    if (pickedImage != null) {
      this.imageFile = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.png,
        compressQuality: 10,
        iosUiSettings: IOSUiSettings(
          title: '編集',
        ),
      );
    }
    notifyListeners();
  }

  // ユーザー情報をアップデートする
  Future updateUserInfo() async {
    // 画像が変更されている場合のみ実行する
    if (this.imageFile != null) {
      user.avatarPhotoURL = await _upLoadImage();
    }

    // userNameのバリデーション
    if (user.userName.isEmpty) {
      throw ('名前を入力してください');
    }

    // users情報の更新
    final userDoc = FirebaseFirestore.instance.collection('users');
    return userDoc.doc(this.uid).update(
      {
        'userName': user.userName,
        'avatarPhotoURL': user.avatarPhotoURL,
      },
    );
  }

  //Firestoreにアップロードする
  Future<String> _upLoadImage() async {
    this.isUploading = true;
    notifyListeners();
    // ストレージへのアップロード
    final storage = FirebaseStorage.instance;
    StorageTaskSnapshot snapshot = await storage
        .ref()
        .child('users/$uid.png')
        .putFile(this.imageFile)
        .onComplete;
    final String downloadURL = await snapshot.ref.getDownloadURL();
    this.isUploading = false;
    notifyListeners();
    return downloadURL;
  }
}
