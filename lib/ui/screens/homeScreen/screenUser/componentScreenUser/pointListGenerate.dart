import 'package:flutter/material.dart';

import '../../../utilites/appColors.dart';
import '../mainComponent/picGeneralAndCompition.dart';

class PointListGenerate extends StatelessWidget {
  final int currentIndex;

  const PointListGenerate({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        PicGeneralAndCompition.pic.length,
            (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(bottom: 20, right: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == index
                  ? AppColors.mainColor
                  : AppColors.darkgrey,
            ),
          );
        },
      ),
    );
  }
}
