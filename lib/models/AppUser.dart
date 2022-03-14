class AppUser {
  String uid;
  Map data;
  Map type;

  AppUser({this.uid, this.data, this.type});

  setAppUser(String uid, Map data, Map type) {
    this.uid = uid;
    this.data = data;
    this.type = type;
  }
}
