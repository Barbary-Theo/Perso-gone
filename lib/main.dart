import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:gone/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'model/User.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyApmarJW0QN3kR3VbkffxHhdqClKLJq2ow",
        appId: "1:8136892067:android:43a30fdf6c5e987a9be916",
        messagingSenderId: "XXX",
        projectId: "gone-b899a",
      ),
      name: "Gone"
  );

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  var prefs = await SharedPreferences.getInstance();
  var login = prefs.getString("login");
  var password = prefs.getString("password");

  print(" ==== $login ==== $password");

  runApp(MyApp.init(login, password));
}

class MyApp extends StatelessWidget {
  MyApp({Key key, String login, String password}) : super(key: key);

  SharedPreferences prefs;
  String login = "";
  String password = "";

  MyApp.init(this.login, this.password, {Key key}) : super(key: key);

  Widget getFirstPage() {

    if(login != null && login.isNotEmpty &&
        password != null && password.isNotEmpty) {
      return HomePage(userConnected: User(login, password));
    }
    else {
      return const SigninPage();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: getFirstPage()
    );
  }
}
