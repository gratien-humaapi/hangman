import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hangman/ui/colors.dart';

Widget letter(String character, bool hidden) {
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Container(
      height: 35,
      width: 20,
      decoration: BoxDecoration(
        color: AppColor.primaryColorDark,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Visibility(
        visible: hidden,
        child: Center(
          child: Text(
            character,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    ),
  );
}
