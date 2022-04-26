
class ToDo{

  String _name = "";
  List<dynamic> _userId = [];
  String _logo = "";
  bool _hide = false;
  DateTime _creationDate = DateTime.now();

  ToDo(this._name, this._userId, this._logo, this._hide, this._creationDate);

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

  bool get hide => _hide;

  set hide(bool value) {
    _hide = value;
  }
  DateTime get creationDate => _creationDate;

  set creationDate(DateTime value) {
    _creationDate = value;
  }
}