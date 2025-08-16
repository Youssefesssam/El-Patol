import 'package:flutter/material.dart';
import '../features/featuresHomeScreenLeaders/bodyScreenLaders/attend/attend.dart';
import '../features/featuresHomeScreenLeaders/home/home.dart';
import '../features/featuresHomeScreenUsers/appBarUser/setting/setting.dart';

class HomeScreenLeaders extends StatefulWidget {
  static const String routeName = "HomeScreenLeaders";

  const HomeScreenLeaders({super.key});

  @override
  _HomeScreenLeaders createState() => _HomeScreenLeaders();
}
@override

class _HomeScreenLeaders extends State<HomeScreenLeaders> {
  int currentTapIndex = 0;

  final List<Widget> screens = [
    Home(),
    Attend(),
    Setting(),
  ];

  final List<String> titles = [
    "الرئيسية",
    "الحضور",
    "الإعدادات",
  ];

  final List<IconData> icons = [
    Icons.home_filled,
    Icons.account_circle_rounded,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,

      body: Stack(
        children: [
          screens[currentTapIndex],

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color:  Colors.black.withOpacity(.8), // 🔵 لون خلفية الشريط
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(screens.length, (index) {
                  final isActive = currentTapIndex == index;
                  final color = isActive ? Colors.blue[800]! : Colors.white60;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentTapIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? Colors.blue[800]!.withOpacity(0.2) : Colors.transparent,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icons[index],
                            color: color,
                            size: 30,
                          ),
                          if (isActive)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue[800]!, // ● المؤشر الصغير
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}