import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../model/modelUser.dart';
import '../../../utilites/appColors.dart';
import 'cardUser.dart';
import 'detals.dart';
import 'listOfUsersLogic.dart';
import 'menu.dart';

class ListOfUsers extends StatefulWidget {
  static const String routeName = "listOfUsers";

  const ListOfUsers({super.key});

  @override
  State<ListOfUsers> createState() => _ListOfUsers();
}

class _ListOfUsers extends State<ListOfUsers> {
  late final ListOfUsersController _controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = ListOfUsersController(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await _controller.initializeData().then((_) {
          New_fire_base_set_data_for_leader.saveStageUserCountIfChanged(context);

        setState(() {}); // نحدث الواجهة بعد التحميل
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    int? passedWeek = args?['week'];
    if (passedWeek != null) {
      _controller.weekToUse = passedWeek;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProviders = Provider.of<AuthProviders>(context);
    final filteredUsers = _controller.filterUsers(_controller.cachedUsers);

    return Scaffold(
      body: Container(
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _controller.cachedUsers.isEmpty
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSearchBar(),
                  Expanded(child: _buildUserList(filteredUsers)),
                ],
              ),
              if (_controller.selectedCardIndex != null) _buildBlurOverlay(),
              if (_controller.selectedCardIndex != null)
                _buildSelectedCardOverlay(filteredUsers),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.mainColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.blue, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller.searchAllUser,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
                hintStyle: const TextStyle(color: Colors.blue),
                border: InputBorder.none,
              ),
              style: TextStyle(color: AppColors.white),
              cursorColor: AppColors.mainColor,
              onChanged: (value) {
                setState(() => _controller.handleSearchChange(value));
              },
            ),
          ),
          isLoading
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
              :IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text(
                    "تحديث المستخدمين",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    "لو يوجد بالفعل مستخدم مش موجود، اضغط تحديث.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // يغلق الديالوج
                        setState(() => isLoading = true);
                        await _controller.refreshUsersFromFirebase();
                        setState(() => isLoading = false);

                        // اختياري: عرض SnackBar بعد التحديث
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("تم تحديث البيانات بنجاح")),
                        );
                      },
                      child: const Text("تحديث", style: TextStyle(color: Colors.blue)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("إغلاق", style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );
            },
          ),

        ],
      ),
    );
  }

  Widget _buildUserList(List<MyUser> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onLongPress: () {
            setState(() => _controller.handleCardLongPress(index));
          },
          onTap: () {
            setState(() => _controller.handleCardTap(index));
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            child: _buildUserCard(users[index]),
          ),
        );
      },
    );
  }

  Widget _buildUserCard(MyUser user) {
    bool isMeetingActive = _controller.attendedUsersCodes.contains(user.code);
    return CardUser(
      users: user,
      userId: user.id,
      score: 300,
      rank: 1,
      image: user.profileUrl,
      isMeetingActive: isMeetingActive,
    );
  }

  Widget _buildBlurOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _controller.selectedCardIndex = null),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _buildSelectedCardOverlay(List<MyUser> users) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.12,
      left: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUserCard(users[_controller.selectedCardIndex!]),
          const SizedBox(height: 20),
          _controller.click
              ? _buildDetails(users[_controller.selectedCardIndex!])
              : _buildMenu(users[_controller.selectedCardIndex!]),
        ],
      ),
    );
  }

  Widget _buildMenu(MyUser user) {
    return Menu(
      onCloseMenu: () => setState(() => _controller.closeMenu(user)),
      user: user,
      userId: user.id,
      userCode: user.code,
    );
  }

  Widget _buildDetails(MyUser user) {
    return Details(
      onCloseDetals: () => setState(() => _controller.closeDetails()),
      user: user,
      userId: user.id,
      userCode: user.id,
      currentWeek: Provider.of<AuthProviders>(context).weekUse!.toString(),
    );
  }
}
