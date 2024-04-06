import 'package:flutter/material.dart';

Widget figureImage(bool visible, path) {
  return Visibility(
    visible: visible,
    child: Text(
      path,
      style: const TextStyle(
        fontSize: 30,
      ),
    ),
  );
}
