import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MailSignupModel extends ChangeNotifier {
  String mail = '';
  String password = '';
  String userName = '';
  String avatarPhotoURL =
      'https://firebasestorage.googleapis.com/v0/b/whiskit-7699f.appspot.com/o/users%2FdefaultUserIcon.jpg?alt=media&token=c12e1323-ec81-4adf-972b-204932f8e330';
  String uid = '';
  File imageFile;
  bool isUploading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future Signup() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }

    // ToDo: パスワードのバリデーションを書く
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    if (userName.isEmpty) {
      throw ('名前を入力してください');
    }
    // ユーザー新規登録
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ('6文字以上にしてください');
      } else if (e.code == 'email-already-in-use') {
        throw ('このメールアドレスは登録済みです');
      }
    } catch (e) {
      throw (e.toString());
    }
    //Firebaseのuser id取得
    User user = FirebaseAuth.instance.currentUser;
    this.uid = user.uid;

    // 端末にuidを保存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);

    // 画像が変更されている場合のみ実行する
    if (this.imageFile != null) {
      this.avatarPhotoURL = await _upLoadImage();
    }
    // user情報を保存
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(this.uid)
        .set(
          {
            'userName': this.userName,
            'avatarPhotoURL': this.avatarPhotoURL,
          },
        )
        .then((value) => print("User Added"))
        .catchError(
          (error) => print("Failed to add user: $error"),
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
