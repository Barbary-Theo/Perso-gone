import 'dart:math';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gone/signin.dart';
import 'package:gone/inToDo.dart';

import 'model/User.dart';
import 'model/ToDo.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key key, this.userConnected}) : super(key: key);

  final User userConnected;

  @override
  State<HomePage> createState() => _HomePage(userConnected: userConnected);
}

class _HomePage extends State<HomePage> {
  User userConnected;
  String idUser = "";
  bool loading = true;

  List<Widget> toDoToDisplay = [];
  List<String> randomLogoList = ["👾", "🐱", "🍄", "🌵", "🌷", "🌼", "☄️", "🌎", "💫", "⚡️",
    "🌈", "☂️", "🥝", "⚽️", "🎯", "🎮", "⏰", "🔭", "🎁", "✏️", "🤖", "👒", "👑", "🦖",
    "🦕", "🦬", "🌙"];

  final TextEditingController todo = TextEditingController();
  SharedPreferences prefs;

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
        }
      });

      setState(() {
        loading = false;
        toDoToDisplay = dataTable;
      });

  }

  void _goInTodo(toDo) {
    var currentToDo = ToDo(toDo.get("name"), toDo.get("userId"), toDo.get("logo"));
    Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
        builder: (BuildContext context) => inToDo(
          userConnected: userConnected,
          currentToDo: currentToDo,
          idUser: idUser,
          idToDo: toDo.id)
    ));

  }

  Widget setUpToDo(toDo) {

    return GestureDetector(
      onTap: () {
        _goInTodo(toDo);
      },
      child: Container(
          height: MediaQuery.of(context).size.height /10,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height /50),
          child: Center(
            child: Card(
              elevation: 1,
              color: const Color(0xFFF4F5FC),
              margin:  EdgeInsets.only(right: MediaQuery.of(context).size.width /100, left: MediaQuery.of(context).size.width /100),
              child: Stack(
                children: [
                  Positioned(
                    left: MediaQuery.of(context).size.width /25,
                    top: MediaQuery.of(context).size.height /35,
                    child: Text(
                        toDo.get("logo"),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                    ),
                  ),
                  Center(
                    child: Text(toDo.get("name").toString())
                  ),
                  Positioned(
                    right: MediaQuery.of(context).size.width /25,
                    top: MediaQuery.of(context).size.height /70,
                    child: IconButton(
                        onPressed: () {
                          _removeTodo(toDo);
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFC81818),
                        )
                    ),
                  )
                ],
              ),
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
    var rand = Random();
    FirebaseFirestore.instance
        .collection('ToDo')
        .add({'name': todo.text.toString(), 'userId': idUser, 'logo': randomLogoList.elementAt(rand.nextInt(randomLogoList.length - 1))});

    _getToDoToDisplay();
  }

  void _removeTodo(toDo) async {

      await FirebaseFirestore.instance
          .collection('Task')
          .where("toDoId", isEqualTo: toDo.id)
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          FirebaseFirestore.instance
              .collection("Task")
              .doc(result.id)
              .delete();
        }
      });

      FirebaseFirestore.instance
          .collection("ToDo")
          .doc(toDo.id)
          .delete();

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
                    color: Color(0xFFC81818),
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
            color: Color(0xFFC81818),
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
