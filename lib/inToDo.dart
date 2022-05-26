import 'package:flutter/material.dart';
import 'package:gone/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/Task.dart';
import 'model/User.dart';
import 'model/ToDo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class inToDo extends StatefulWidget {
  const inToDo({Key key, this.userConnected, this.idUser, this.idToDo, this.currentToDo}) : super(key: key);

  final User userConnected;
  final ToDo currentToDo;
  final String idUser;
  final String idToDo;

  @override
  State<inToDo> createState() => _inToDo(userConnected: userConnected, currentToDo: currentToDo, idUser: idUser, idToDo: idToDo);
}

class _inToDo extends State<inToDo> {
  User userConnected;
  ToDo currentToDo;
  String idUser = "";
  String idToDo = "";
  DateTime selectedDate = DateTime.now();

  bool loading = true;
  List<Task> allTask = [];
  List<Widget> allTaskToDisplay = [];
  List<Color> taskColor = [];

  final TextEditingController task = TextEditingController();
  final TextEditingController login = TextEditingController();

  @override
  _inToDo({this.userConnected, this.currentToDo, this.idUser, this.idToDo});

  @override
  void initState() {
    _getAllToDoTask();
  }

  void _goBack() async {
    idToDo = null;
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => HomePage(userConnected: userConnected),
      ),
    );
  }

  void _getAllToDoTask() {
    allTask = [];
    taskColor = [];

    FirebaseFirestore.instance
        .collection('Task')
        .where("toDoId", isEqualTo: idToDo)
        .where("hide", isEqualTo: false)
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        allTask.add(Task(result.get("name"), result.get("date").toDate(),
            result.get("toDoId"), result.get("hide"), result.get("ratiox"),
            result.get("ratioy"), result.get("done"),
            result.get("dateDone") == null ? result.get("dateDone") : result.get("dateDone").toDate()));
        taskColor.add(_getCardColor(result.get("done")));
      }

      _getAllToDoTaskToDisplay();

    });
  }

  void _updateTaskWhenMoved(Task task) {
    FirebaseFirestore.instance
        .collection("Task")
        .where("toDoId", isEqualTo: idToDo)
        .where("name", isEqualTo: task.name)
        .where("date", isEqualTo: task.date)
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        FirebaseFirestore.instance
            .collection("Task")
            .doc(result.id)
            .update({"ratiox": task.ratiox});
        FirebaseFirestore.instance
            .collection("Task")
            .doc(result.id)
            .update({"ratioy": task.ratioy});
      }
    });
  }

  Color _getCardColor(bool value) {
    if(value) {
        return const Color(0xFFD7DDEB);
    }
    return const Color(0xFFF3BBB4);
  }

  Color getColor(Set<MaterialState> states) {
    return const Color(0xFF616161);
  }

  Widget _displayOneTask(Task task, int index) {

    return Positioned(
        top: task.ratioy * MediaQuery.of(context).size.height,
        left: task.ratiox * MediaQuery.of(context).size.width,
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails dd) {
            setState(() {
              allTask.elementAt(index).ratioy = (dd.globalPosition.dy -
                  MediaQuery.of(context).size.height / 5.5) / MediaQuery.of(context).size.height;
              allTask.elementAt(index).ratiox = (dd.globalPosition.dx -
                  MediaQuery.of(context).size.width / 4 ) / MediaQuery.of(context).size.width;
              _displayThisTask(index);
              //_getAllToDoTaskToDisplay();
            });
          },
          onVerticalDragEnd: (DragEndDetails dd) {
            _updateTaskWhenMoved(task);
          },
          child: SizedBox(
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width / 2.2,
              child: Card(
                color: taskColor.elementAt(index),
                child: Stack(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: task.done,
                        onChanged: (bool value) async {
                            await FirebaseFirestore.instance
                                .collection("Task")
                                .where("toDoId", isEqualTo: idToDo)
                                .where("name", isEqualTo: task.name)
                                .where("date", isEqualTo: task.date)
                                .get()
                                .then((querySnapshot) {
                              for (var result in querySnapshot.docs) {
                                FirebaseFirestore.instance
                                    .collection("Task")
                                    .doc(result.id)
                                    .update({"done": value});
                                if(value) {
                                  FirebaseFirestore.instance
                                      .collection("Task")
                                      .doc(result.id)
                                      .update({"dateDone": DateTime.now()});
                                }
                                else {
                                  FirebaseFirestore.instance
                                      .collection("Task")
                                      .doc(result.id)
                                      .update({"dateDone": null});
                                }
                              }
                            });
                            _getAllToDoTask();
                        }
                    ),
                    Center(
                      child: Text(
                        task.name,
                        style: const TextStyle(
                          color: Color(0xFF616161),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          alignment: Alignment.topRight,
                          constraints: const BoxConstraints(
                              minHeight: 1, minWidth: 1),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection("Task")
                                .where("toDoId", isEqualTo: idToDo)
                                .where("name", isEqualTo: task.name)
                                .where("date", isEqualTo: task.date)
                                .get()
                                .then((querySnapshot) {
                              for (var result in querySnapshot.docs) {
                                FirebaseFirestore.instance
                                    .collection("Task")
                                    .doc(result.id)
                                    .update({"hide": true});
                              }
                            });
                            _getAllToDoTask();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF616161),
                          )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Pour le ${_formatDate(task.date)}",
                        style: const TextStyle(
                          color: Color(0xFF616161),
                          fontSize: 11,
                        ),
                      )
                    ),
                  ],
                ),
              ),
          ),
        ),
      );

  }

  String _formatDate(DateTime date) {

    if (date != null) {
      var day = date.day.toString();
      var month = date.month.toString();
      var year = date.year.toString();

      day.length == 1 ? day = "0" + day : day = day;
      month.length == 1 ? month = "0" + month : month = month;

      return day + "/" + month + "/" + year;
    }
    return "-";
  }

  void _displayThisTask(int index) {

    List<Widget> dataTable = allTaskToDisplay;
    dataTable[index] = _displayOneTask(allTask.elementAt(index), index);

    setState(() {
      allTaskToDisplay = dataTable;
    });

  }

  void _getAllToDoTaskToDisplay() {

    List<Widget> dataTable = [];
    allTaskToDisplay = [];

    for(int i = 0 ; i < allTask.length ; i++) {
      dataTable.add(
          _displayOneTask(allTask.elementAt(i), i)
        );
    }

    setState(() {
      loading = false;
      allTaskToDisplay = dataTable;
    });

  }

  void _addTask() {
    FirebaseFirestore.instance
        .collection('Task')
        .add({"name": task.text.toString(), "date": selectedDate, "toDoId": idToDo, "hide": false, "ratiox": 0.0, "ratioy": 0.0, "done": false, "dateDone": null});

    _getAllToDoTask();
    selectedDate = DateTime.now();
  }

  void _addUser() {
    FirebaseFirestore.instance
        .collection('User')
        .where("login", isEqualTo: login.text.toString())
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        List<dynamic> users = currentToDo.userId;
        users.add(result.id);
        FirebaseFirestore.instance
            .collection("ToDo")
            .doc(idToDo)
            .update({"userId": users});
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Colors.white, actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: MediaQuery.of(context).size.width / 50,
                top: MediaQuery.of(context).size.height / 50,
                child: Center(
                    child: GestureDetector(
                      onTap: () {
                        _goBack();
                      },
                      child: const Icon(
                        Icons.keyboard_return,
                        color: Color(0xFFC81818),
                        size: 30,
                      ),
                    )),
              ),
              Positioned(
                child: Center(
                  child: Text(
                    "~ " + currentToDo.name + " " + currentToDo.logo + " ~",
                    style: const TextStyle(
                      color: Color(0xFF616161),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width / 50,
                top: MediaQuery.of(context).size.height / 50,
                child: Center(
                    child: GestureDetector(
                      onTap: () {
                        _showModalAddUser(context);
                      },
                      child: const Icon(
                        Icons.man,
                        color: Color(0xFF4350B8),
                        size: 30,
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ]),
      body: loading ? const Center(
          child: SpinKitChasingDots(
            color: Color(0xFFC81818),
            size: 25.0,
          )
        )
      : allTask.isEmpty ? const Center(
        child: Text("Aucune tâche pour cette To Do 📭"),
      )
      : Stack(
        children: allTaskToDisplay,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModalCreateTask(context);
        },
        backgroundColor: const Color(0xFF4350B8),
        child: const Icon(Icons.add),
      ),
    );
  }

  _showModalCreateTask(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 1.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      controller: task,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "Nom de la tâche",
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            onChanged: (date) {}, onConfirm: (date) {
                              selectedDate = date;
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.fr);
                      },
                      child: const Text(
                        "Choisir une date",
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(const Color(0xFF616161)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD04848),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                      child: TextButton(
                        child: const Text(
                          "Ajouter la tâche",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          _addTask();
                          task.text = "";
                          Navigator.pop(context, false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showModalAddUser(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 1.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
                  ),
                  const Center(
                    child: Text(
                        "Ajout d'un utilisateur",
                      style: TextStyle(
                        color:  Color(0xFF616161),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      controller: login,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "Login de l'utilisateur",
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4350B8),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                      child: TextButton(
                        child: const Text(
                          "Ajouter l'utilisateur",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          _addUser();
                          login.text = "";
                          Navigator.pop(context, false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

}
