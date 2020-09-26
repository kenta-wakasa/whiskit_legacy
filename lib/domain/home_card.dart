class HomeCard {
  // レビュー情報
  String reviewID = '';

  // ユーザー情報
  String uid = '';
  String avatarPhotoURL = '';
  String userName = '';

  // ウィスキー情報
  String whiskyID;
  String whiskyImageURL;
  String whiskyName;

  // 本文
  String text = '';

  // 自分がお気に入り登録しているか
  bool isFavorite = false;
  // お気に入りの数
  int favoriteCount = 0;

  HomeCard(
    this.reviewID,
    this.uid,
    this.avatarPhotoURL,
    this.userName,
    this.whiskyID,
    this.whiskyImageURL,
    this.whiskyName,
    this.text,
    this.isFavorite,
    this.favoriteCount,
  );
}
