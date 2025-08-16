import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  Color color = Colors.green;
  bool appear = false;
  bool appearIcon = true;

  int num;

  Notifications(
      {super.key,
        required this.color,
        required this.num,
        required this.appear,
        required this.appearIcon});

  @override
  Widget build(BuildContext context) {
    return appear == true
        ? Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(50)),
      child: Center(
          child: appearIcon==true
              ? Icon(
            Icons.lock_clock,
            color: Colors.white,
            size: 15,
          )
              : Text(
            "${num}",
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          )),
    )
        : Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50)),
    );
  }
}