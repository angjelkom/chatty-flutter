import 'package:flutter/material.dart';

const BLUE_GRADIENT = LinearGradient(
    begin: FractionalOffset(0.0, 0.4),
    end: FractionalOffset(0.9, 0.7),
    // Add one stop for each color. Stops should increase from 0 to 1
    stops: [
      0.2,
      0.9
    ],
    colors: [
      Color(0xff3d84a7),
      Color(0xff46cdcf),
    ]);
