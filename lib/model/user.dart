class UserInformation {

  String? uid;
  String? name;
  String? email;
  String? _password;

  UserInformation({this.uid, this.name, this.email, String? password}) {
    _password = password;
  }

  String get password => _password ?? '';
}
