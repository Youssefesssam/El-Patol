import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_patol/providers/leader_provider.dart';
import 'package:el_patol/screens/add_sub_leader_screen.dart';
import 'package:el_patol/screens/add_user_screen.dart';
import 'package:el_patol/screens/authLeader/ragsterDataForLeader.dart';
import 'package:el_patol/screens/loginScreenMasterLeader.dart';
import 'package:el_patol/screens/login_sub_leader.dart';
import 'package:el_patol/screens/master_leader_screen.dart';
import 'package:el_patol/screens/myInfo.dart';
import 'package:el_patol/screens/screen_profile_leader.dart';
import 'package:el_patol/screens/users_codes.dart';
import 'package:el_patol/ui/screens/auth/loginScreen/loginScreen.dart';
import 'package:el_patol/ui/screens/auth/registerScreen/registerProvider.dart';
import 'package:el_patol/ui/screens/auth/registerScreen/regsterScreen.dart';
import 'package:el_patol/ui/screens/developerScreens/add_church.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/bodyScreenLaders/attend/attend.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/home/absent/absentData.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/home/answers.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/home/home.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/home/team.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenLeaders/listOfUsers/listOfUsers.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenUsers/Contents/shimaa/animatedProfile.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenUsers/appBarUser/setting/setting.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/rank/rank.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistcsViewModel.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/bottomAppBarUsers/statistics.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/chartsDigram/charts.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/slider/event/event.dart';
import 'package:el_patol/ui/screens/features/featuresHomeScreenUsers/bodyScreenUsers/slider/task/task.dart';
import 'package:el_patol/ui/screens/homeScreen/homeScreenLeaders.dart';
import 'package:el_patol/ui/screens/homeScreen/profile.dart';
import 'package:el_patol/ui/screens/homeScreen/screenUser/changePassword.dart';
import 'package:el_patol/ui/screens/homeScreen/screenUser/componentScreenUser/ad.dart';
import 'package:el_patol/ui/screens/homeScreen/screenUser/homeScreenShimmer.dart';
import 'package:el_patol/ui/screens/homeScreen/screenUser/homeScreenUsers.dart';
import 'package:el_patol/ui/screens/homeScreen/screenUser/mainComponent/compitionWidget/compettion/prize/DailyCheckInScreen.dart';
import 'package:el_patol/ui/screens/homeScreen/screenUser/mainComponent/compitionWidget/compettion/prize/prizeScreen.dart';
import 'package:el_patol/ui/screens/homeScreen/screenUser/mainComponent/generalWidget/general/emoji.dart';
import 'package:el_patol/ui/screens/homeScreen/setttingUser.dart';
import 'package:el_patol/ui/screens/splashScreen/splashScreen.dart';
import 'package:el_patol/ui/screens/splashScreen/welcomeScreen.dart';
import 'package:el_patol/ui_web/studend_ui/TeachersPage.dart';
import 'package:el_patol/ui_web/studend_ui/studentProfilePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase/authProvider.dart';
import 'firebase/dataProvider.dart';
import 'firebase/fireBase/fireBaseForLeader/secend firebase.dart';
import 'firebase/langProvider.dart';
import 'firebase/monthProvider.dart';
import 'firebase/providerTotalScore.dart';
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

  await SecondFirebase.initialize();

  final langProvider = LangProvider();
  await langProvider.loadLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviders()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsViewModel()),
        ChangeNotifierProvider(create: (_) => ProviderTotalScore()),
        ChangeNotifierProvider(create: (_) => LeaderProvider()),
        ChangeNotifierProvider(create: (_) => MonthProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),

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
    LangProvider langProvider=Provider.of(context);
    return MaterialApp(

      locale:langProvider.currentLocale,
      supportedLocales: L10n.all,

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],


      initialRoute:StudentProfilePage.routeName,
      // This trailing comma makes auto-formatting nicer for build methods.
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreenLeaders.routeName: (_) => const HomeScreenLeaders(),
        HomeScreenUsers.routeName: (_) => HomeScreenUsers(),
        HomeScreenShimmer.routeName: (_) => HomeScreenShimmer(),
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) =>  RegisterScreen(),
        Charts.routeName: (_) => Charts(),
        Setting.routeName: (_) =>  Setting(),
        SettingUser.routeName: (_) => const SettingUser(),
        EventScreen.routeName: (_) => const EventScreen(),
        MyEmoji.routeName: (_) =>  MyEmoji(),
        TaskScreen.routeName: (_) => const TaskScreen(),
        ListOfUsers.routeName: (_) => ListOfUsers(),
        Statistics.routeName: (_) =>  Statistics(),
        Home.routeName: (_) =>  Home(),
        RankPage.routeName: (_) => const RankPage(),
        UserProfilePage.routeName: (_) => const UserProfilePage(),
        Attend.routeName: (_) => Attend(),
        Answers.routeName: (_) => const Answers(),
        AbsentData.routeName: (_) => const AbsentData(),
        Team.routeName: (_) => const Team(),
        AnimatedProfile.routeName: (_) => AnimatedProfile(),
        LoginScreenMasterLeader.routeName: (_) => LoginScreenMasterLeader(),
        ProfileScreen.routeName: (_) => ProfileScreen(),
        AddSubLeaderScreen.routeName: (_) => AddSubLeaderScreen(),
        AddUserScreen.routeName: (_) => AddUserScreen( ),
        LoginSubLeaderScreen.routeName: (_) => LoginSubLeaderScreen( ),
        MyInfo.routeName: (_) => MyInfo( ),
        AddChurch.routeName: (_) => AddChurch( ),
        MasterLeaderScreen.routeName: (_) => MasterLeaderScreen( ),
        AdInterFace.routeName: (_) => AdInterFace( ),
        RagsterDataForLeader.routeName: (_) => RagsterDataForLeader( ),
        PrizeScreen.routeName: (_) => PrizeScreen( ),
        DailyCheckInDialog.routeName: (_) => DailyCheckInDialog( ),
        ChangePasswordPage.routeName: (_) => ChangePasswordPage( ),
        AllUsersCodesScreen.routeName: (_) => AllUsersCodesScreen( ),
        WelcomeScreen.routeName: (_) => WelcomeScreen( ),
        StudentProfilePage.routeName: (_) => StudentProfilePage( ),
        TeachersPage.routeName: (_) => TeachersPage( ),
      },
    );
  }
}
