import 'package:flutter/material.dart';

import '../../../utilites/appColors.dart';
import '../../setttingUser.dart';

class SettingInterFace extends StatelessWidget {
  const SettingInterFace({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * .05,
      right: MediaQuery.of(context).size.height * .01,
      child: IconButton(
        icon: Icon(
          Icons.settings,
          color: AppColors.white,
          size: 30,
        ),
        onPressed: () {
          Navigator.pushNamed(context, SettingUser.routeName);
        },
      ),
    );
  }
}
