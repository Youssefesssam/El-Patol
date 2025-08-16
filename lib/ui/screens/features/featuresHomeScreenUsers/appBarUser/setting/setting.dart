import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../firebase/authProvider.dart';
import '../../../../../../firebase/langProvider.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../screens/add_sub_leader_screen.dart';
import '../../../../../../screens/add_user_screen.dart';
import '../../../../../../screens/myInfo.dart';
import '../../../../../../screens/users_codes.dart';
import '../../../../homeScreen/screenUser/homeScreenUsers.dart';
import '../../../../splashScreen/welcomeScreen.dart';
import '../../../../utilites/appAssets.dart';

class Setting extends StatelessWidget {
  static const String routeName = "setting";

  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    int count = 0;

    AuthProviders authProviders = Provider.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (authProviders.countUserAttend != 0) {
          final shouldLeave = await showDialog<bool>(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 60, color: Colors.orange),
                    const SizedBox(height: 15),
                    Text(
                      "تنبيه",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "لم يتم رفع الحضور بعد.\nهل تريد رفع الحضور الآن؟",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text("إلغاء",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              authProviders.countUserAttendFun(count);
                              Navigator.pop(context, true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text("رفع الحضور"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
          return shouldLeave ?? false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          title: Text(AppLocalizations.of(context)!.account,
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.indigo.shade600],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(AppAssets.user),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      authProviders.nameL ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Account Options Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildAccountOption(
                      context: context,
                      icon: Icons.code,
                      title: AppLocalizations.of(context)!.usersCode,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AllUsersCodesScreen.routeName,
                        );
                      },
                    ),
                    buildAccountOption(
                      context: context,
                      icon: Icons.add,
                      title: AppLocalizations.of(context)!.addUser,
                      onTap: () {
                        Navigator.pushNamed(
                            context, AddUserScreen.routeName);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Support Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildAccountOption(
                      context: context,
                      icon: Icons.help_outline,
                      title: AppLocalizations.of(context)!.helpandsupport,
                      onTap: () {},
                    ),
                    buildAccountOption(
                      context: context,
                      icon: Icons.info_outline,
                      title: AppLocalizations.of(context)!.aboutUs,
                      onTap: () {},
                    ),
                    buildAccountOption(
                      context: context,
                      icon: Icons.language,
                      title: AppLocalizations.of(context)!.lang,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .chooseLang,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ListTile(
                                    leading: Icon(Icons.language),
                                    title: Text('English'),
                                    onTap: () {
                                      Provider.of<LangProvider>(
                                        context,
                                        listen: false,
                                      ).setLocale("en");
                                      print(
                                        "current lang >>> ${Provider.of<LangProvider>(context, listen: false).currentLocale}",
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.language),
                                    title: Text('العربية'),
                                    onTap: () {
                                      Provider.of<LangProvider>(
                                        context,
                                        listen: false,
                                      ).setLocale("ar");
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    buildAccountOption(
                      context: context,
                      icon: Icons.logout,
                      title: AppLocalizations.of(context)!.logout,
                      isLogout: true,
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              title: Text(
                                AppLocalizations.of(context)!
                                    .confirmSelection,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5.0),
                                child: Text(
                                  AppLocalizations.of(context)!.sureLogout,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              actionsAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancle,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final prefs = await SharedPreferences
                                        .getInstance();
                                    await prefs.clear();
                                    print("removvveee");
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      WelcomeScreen.routeName,
                                      (route) => false,
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.confirm,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Account Options
  Widget buildAccountOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.redAccent : Colors.blue,
              size: 28,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isLogout ? Colors.redAccent : Colors.black,
              ),
            ),
            const Spacer(),
            if (!isLogout)
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
