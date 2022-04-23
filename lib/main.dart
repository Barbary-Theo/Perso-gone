import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gone/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyApmarJW0QN3kR3VbkffxHhdqClKLJq2ow",
        appId: "1:8136892067:android:43a30fdf6c5e987a9be916",
        messagingSenderId: "XXX",
        projectId: "gone-b899a",
      ),
      name: "Gone"
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SigninPage(),
    );
  }
}
