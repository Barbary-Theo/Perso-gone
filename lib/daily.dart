import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'home.dart';
import 'model/Task.dart';
import 'model/ToDo.dart';
import 'model/User.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key key, this.userConnected, this.idUser, this.colorByLogo}) : super(key: key);

  final User userConnected;
  final String idUser;
  final Map<String, Color> colorByLogo;

  @override
  State<DailyPage> createState() =>
      _DailyPage(userConnected: userConnected, idUser: idUser, colorByLogo: colorByLogo);
}

class _DailyPage extends State<DailyPage> {
  User userConnected;
  String idUser;
  Map<String, Color> colorByLogo;

  bool loading = true;

  List<Task> taskToDoToday = [];
  Map<ToDo, List<Task>> mapTaskToDay = {};

  @override
  _DailyPage({this.userConnected, this.idUser, this.colorByLogo});

  void _goToHome() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            HomePage(userConnected: userConnected),
      ),
    );
  }

  @override
  void initState() {
    _getTaskToDo();
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

  void _getTaskToDo() async {
    Map<ToDo, List<Task>> dataTable = {};

    await FirebaseFirestore.instance
        .collection("ToDo")
        .where("userId", arrayContains: idUser)
        .where("hide", isEqualTo: false)
        .get()
        .then((querySnapshot) async {
      for (var result in querySnapshot.docs) {

        ToDo currentToDo = ToDo(
            result.get("name"),
            result.get("userId"),
            result.get("logo"),
            result.get("hide"),
            result.get("creationDate").toDate());
        List<Task> currentTaskList = [];
        dataTable.putIfAbsent(currentToDo, () => currentTaskList);

        await FirebaseFirestore.instance
            .collection("Task")
            .where("toDoId", isEqualTo: result.id)
            .where("done", isEqualTo: false)
            .where("hide", isEqualTo: false)
            .get()
            .then((querySnapshot) {

          for (var result in querySnapshot.docs) {

            DateTime date = result.get("date").toDate();
            if (_formatDate(date) == _formatDate(DateTime.now())) {
              dataTable[currentToDo].add(Task(
                  result.get("name"),
                  date,
                  result.get("toDoId"),
                  result.get("hide"),
                  result.get("ratiox"),
                  result.get("ratioy"),
                  result.get("done"),
                  result.get("dateDone") == null
                      ? null
                      : result.get("dateDone").toDate()));
            }

          }

          if(dataTable[currentToDo].isEmpty) {
            dataTable.remove(currentToDo);
          }

        });

      }
    });

    setState(() {
      loading = false;
      mapTaskToDay = dataTable;
    });
  }

  Column _displayTaskToDo() {

    List<Widget> dataTable = [];
    dataTable.add(
      SizedBox(
        height: MediaQuery.of(context).size.height / 80,
      ),
    );

    mapTaskToDay.forEach((key, value) {

      List<Widget> taskByLogo = [];

      taskByLogo.add(
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
      );
      taskByLogo.add(
        Center(
          child: Text(
              "Todo ${key.name} ${key.logo}",
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF616161),
              ),
          ),
        ),
      );
      taskByLogo.add(
        SizedBox(
          height: MediaQuery.of(context).size.height / 80,
        ),
      );
      for (var element in value) {
        taskByLogo.add(
            Text(
                "\u2022 " + element.name,
                style: const TextStyle(
                  color: Color(0xFF616161),
                  fontSize: 15,
                ),
            )
        );
      }
      taskByLogo.add(
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
      );

      dataTable.add(
        SizedBox(
          child: Card(
            color: colorByLogo[key.logo],
            child: Column(
              children: taskByLogo,
            )
          )
        )
      );
    });

    return Column(
      children: dataTable,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    _goToHome();
                  },
                  child: const Icon(
                    Icons.keyboard_return,
                    color: Color(0xFFC81818),
                    size: 30,
                  ),
                )),
              ),
              const Positioned(
                child: Center(
                  child: Text(
                    "Les tâches du jour 🎯",
                    style: TextStyle(
                      color: Color(0xFF616161),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
      body: loading
          ? const Center(
              child: SpinKitChasingDots(
              color: Color(0xFFC81818),
              size: 25.0,
            ))
          : mapTaskToDay.isEmpty
              ? const Center(
                  child: Text(
                      "Vous êtes tranquille pour aujourd'hui, profitez ! 🛁"),
                )
              : _displayTaskToDo(),
    );
  }
}
