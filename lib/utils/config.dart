import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const brickColors = [
  Color(0xfff94144),
  Color(0xfff3722c),
  Color(0xfff8961e),
  Color(0xfff9844a),
  Color(0xfff9c74f),
  Color(0xff9cd9dc),
  Color(0xff90be6d),
  Color(0xff43aa8b),
  Color(0xff4d908e),
  Color(0xff577590),
  Color(0xff277da1),
];

// const gameWidth = 1000.0;
// const gameHeight = 1600.0;
// const ballRadius = gameWidth * 0.02;
// const batWidth = gameWidth * 0.2;
// const batHeight = ballRadius * 2;
// const batStep = gameWidth * 0.05;
// const brickGutter = gameWidth * 0.015;
// final brickWidth =
//     (gameWidth - (brickGutter * (brickColors.length + 1))) / brickColors.length;
// const brickHeight = gameHeight * 0.04;
// const difficultyModifier = 1.03;

// const gameWidth = 820.0;
// const gameHeight = 1600.0;
// const ballRadius = gameWidth * 0.02;
// const batWidth = gameWidth * 0.2;
// const batHeight = ballRadius * 2;
// const batStep = gameWidth * 0.05;
// const brickGutter = gameWidth * 0.015;
// final brickWidth =
//     (gameWidth - (brickGutter * (brickColors.length + 1))) / brickColors.length;
// const brickHeight = gameHeight * 0.03;
// const difficultyModifier = 1.03;

double gameWidth = 1.sw * 0.96; //0.95
double gameHeight = 1.sh > 850
    ? 1.sh * 0.87 //0.85
    : 850 > 1.sh && 1.sh > 750
        ? 1.sh * 0.85
        : 1.sh * 0.90;
double ballRadius = gameWidth * 0.02;
double batWidth = gameWidth * 0.2; //* 0.2;
double batHeight = ballRadius * 2;
double batStep = gameWidth * 0.05;
double brickGutter = gameWidth * 0.015;
double brickWidth =
    (gameWidth - (brickGutter * (brickColors.length + 1))) / brickColors.length;
double brickHeight = gameHeight * 0.04;
double difficultyModifier = 1.03;//1.03;
