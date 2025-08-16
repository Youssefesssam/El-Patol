import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../firebase/authProvider.dart';
import '../../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../model/modelUserAttend.dart';
import 'attend.dart';
import 'menuAttendController.dart';

class MenuAttend extends StatefulWidget {
  final String userId;
  final int weekNum;
  final User user;
  final VoidCallback onCloseMenu;

  const MenuAttend({
    super.key,
    required this.onCloseMenu,
    required this.userId,
    required this.weekNum,
    required this.user,
  });

  @override
  State<MenuAttend> createState() => _MenuAttendState();
}

class _MenuAttendState extends State<MenuAttend> {
  late MenuAttendController controller;

  @override
  void initState() {
    super.initState();
    controller = MenuAttendController();
  }

  @override
  Widget build(BuildContext context) {
    final authProviders = Provider.of<AuthProviders>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final unitHeight = height / 120;

    return ChangeNotifierProvider<MenuAttendController>.value(
      value: controller,
      child: Consumer<MenuAttendController>(
        builder: (context, ctrl, _) =>Container(
          padding: EdgeInsets.all(width * 0.06),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade700),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context,Attend.routeName);
                    },
                      child: Icon(Icons.arrow_back_ios,color: Colors.red,)),
                  SizedBox(width: width/4.5,),

                  Text(
                    "تسجيل الحضور",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: unitHeight * 2.2,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: unitHeight * 2),

              // الصفوف الأربعة (القداس - التناول - ... إلخ)
              buildSimpleRow("القداس", Icons.church_outlined, ctrl.isMassActive, ctrl.massScore, () => ctrl.toggleState("mass")),
              buildSimpleRow("التناول", Icons.local_dining, ctrl.isCommunionActive, ctrl.communionScore, () => ctrl.toggleState("communion")),
              buildSimpleRow("الاعتراف", Icons.psychology_outlined, ctrl.isConfessionActive, ctrl.confessionScore, () => ctrl.toggleState("confession")),
              buildSimpleRow("الاجتماع", Icons.groups, ctrl.isMeetingActive, ctrl.meetingScore, () => ctrl.toggleState("meeting")),

              const Divider(color: Colors.white38),
              SizedBox(height: unitHeight * 2),

              Center(
                child: ctrl.isWaiting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ctrl.isDone
                    ? const Icon(Icons.check_circle, color: Colors.greenAccent, size: 32)
                    : Column(
                  children: [
                    buildButton(
                      text: AppLocalizations.of(context)!.reset,
                      textColor: Colors.redAccent,
                      onPressed: ctrl.resetScores,
                      icon: Icons.refresh,
                      fontSize: unitHeight * 2,
                    ),
                    SizedBox(height: unitHeight * 1.0),
                    buildButton(
                      text: AppLocalizations.of(context)!.confirm,
                      textColor: Colors.white,
                      bgColor: Colors.blueAccent,
                      onPressed: () => ctrl.submitScores(
                        saveFunction: ({
                          required score,
                          required meetingScoreDB,
                          required communionScoreDB,
                          required confessionScoreDB,
                          required massScoreDB,
                        }) async {
                          await New_fire_base_set_data_for_leader.updateScore(
                            yearId: '1',
                            weekId: authProviders.week.toString(),
                            monthId: authProviders.currentMonth!,
                            newValue: score,
                            scoreType: 'leaderScore',
                            userId: widget.userId,
                            governorate: authProviders.governorate!,
                            church: authProviders.churchCodeL!,
                            code: widget.user.code!,
                            stage: authProviders.stageCode!,
                          );
                        },
                        onSuccess: widget.onCloseMenu,
                        onError: (e) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        ),
                      ),
                      fontSize: unitHeight * 2.2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )

      ),
    );
  }

  Widget buildButton({
    required String text,
    required Color textColor,
    required VoidCallback onPressed,
    Color? bgColor,
    Color? borderColor,
    IconData? icon,
    double? fontSize,
    double? paddingHorizontal,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final unitHeight = screenSize.height / 100;
    final unitWidth = screenSize.width / 100;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: unitHeight * 1),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1.5)
                : null,
            boxShadow: bgColor != null && bgColor != Colors.transparent
                ? [
              BoxShadow(
                color: bgColor!.withOpacity(0.3),
                offset: const Offset(0, 3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ]
                : [],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal ?? unitWidth * 6,
              vertical: unitHeight * 1.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: (fontSize ?? unitHeight * 2.2) + 2,
                    color: textColor,
                  ),
                  SizedBox(width: unitWidth * 2),
                ],
                Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize ?? unitHeight * 2.2,
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildSimpleRow(String label, IconData icon, bool isActive, int score, VoidCallback toggle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, color: isActive ? Colors.greenAccent : Colors.grey.shade400),
      title: Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive) Text("+$score", style: const TextStyle(color: Colors.greenAccent)),
          IconButton(
            icon: Icon(
              isActive ? Icons.toggle_on : Icons.toggle_off,
              color: isActive ? Colors.green : Colors.grey,
              size: 32,
            ),
            onPressed: toggle,
          ),
        ],
      ),
    );
  }
}
