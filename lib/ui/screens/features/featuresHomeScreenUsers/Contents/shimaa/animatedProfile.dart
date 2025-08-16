import 'package:el_patol/ui/screens/features/featuresHomeScreenUsers/Contents/shimaa/shimmerCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utilites/appColors.dart';
import '../../../../utilites/appTexts.dart';
import '../../../../utilites/consts.dart';
import '../../bodyScreenUsers/chartsDigram/charts.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AnimatedProfile extends StatelessWidget {
  AnimatedProfile({super.key});

  String selectedMonthString = '01';
  int selectedMonthIntegr = 1;
  bool isRefreshing = false;
  bool _isGlobalLoading = true; // Changed to true to see shimmer effect
  static const String routeName = "animatedProfile";

  final List<String> month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  int selectedWeekIndex = 0;
  int _currentIndex = 0;
  int? lastSelectedWeek;
  bool unSeenSweetTalk = AppTexts.seenSweet;
  bool unSeenWord = AppTexts.seenWord;
  bool unSeenEvent = AppTexts.seenEvent;
  String lastEvent = "";
  String lastWord = "";
  String lastTask = "";
  String lastSweet = "";
  String newEvent = "";
  String newWord = "";
  String newTask = "";
  String newSweet = "";
  bool _isLoading = true; // Keep this true to see shimmer
  double _dragOffset = 0.0;
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final List<Widget> pic = [
      general("general", context),
      competition("competition", context),
    ];
    return Stack(
      children: [
        Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.backGround,
                        begin: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: isTablet
                              ? MediaQuery.of(context).size.height * 0.25
                              : MediaQuery.of(context).size.height * 0.53,
                        ),
                        Column(
                          children: [
                            CarouselSlider(
                              items: pic,
                              options: CarouselOptions(
                                height: isTablet
                                    ? MediaQuery.of(context).size.height * 0.6
                                    : MediaQuery.of(context).size.height * 0.45,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(pic.length, (index) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(
                                      bottom: 20, right: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentIndex == index
                                        ? AppColors.mainColor
                                        : AppColors.darkgrey,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              height: 200,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.appBarColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.40,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 30, right: 20),
                  child: _isLoading
                      ? _buildShimmerChartPlaceholder(isTablet)
                      : Charts(selectMonth: selectedMonthIntegr),
                ),
              ),
            ),
            Positioned(
              top: 35,
              left: 35,
              child: _isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 35,
                    ),
            ),
            Positioned(
              top: 40,
              left: 135,
              child: _isLoading
                  ? _buildShimmerHeaderPlaceholder(context)
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consts.fetcher(
                      Consts.getName(),
                      GoogleFonts.aclonica(
                        fontSize:
                        MediaQuery.of(context).size.height * .023,
                        color: AppColors.white,
                        letterSpacing: 1.2,
                      )),
                  SizedBox(height: 7),
                  Consts.fetcher(
                      Consts.getEmail(),
                      GoogleFonts.aclonica(
                        fontSize:
                        MediaQuery.of(context).size.height * .012,
                        color: AppColors.white,
                        letterSpacing: 1.2,
                      )),
                ],
              ),
            ),
            Positioned(
              top: 110,
              right: 10,
              child: _isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        color: Colors.grey.withOpacity(.3),
                        margin: const EdgeInsets.only(right: 30),
                        child: Column(
                          children: [
                            SizedBox(height: 50, width: 60),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey.withOpacity(.5),
                      margin: const EdgeInsets.only(right: 30),
                      child: Column(
                        children: [
                          SizedBox(height: 60, width: 85),
                        ],
                      ),
                    ),
            ),
            Positioned(
              top: 180,
              right: -30,
              child: _isLoading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            padding: const EdgeInsets.only(
                                right: 50, top: 10, left: 20, bottom: 10),
                            decoration: BoxDecoration(
                              color: AppColors.secColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            child: Container(
                              width: 40,
                              height: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            padding: const EdgeInsets.only(
                                right: 50, top: 10, left: 20, bottom: 10),
                            decoration: BoxDecoration(
                              color: AppColors.secColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            child: Container(
                              width: 40,
                              height: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.only(
                              right: 50, top: 10, left: 20, bottom: 10),
                          decoration: BoxDecoration(
                            color: AppColors.secColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            "  ",
                            style: GoogleFonts.aclonica(
                              fontSize: isTablet ? 40 : 30,
                              color: AppColors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.only(
                              right: 50, top: 10, left: 20, bottom: 10),
                          decoration: BoxDecoration(
                            color: AppColors.secColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            "  ",
                            style: GoogleFonts.aclonica(
                              fontSize: isTablet ? 40 : 30,
                              color: AppColors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildShimmerHeaderPlaceholder(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .023,
            width: MediaQuery.of(context).size.width * .3,
            color: Colors.white,
          ),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height * .012,
            width: MediaQuery.of(context).size.width * .2,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerChartPlaceholder(bool isTablet) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Expanded(
          child: Column(
            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  6,
                  (index) => Column(
                    children: [
                      Container(
                        height: 230 * (index % 5 + 1) / 5,
                        width: 20,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 10,
                        width: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Legend placeholders
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: Colors.white,
                        margin: const EdgeInsets.only(right: 5),
                      ),
                      Container(
                        height: 10,
                        width: 40,
                        color: Colors.white,
                        margin: const EdgeInsets.only(right: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget general(String head, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin:
                const EdgeInsets.only(left: 20, top: 0, right: 10, bottom: 0),
            child: _isGlobalLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(.01),
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 30,
                      width: 100,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    head,
                    style: GoogleFonts.aboreto(
                        color: AppColors.white,
                        fontSize: MediaQuery.sizeOf(context).width * 0.08),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Optiongeneral(
                    'IDeas', Icons.lightbulb_outline, () {}, context),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.width * 0.25,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: AppColors.smoothColorTeal,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Optiongeneral('Opinion', Icons.comment, () {}, context),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Optiongeneral("Sweet", Icons.favorite_border, () {}, context),
                ],
              )),
              Flexible(
                  child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Optiongeneral("Word", Icons.text_fields, () {}, context),
                ],
              )),
              Flexible(
                child: Optiongeneral("Team", Icons.group, () {}, context),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Optiongeneral("Taskoo", Icons.assignment, () {}, context)
                ],
              )),
              Flexible(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Optiongeneral("Hi.Event", Icons.event, () {}, context),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget Optiongeneral(String optionName, IconData icon, VoidCallback onTap,
      BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.21;

    return ShimmerCard(
      size: size,
      isLoading: _isGlobalLoading,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: size * 0.4,
              color: _isGlobalLoading ? Colors.transparent : AppColors.white,
            ),
            SizedBox(height: size * 0.07),
            _isGlobalLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.teal.withOpacity(.05),
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: size * 0.6,
                      height: size * 0.15,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    optionName,
                    style: GoogleFonts.abyssinicaSil(
                      fontSize: size * 0.15,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget competition(String head, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add your competition content here with shimmer effects
        ],
      ),
    );
  }
}
