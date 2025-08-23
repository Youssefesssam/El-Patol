import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_patol/providers/leader_provider.dart';

import 'package:el_patol/ui/screens/auth/loginScreen/loginScreen.dart';

import 'package:el_patol/ui/screens/auth/registerScreen/regsterScreen.dart';
import 'package:el_patol/ui/screens/developerScreens/add_center.dart';

import 'package:el_patol/ui_web/add_video/chooseStage.dart';

import 'package:el_patol/ui_web/homeWeb/homeWeb.dart';
import 'package:el_patol/ui_web/screenMr/screenMr.dart';
import 'package:el_patol/ui_web/screens/add_sub_leader_screen.dart';
import 'package:el_patol/ui_web/screens/add_user_screen.dart';
import 'package:el_patol/ui_web/screens/authLeader/ragsterDataForLeader.dart';
import 'package:el_patol/ui_web/screens/loginScreenMasterLeader.dart';
import 'package:el_patol/ui_web/screens/login_sub_leader.dart';
import 'package:el_patol/ui_web/screens/master_leader_screen.dart';
import 'package:el_patol/ui_web/seenVideoUser/seenvideo.dart';
import 'package:el_patol/ui_web/studend_ui/TeachersPage.dart';
import 'package:el_patol/ui_web/studend_ui/studentProfilePage.dart';
import 'package:el_patol/ui_web/subscriptionRequestsScreen/subscriptionRequestsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase/authProvider.dart';
import 'firebase/langProvider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // await SecondFirebase.initialize();

  final langProvider = LangProvider();
  await langProvider.loadLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviders()),
        ChangeNotifierProvider(create: (_) => LeaderProvider()),
        ChangeNotifierProvider(create: (_) => langProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LangProvider langProvider = Provider.of(context);
    return MaterialApp(
      locale: langProvider.currentLocale,
      supportedLocales: L10n.all,

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      initialRoute: HomeWeb.routeName,
      // This trailing comma makes auto-formatting nicer for build methods.
      debugShowCheckedModeBanner: false,
      routes: {
        HomeWeb.routeName: (_) => HomeWeb(),
        MasterLeaderScreen.routeName: (_) => MasterLeaderScreen(),
        RagsterDataForLeader.routeName: (_) => RagsterDataForLeader(),
        LoginSubLeaderScreen.routeName: (_) => LoginSubLeaderScreen(),
        AddSubLeaderScreen.routeName: (_) => AddSubLeaderScreen(),
        LoginScreenMasterLeader.routeName: (_) => LoginScreenMasterLeader(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        AddUserScreen.routeName: (_) => const AddUserScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        StudentProfilePage.routeName: (_) => StudentProfilePage(),
        TeachersPage.routeName: (_) => TeachersPage(),
        SeenVideoUser.routeName: (_) => SeenVideoUser(),
        AddCenter.routeName: (_) => AddCenter(),
        ChooseStageScreen.routeName: (_) => ChooseStageScreen(),
        ScreenMr.routeName: (_) => ScreenMr(),
        SubscriptionRequestsScreen.routeName: (_) => SubscriptionRequestsScreen(
              teacherId: 'Mr1017595',
              centerId: '101',
            ),
      },
    );
  }
}
