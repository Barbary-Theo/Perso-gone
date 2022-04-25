
class ToDo{

  String _name = "";
  String _userId = "";
  String _logo = "";

  ToDo(this._name, this._userId, this._logo);

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get logo => _logo;

  set logo(String value) {
    _logo = value;
  }
}