// UI file: attend.dart

import 'dart:ui';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../firebase/authProvider.dart';
import '../../../../../../model/modelUserAttend.dart';
import '../../../../utilites/appColors.dart';
import '../../listOfUsers/listOfUsers.dart';
import 'attendLogic.dart';
import 'cardUserAttend.dart';
import 'menuAttend.dart';

class Attend extends StatefulWidget {
  static const String routeName = "Attend";

  Attend({super.key});

  @override
  State<Attend> createState() => _AttendState();
}

class _AttendState extends State<Attend> {
  int? selectedCardIndex;
  TextEditingController userAttendence = TextEditingController();
  String searchUserAttend = '';
  int count = 0;
  List<User> localList = [];

  @override
  void initState() {
    super.initState();
    _loadUsersFromShared();
  }

  void _loadUsersFromShared() async {
    List<User> users = await AttendLogic.readUserListFromShared();
    await AttendLogic.initialize(context);
    setState(() {
      localList = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};
    final isUpdate = args['update'] ?? false;
    final authProviders = Provider.of<AuthProviders>(context);

    List<User> filteredUsers = AttendLogic.filterUsers(
      authProviders.usersAttend,
      searchUserAttend,
    );

    if (filteredUsers.isEmpty && selectedCardIndex != null) {
      setState(() => selectedCardIndex = null);
    }
    if (localList.length != filteredUsers.length) {
      localList = List.from(filteredUsers);
    }

    return WillPopScope(
      onWillPop: () async {
        if (authProviders.countUserAttend != 0) {
          final shouldLeave = await showDialog<bool>(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 60,
                      color: Colors.orange,
                    ),
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
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
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
                            child: Text(
                              "إلغاء",
                              style: TextStyle(color: Colors.black),
                            ),
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

      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backGround,
            begin: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          floatingActionButton: _buildFloatingMenu(
            authProviders,
            filteredUsers,
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              _buildBackgroundGradient(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(screenWidth, screenHeight),
                  _buildUserCount(
                    authProviders,
                    filteredUsers,
                    screenHeight,
                    screenWidth,
                  ),
                  Expanded(
                    child: _buildAttendanceList(authProviders, filteredUsers),
                  ),

                  Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height / 12,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
              if (selectedCardIndex != null) _buildBlurredBackground(),
              if (selectedCardIndex != null)
                _buildSelectedCardOverlay(authProviders, filteredUsers),
              if (isUpdate) _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingMenu(AuthProviders authProviders, List<User> users) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: CircularMenu(
        alignment: Alignment.bottomRight,
        toggleButtonColor: Colors.blue.shade900,
        items: [
          CircularMenuItem(
            icon: Icons.cloud_upload,
            color: authProviders.countUserAttend == 0
                ? Colors.grey
                : Colors.green,
            onTap: () {
              authProviders.countUserAttendFun(count);
            },
          ),
          CircularMenuItem(
            icon: Icons.add,
            color: Colors.orange,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ListOfUsers()),
              );
              setState(() {});
              ;
            },
          ),
          CircularMenuItem(
            icon: Icons.replay_circle_filled,
            color: Colors.red,
            onTap: () async {
              await AttendLogic.initialize(context);
              _loadUsersFromShared();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تحديث البيانات بنجاح')),
              );
            }, // implement delete all if needed
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.withOpacity(0.4),
            Colors.blueGrey.withOpacity(0.4),
            Colors.blue.withOpacity(0.4),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildSearchBar(double width, double height) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.015,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.blue.shade800, size: height * 0.035),
          SizedBox(width: width * 0.02),
          Expanded(
            child: TextField(
              controller: userAttendence,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.blue.shade800),
                border: InputBorder.none,
              ),
              style: TextStyle(color: AppColors.white),
              cursorColor: AppColors.mainColor,
              onChanged: (value) => setState(() => searchUserAttend = value),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, ListOfUsers.routeName),
            child: Icon(Icons.groups, color: Colors.blue.shade800, size: height * 0.045),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCount(
    AuthProviders authProviders,
    List<User> users,
    double height,
    double width,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildCountBox(
            users.length,
            Colors.blue.shade900,
            Colors.blue.shade700,
            height,
            width,
            'عدد المستخدمين الحاضرين',
          ),
          SizedBox(width: 5),
          _buildCountBox(
            authProviders.countUserAttend,
            authProviders.countUserAttend == 0
                ? Colors.green.shade800
                : Colors.red.shade900,
            authProviders.countUserAttend == 0
                ? Colors.green.shade600
                : Colors.red.shade700,
            height,
            width,
            "عدد المستخدمين الذي لم يتم رفعهم",
          ),
        ],
      ),
    );
  }

  Widget _buildCountBox(
    int count,
    Color color1,
    Color color2,
    double height,
    double width,
    String text,
  ) {
    bool showText = false;

    return StatefulBuilder(
      builder: (context, setState) {
        // حساب حجم الخط الديناميكي بناءً على عرض الشاشة وطول النص
        double calculateFontSize() {
          const double baseWidth = 400; // عرض أساسي للقياس
          const double baseFontSize = 14; // حجم الخط الأساسي

          // حساب نسبة العرض الحالي إلى العرض الأساسي
          double widthRatio = width / baseWidth;

          // حساب طول النص (عدد الأحرف)
          int textLength = text.length;

          // تقليل حجم الخط إذا كان النص طويلاً
          double lengthFactor = textLength > 20 ? 0.9 : 1.0;
          if (textLength > 30) lengthFactor = 0.8;
          if (textLength > 40) lengthFactor = 0.7;

          return (baseFontSize * widthRatio * lengthFactor).clamp(
            10.0,
            height * 0.025,
          );
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              showText = !showText;
            });
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: width * 0.4, // تحديد عرض أقصى للصندوق
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [color1, color2],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$count  ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.02,
                  ),
                ),
                showText
                    ? Flexible(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: calculateFontSize(),
                          ),
                          softWrap: true, // السماح بلف النص إذا لزم الأمر
                          overflow: TextOverflow
                              .fade, // تأثير تدرج إذا لم يكفي المساحة
                        ),
                      )
                    : Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: height * 0.02,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  // أضف هذا الجزء المعدل من الكود في ملف attend.dart

  Widget _buildAttendanceList(AuthProviders authProviders, List<User> users) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: List.generate((localList.length / 3).ceil(), (rowIndex) {
          final startIndex = rowIndex * 3;
          final endIndex = (startIndex + 3 <= localList.length)
              ? startIndex + 3
              : localList.length;

          final rowItems = localList.sublist(startIndex, endIndex);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(rowItems.length, (index) {
              final user = rowItems[index];

              // تحديد الحجم: الأكبر في المنتصف
              double widthFactor;
              if (rowItems.length == 3 && index == 1) {
                widthFactor = 0.30; // وسط
              } else if (rowItems.length == 2) {
                widthFactor = 0.24; // فقط 2 في الصف
              } else {
                widthFactor = 0.18; // يمين/يسار
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: _buildAnimatedCard(user, startIndex + index, size: widthFactor),
              );
            }),
          );
        }),
      ),
    );
  }
  Widget _buildAnimatedCard(User user, int index, {required double size}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCardIndex = index;
        });
        _playTapAnimation();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Container(
          key: ValueKey(user.id),
          width: MediaQuery.of(context).size.width * size,
          child: _buildCard(user),
        ),
      ),
    );
  }

  // تأثير اهتزاز عند النقر على الكارد
  void _playTapAnimation() {
    // يمكنك استخدام AnimationController هنا لمزيد من التحكم
    // أو استخدام حزمة مثل flutter_animations
  }

  Widget _buildSelectedCardOverlay(
    AuthProviders authProviders,
    List<User> users,
  ) {
    if (localList.isEmpty ||
        selectedCardIndex == null ||
        selectedCardIndex! >= localList.length) {
      return Container();
    }

    final selectedUser = localList[selectedCardIndex!];

    return Positioned.fill(
      child: Stack(
        children: [
          // Blurred background with fade animation
          AnimatedOpacity(
            opacity: selectedCardIndex != null ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: () => setState(() => selectedCardIndex = null),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),
            ),
          ),

          // Card and menu with bounce animation
          Center(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: selectedCardIndex != null
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Card with spring animation
                          Hero(
                            tag: 'card_${selectedUser.id}',
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                              margin: EdgeInsets.all(20),
                              transform: Matrix4.identity()
                                ..scale(selectedCardIndex != null ? 1.1 : 1.0),
                              child: _buildCard(selectedUser),
                            ),
                          ),

                          // Menu with slide-up animation
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 600),
                            transitionBuilder: (child, animation) {
                              return SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: Offset(0, 0.3),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.elasticOut,
                                      ),
                                    ),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: _buildMenu(
                              selectedUser,
                              authProviders.weekUse ?? 1,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(User user, int weekNum) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: MenuAttend(
          key: ValueKey(user.id),
          user: user,
          userId: user.id ?? '',
          weekNum: weekNum,
          onCloseMenu: () {
            setState(() {
              selectedCardIndex = null;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.grey[900]!, Colors.cyan[700]!],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.delete, color: Colors.white, size: 30),
        ],
      ),
    );
  }

  Widget _buildBlurredBackground() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => selectedCardIndex = null),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Update',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCard(User user) {
    return CardUserAttend(users: user, image: user.profileUrl ?? '');
  }
}
