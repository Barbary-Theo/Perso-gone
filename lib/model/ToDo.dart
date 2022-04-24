
class ToDo{

  String _name = "";
  String _userId = "";

  ToDo(this._name, this._userId);

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}