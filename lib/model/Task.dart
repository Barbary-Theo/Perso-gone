
class Task{

  String _name = "";
  DateTime _date = DateTime.now();
  String _toDoId = "";
  bool _hide = false;

  Task(this._name, this._date, this._toDoId, this._hide);

  String get toDoId => _toDoId;

  set toDoId(String value) {
    _toDoId = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  bool get hide => _hide;

  set hide(bool value) {
    _hide = value;
  }
}