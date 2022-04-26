
class ToDo{

  String _name = "";
  List<dynamic> _userId = [];
  String _logo = "";

  ToDo(this._name, this._userId, this._logo);

  List<dynamic> get userId => _userId;

  set userId(List<dynamic> value) {
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