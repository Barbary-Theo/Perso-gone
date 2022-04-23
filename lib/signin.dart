import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gone/signup.dart';

import 'home.dart';
import 'model/User.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPage();
}

class _SigninPage extends State<SigninPage> {
  final TextEditingController login = TextEditingController();
  final TextEditingController password = TextEditingController();

  String errorText = "";

  void _rootSignUp() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const SignupPage(),
      ),
    );
  }


  void _signIn() {

    FirebaseFirestore.instance
        .collection("User")
        .where("login", isEqualTo: login.text.toString())
        .where("password", isEqualTo: password.text.toString())
        .get()
        .then((querySnapshot) {

          if (querySnapshot.docs.isEmpty) {
            setState(() {
              errorText = "🚨 Identifiant ou mot de passe incorrect 🚨";
            });
          }
          else {
            var user = User(login.text.toString(), password.text.toString());
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => HomePage(userConnected: user),
              ),
            );
          }

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          left: -MediaQuery.of(context).size.width / 1,
          top: MediaQuery.of(context).size.height /7,
          child: Image.asset(
            "assets/logo_red.png",
            scale: 5,
          ),
        ),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                /* Logo */
                Image.asset(
                  "assets/logo_blue.png",
                  scale: 20,
                ),
                const Text(
                  "Gone",
                  style: TextStyle(
                    color: Color(0xFF616161),
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Material(
                    elevation: 3,
                    shadowColor: Colors.grey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: TextField(
                        controller: login,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.man, color: Color(0xffD04848)),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          filled: false,
                          hintText: "Identifiant",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Material(
                    elevation: 3,
                    shadowColor: Colors.grey,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: TextField(
                        controller: password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock, color: Color(0xffD04848)),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          filled: false,
                          hintText: "Mot de passe",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    onPressed: () async {
                      _signIn();
                    },
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(color: Color(0xFF616161)),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
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
                Text(
                  errorText,
                  style: const TextStyle(
                    color: Color(0xFF616161),
                    fontWeight: FontWeight.bold,
                  ),
                ),                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    onPressed: () {
                      _rootSignUp();
                    },
                    child: const Text(
                      "Go s'inscrire !",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF4350B8)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                const Text(
                  "By BARBARY, version : 1.0.0",
                  style: TextStyle(color: Color(0xFF616161)),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
