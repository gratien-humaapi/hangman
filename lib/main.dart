// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman/hangman.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, home: Hangman(),
      //Hangman(),
    );
  }
}

Map meme = {"email": "john@gmail.com", "name": "John"};

class Cool extends StatelessWidget {
  const Cool({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Text(""),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("CLIC"),
          ),
        ],
      ),
    );
  }
}
