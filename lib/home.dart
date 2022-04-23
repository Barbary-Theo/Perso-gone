import 'package:flutter/material.dart';
import 'package:gone/signin.dart';
import 'model/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.userConnected}) : super(key: key);

  final User userConnected;

  @override
  State<HomePage> createState() => _HomePage(userConnected: userConnected);
}

class _HomePage extends State<HomePage> {
  User userConnected;

  @override
  _HomePage({this.userConnected});

  @override
  void initState() {
    print("===>");
  }

  void _logOut() {
    userConnected = null;
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
      body: const Center(
        child: Text("Home Page"),
      ),
    );
  }
}
