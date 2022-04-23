import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gone/signin.dart';
import 'home.dart';
import 'model/User.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  final TextEditingController login = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController password_bis = TextEditingController();

  String errorText = "";

  void _signUp() {
    FirebaseFirestore.instance
        .collection("User")
        .where("login", isEqualTo: login.text.toString())
        .get()
        .then((querySnapshot) async {

      if (login.text.toString().isEmpty ||
          password.text.toString().isEmpty ||
          password_bis.text.toString().isEmpty) {
        setState(() {
          errorText = "🚨 Veuillez remplir tous les champs 🚨";
        });
      } else {
        if(password.text.toString() != password_bis.text.toString()) {
          setState(() {
            errorText = "🚨 Les mots de passe ne sont pas identiques 🚨";
          });
        }
        else {
          if (querySnapshot.docs.isEmpty) {
            _saveNewUser();
            var user = User(login.text.toString(), password.text.toString());
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => HomePage(userConnected: user),
              ),
            );
          }
          else {
            setState(() {
              errorText = "🚨 Login déjà utilisé 🚨";
            });
          }
        }
      }

    });

  }

  void _saveNewUser() async {
    FirebaseFirestore.instance
        .collection("User")
        .add({'login': login.text.toString(), 'password': password.text.toString()});
  }


  void _rootSignIn() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const SigninPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          left: -MediaQuery.of(context).size.width / 1,
          top: MediaQuery.of(context).size.height / 7,
          child: Image.asset(
            "assets/logo_blue.png",
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
                  "assets/logo_red.png",
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
                  height: MediaQuery.of(context).size.height / 15,
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
                          icon: Icon(Icons.man, color: Color(0xff4350B8)),
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
                          icon: Icon(Icons.lock, color: Color(0xff4350B8)),
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
                        controller: password_bis,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock, color: Color(0xff4350B8)),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          filled: false,
                          hintText: "Encore une fois 😉",
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
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: ElevatedButton(
                    onPressed: () async {
                      _signUp();
                    },
                    child: const Text(
                      "S'inscrire",
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
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: ElevatedButton(
                    onPressed: () {
                      _rootSignIn();
                    },
                    child: const Text(
                      "Go se connecter !",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFD04848)),
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
