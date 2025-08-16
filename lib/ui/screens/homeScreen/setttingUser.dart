import 'package:el_patol/ui/screens/homeScreen/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../firebase/authProvider.dart';
import '../../../firebase/langProvider.dart';
import '../../../l10n/app_localizations.dart';
import '../auth/loginScreen/loginScreen.dart';
import '../utilites/consts.dart';

class SettingUser extends StatelessWidget {
  static const String routeName = "settingUser";

  const SettingUser({super.key});
  Future delPreference()async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("address");
    prefs.remove("university");
    prefs.remove("talent");
    prefs.remove("phone");
    prefs.remove("gender");
    prefs.remove("code");
    prefs.remove("profileUrl");
    prefs.remove("userId");
  }
  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders=Provider.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal[800],
        title:  Text(
          AppLocalizations.of(context)!.account,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal[800]!, Colors.teal[800]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(authProviders.profileURl!),
                      // Replace with your image asset
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Consts.fetcher(Consts.getName(), const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                    const SizedBox(height: 6),
                    Consts.fetcher(Consts.getEmail(), const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),)
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
                      icon: Icons.person_outline,
                      title: AppLocalizations.of(context)!.editProfile,
                      onTap: () {
                        Navigator.pushNamed(context,UserProfilePage.routeName);
                      },
                    ),
                    buildAccountOption(
                      icon: Icons.settings_outlined,
                      title: "Settings",
                      onTap: () {},
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
                      icon: Icons.help_outline,
                      title: AppLocalizations.of(context)!.helpandsupport,
                      onTap: () {},
                    ),
                    buildAccountOption(
                      icon: Icons.info_outline,
                      title: AppLocalizations.of(context)!.aboutUs,
                      onTap: () {},
                    ),
                    buildAccountOption(
                      icon: Icons.language,
                      title: AppLocalizations.of(context)!.lang,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.chooseLang,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  ListTile(
                                    leading: Icon(Icons.language),
                                    title: Text('English'),
                                    onTap: () {
                                      Provider.of<LangProvider>(context,listen: false).setLocale("en");
                                      print("current lang >>> ${Provider.of<LangProvider>(context,listen: false).currentLocale}");
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.language),
                                    title: Text('العربية'),
                                    onTap: () {
                                  Provider.of<LangProvider>(context,listen: false).setLocale("ar");
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
                      icon: Icons.logout,
                      title: AppLocalizations.of(context)!.logout,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              title: Text(
                                AppLocalizations.of(context)!.confirmSelection,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
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
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child:  Text(
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
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    delPreference();
                                    Navigator.pushReplacementNamed(context,LoginScreen.routeName);
                                  },
                                  child:  Text(
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
                      isLogout: true,)
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
              color: isLogout ? Colors.redAccent : Colors.teal,
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
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),

          ],
        ),
      ),
    );
  }
}