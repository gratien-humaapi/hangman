import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangman/ui/colors.dart';
import 'package:hangman/ui/widget/figure_image.dart';
import 'package:hangman/ui/widget/letter.dart';
import 'package:hangman/utils/game.dart';

int entierAleatoire(min, max) {
  var x;
  x = ((Random().nextDouble() * (max - min + 1)) + min).floor();
  return x;
}

class Hangman extends StatefulWidget {
  const Hangman({Key? key}) : super(key: key);

  @override
  _HangmanState createState() => _HangmanState();
}

class _HangmanState extends State<Hangman> {
  String word = 'boîte'.toUpperCase();
  int nombre = 0;
  int find = 0;
  String mot = "";
  bool gameOver = false;
  bool win = false;
  String indice = "";

  List<String> alphabets = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
  ];

  List listDeMots = [];

  readJson() async {
    var response = await rootBundle.loadString('assets/mots.json');
    List data = await jsonDecode(response);

    var list = data[Random().nextInt(data.length - 1)];

    setState(() {
      indice = list["theme"];
    });
    List listOfWords = list["mots"];
    return listOfWords;
  }

  checkWinner(String mot, List entrees) {
    var res = "";
    for (var i = 0; i < mot.length; i++) {
      // ignore: avoid_function_literals_in_foreach_calls
      entrees.forEach((element) {
        if (element == mot[i]) {
          res += mot[i];
        }
      });
    }
    print(res);
    if (res == mot) {
      setState(() {
        win = true;
      });
    }
  }

  @override
  void initState() {
    readJson().then((value) {
      print("value : ${value.length}");
      Game.selectedChar.clear();
      Game.tries = 7;

      setState(() {
        mot = value[entierAleatoire(0, value.length - 1)]
            .toString()
            .toUpperCase();
      });

      // for (var item in value) {
      //   listDeMots.add(item);
      // }
      // print(listDeMots.length);
      // nombre = entierAleatoire(0, listDeMots.length);
      // print(nombre);
      // setState(() {
      //   mot = listDeMots[nombre].toString().toUpperCase();
      // });

      print(mot);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: const Text("Hangman"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                color: Colors.blue,
                height: 180,
                width: double.infinity,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "LIVES",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 3.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          figureImage(Game.tries >= 0, "❤️"),
                          figureImage(Game.tries >= 1, "❤️"),
                          figureImage(Game.tries >= 2, "❤️"),
                          figureImage(Game.tries >= 3, "❤️"),
                          figureImage(Game.tries >= 4, "❤️"),
                          figureImage(Game.tries >= 5, "❤️"),
                          figureImage(Game.tries >= 6, "❤️"),
                          figureImage(Game.tries >= 7, "❤️"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "INDICE: $indice",
                      style: const TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: mot
                .split("")
                .map((e) => letter(e.toUpperCase(),
                    Game.selectedChar.contains(e.toUpperCase())))
                .toList(),
          ),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: const EdgeInsets.all(8),
              children: alphabets.map((e) {
                return RawMaterialButton(
                  onPressed: Game.selectedChar.contains(e)
                      ? null
                      : () {
                          gameOver == false && win == false
                              ? setState(() {
                                  Game.selectedChar.add(e);
                                  print(Game.selectedChar);
                                  checkWinner(mot, Game.selectedChar);
                                  if (win == true) {
                                    settingModalBottomSheet(context, win, mot);
                                  }
                                  if (!mot
                                      .split("")
                                      .contains(e.toUpperCase())) {
                                    Game.tries--;
                                    print(Game.tries);
                                    Game.tries < 0
                                        ? {
                                            gameOver = true,
                                            settingModalBottomSheet(
                                                context, win, mot)
                                          }
                                        : gameOver = false;
                                  }
                                })
                              : null;
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  fillColor: Game.selectedChar.contains(e)
                      ? Colors.black87
                      : Colors.blue,
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.replay),
        onPressed: () {
          settingModalBottomSheet(context, win, mot);
        },
      ),
    );
  }
}

void settingModalBottomSheet(context, win, mot) {
  showModalBottomSheet(
    context: context,
    elevation: 0,
    backgroundColor: Colors.transparent,
    builder: (BuildContext bc) {
      return Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 30,
              left: 90,
              child: Text(
                win == true ? "YOU WIN" : "GAME OVER",
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Positioned(
              top: 90,
              left: 80,
              child: Text(
                "LE MOT ETAIT : $mot",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Center(
                child: TextButton(
                  child: const Text(
                    "▶️",
                    style: TextStyle(
                      fontSize: 50,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const Hangman()),
                        (route) => false);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
    isDismissible: false,
    enableDrag: false,
  );
}
