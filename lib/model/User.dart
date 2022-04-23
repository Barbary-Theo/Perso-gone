
class User{

  String _login = "";
  String _password = "";

  User(this._login, this._password);

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get login => _login;

  set login(String value) {
    _login = value;
  }
}