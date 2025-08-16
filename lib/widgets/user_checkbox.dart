import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserCheckbox extends StatelessWidget {
  static const String routeName ="UserCheckbox";
  final UserModel user;
  final bool isSelected;
  final Function(UserModel) onTap;

  const UserCheckbox({
    Key? key,
    required this.user,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${user.userCode} - ${user.currentStage}'),
      subtitle: Text('المرحلة: ${user.currentStage}'),
      trailing: Checkbox(
        value: isSelected,
        onChanged: (_) {
          onTap(user);
        },
      ),
      onTap: () {
        onTap(user);
      },
    );
  }
}