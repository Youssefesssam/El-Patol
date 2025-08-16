import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class WeekUser  extends StatefulWidget {
  WeekUser ({super.key});

  @override
  State<WeekUser > createState() => _WeekState();
}

class _WeekState extends State<WeekUser > {

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {


    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  colors: [
                    Colors.teal[800]!,
                    Colors.teal[600]!,
                    Colors.cyan[700]!,
                    Colors.cyan[500]!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),

          ],
        ));
  }
}