import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ignore: non_constant_identifier_names
Decoration ShimmerBoxDecoration(animation, {isCircle = false, double radius = 8}) {
  var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;

  return BoxDecoration(
    shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
    borderRadius: isCircle == false ? BorderRadius.circular(radius) : null,
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: isDarkMode
          ? const [
              Color(0xff272D30),
              Color(0xff40494F),
              Color(0xff272D30),
            ]
          : const [
              Color(0xfff4f4f4),
              Color(0xffe9ebee),
              Color(0xfff4f4f4),
            ],
      stops: [
        animation.value - 1,
        animation.value,
        animation.value + 1,
      ],
    ),
  );
}
