
class Task{

  String _name = "";
  DateTime _date = DateTime.now();
  String _toDoId = "";
  bool _hide = false;
  bool _done = true;
  double _ratiox = 0;
  double _ratioy = 0;

  Task(this._name, this._date, this._toDoId, this._hide, this._ratiox, this._ratioy, this._done);

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

  bool get done => _done;

  set done(bool value) {
    _done = value;
  }

  double get ratiox => _ratiox;

  set ratiox(double value) {
    _ratiox = value;
  }

  double get ratioy => _ratioy;

  set ratioy(double value) {
    _ratioy = value;
  }
}