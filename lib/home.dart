import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gone/signin.dart';
import 'model/User.dart';
import 'model/ToDo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.userConnected}) : super(key: key);

  final User userConnected;

  @override
  State<HomePage> createState() => _HomePage(userConnected: userConnected);
}

class _HomePage extends State<HomePage> {
  User userConnected;
  String idUser = "";
  final TextEditingController todo = TextEditingController();
  SharedPreferences prefs;
  List<Widget> toDoToDisplay = [];
  bool loading = true;
  double oi = 350;


  @override
  _HomePage({this.userConnected});

  void saveLog() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('login', userConnected.login);
    await prefs.setString('password', userConnected.password);
  }

  @override
  void initState() {
    saveLog();

    FirebaseFirestore.instance
        .collection('User')
        .where("login", isEqualTo: userConnected.login)
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        idUser = result.id;
      }
      _getToDoToDisplay();

    });
  }


  void _getToDoToDisplay() async {

      List<Widget> dataTable = [];

      await FirebaseFirestore.instance
          .collection('ToDo')
          .where("userId", isEqualTo: idUser)
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          dataTable.add(
            setUpToDo(result)
          );
          dataTable.add(
              const Divider(
                height: 3.5,
              )
          );
        }
      });

      setState(() {
        loading = false;
        toDoToDisplay = dataTable;
      });

  }

  Widget setUpToDo(toDo) {

    return GestureDetector(
      child: Container(
        width: oi,
        height: MediaQuery.of(context).size.height /10,
        child: Card(
          margin: const EdgeInsets.all(0),
         child: Center(
           child: Text(toDo.get("name").toString()),
         ),
        )
      ),
    );

  }

  void _logOut() async {
    await prefs.remove('login');
    await prefs.remove('password');

    userConnected = null;
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const SigninPage(),
      ),
    );
  }

  void _createTodo() {
    FirebaseFirestore.instance
        .collection('ToDo')
        .add({'name': todo.text.toString(), 'userId': idUser});

    _getToDoToDisplay();
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
                    _logOut();
                  },
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                )),
              ),
              Positioned(
                child: Center(
                  child: Text(
                    "Bonjour " + userConnected.login + " 🎉",
                    style: const TextStyle(
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
      body: loading ? const Center(
          child: SpinKitChasingDots(
            color: Colors.red,
            size: 25.0,
        )
      )
      : toDoToDisplay.isEmpty ? const Center(
        child: Text("Vous avez aucune de ToDo 🔎"),
      )
      : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              children: toDoToDisplay,
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModalCreateTodo(context);
        },
        backgroundColor: const Color(0xFF4350B8),
        child: const Icon(Icons.add),
      ),
    );
  }

  _showModalCreateTodo(context) {
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
                      controller: todo,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "Nom de la To Do",
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
                        color: Color(0xFFD04848),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                      child: TextButton(
                        child: const Text(
                          "Ajouter la To Do",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                            _createTodo();
                            todo.text = "";
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
