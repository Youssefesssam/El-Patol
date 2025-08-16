import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../firebase/authProvider.dart';
import '../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import '../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import 'componentScreenUser/appBarInterFace.dart';
import 'componentScreenUser/circularIndicator.dart';
import 'componentScreenUser/pointListGenerate.dart';

import 'componentScreenUser/viewMainComponent.dart';
import 'homeScreenShimmer.dart';
import 'homeScreenUserViewModel.dart';

class HomeScreenUsers extends StatefulWidget {
  HomeScreenUsers({super.key});

  static const String routeName = "homeScreenUsers";

  @override
  State<HomeScreenUsers> createState() => _HomeScreenUsersState();
}

class _HomeScreenUsersState extends State<HomeScreenUsers>
    with SingleTickerProviderStateMixin {
  String? savedEmojiName;
  String? savedEmojiVerse;
  String? savedEmojiPath;
  bool hasShownAd = false;
  int _currentPage = 0;
  int? currentMonth;
  Stream<Map<int, bool>>? _weekStatusStream;

  void initState() {
    super.initState();
    setProv();
    _loadSavedEmojiData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<HomeScreenUserViewModel>(context, listen: false);
      viewModel.showAdOnInit(context);
    });
    AuthProviders authProviders = Provider.of(context, listen: false);

    New_fire_base_get_data_for_leader.fetchCurrentWeek(
      governorate: authProviders.governorateUs!,
      church: authProviders.churchCodeUs!,
      stage: authProviders.stageCodeUs!,
    ).then((weekNum) {
      int initMonth = ((weekNum - 1) ~/ 4) + 1;
      setState(() {
        currentMonth = initMonth;
        _weekStatusStream = authProviders.streamWeekStatuses(
          governorateName: authProviders.governorateUs!,
          churchCode: authProviders.churchCodeUs!,
          stage: authProviders.stageCodeUs!,
          id: authProviders.userId!,
          monthNum: initMonth,
        );
      });
    });
  }




  Future<void> _loadSavedEmojiData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedEmojiName = prefs.getString('saved_emoji_name');
      savedEmojiVerse = prefs.getString('saved_emoji_verse');
      savedEmojiPath = prefs.getString('saved_emoji_path');
    });
  }

  Future<void> setProv() async {
    final auth = Provider.of<AuthProviders>(context, listen: false);
    await auth.setUserData();
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);

    if (authProviders.governorateUs == null ||
        authProviders.churchCodeUs == null ||
        authProviders.stageCodeUs == null) {
      return const Center(child: HomeScreenShimmer());
    }

    final isTablet = MediaQuery.of(context).size.width > 600;
    return ChangeNotifierProvider(
      create: (_) => HomeScreenUserViewModel()
        ..saveUserWeekInProvider(
          context: context,
          governorate: authProviders.governorateUs!,
          church: authProviders.churchCodeUs!,
          stage: authProviders.stageCodeUs!,
        ),
      child: Consumer<HomeScreenUserViewModel>(
        builder: (context, viewModel, _) {
          final authProviders = Provider.of<AuthProviders>(context);

          if (!hasShownAd) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.showAdOnInit(context);
              setState(() {
                hasShownAd = true;
              });
            });
          }


          return Scaffold(
            backgroundColor: Colors.white,
            body: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (!viewModel.isLoading && details.primaryDelta! > 0) {
                  viewModel.updateDrag(details.primaryDelta!);
                }
              },
              onVerticalDragEnd: (_) {
                if (viewModel.dragOffset > 50) {
                  print(authProviders.userId!);
                  print( authProviders.weekUse!);
                  print(authProviders.week!);
                  print(authProviders.governorateUs!);
                  print(authProviders.churchCodeUs!);
                  print(authProviders.codeUs!);
                  print(authProviders.stageCodeUs!);
                  viewModel.startLoading(authProviders);
                  New_fire_base_set_data_for_leader.getThisDetalsWeek(
                      userId: authProviders.userId!,
                      monthId: currentMonth.toString(),
                      numWeekUse: authProviders.weekUse!,
                      numWeek: authProviders.week!,
                      governorate: authProviders.governorateUs!,
                      church: authProviders.churchCodeUs!,
                      code: authProviders.codeUs!,
                      stage: authProviders.stageCodeUs!
                  );
                } else {
                  viewModel.resetDrag();
                }
              },
              child: Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0, viewModel.dragOffset),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // AppBar at the top
                          const AppBarInterFace(),
                          // Chart Interface


                          // Main Content
                          Column(
                            children: [
                              ViewMainComponent(
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                currentIndex: _currentPage,
                              ),
                              PointListGenerate(currentIndex: _currentPage),
                            ],
                          ),

                          // Settings Interface
                        ],
                      ),
                    ),
                  ),

                  // Loading Indicator
                  if (viewModel.isLoading) const CircularIndecator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}