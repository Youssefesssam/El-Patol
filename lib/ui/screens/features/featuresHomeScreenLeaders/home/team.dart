import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../firebase/authProvider.dart';
import '../../../utilites/appAssets.dart';

class Team extends StatefulWidget {
  static const String routeName = 'Team';

  const Team({super.key});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  String? _selectedTalent;
  bool _showAll = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();
  List<String> _allTalents = [];
  Map<String, List<Map<String, dynamic>>> _usersByTalent = {};
  List<Map<String, dynamic>> _cachedUsers = [];
  bool _isLoading = false;
  int _lastFetchTimestamp = 0;
  bool _hasUpdates = false;
  int _newUsersCount = 0;


  @override
  void initState() {
    super.initState();
    _initializeData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //   _resetDataOnOpen();
    });
  }

  Future<void> _resetDataOnOpen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_users');
    await prefs.remove('last_fetch_timestamp');
    setState(() {
      _cachedUsers = [];
      _usersByTalent = {};
      _allTalents = [];
    });
    await _fetchUpdates();
  }

  Future<void> _initializeData() async {
    await _loadCachedData();

    _setupDataListener();
  }
  Future<void> _handleManualRefresh() async {
    final oldCount = _cachedUsers.length;

    await _checkForUpdates();
    if (_hasUpdates) {
      await _fetchUpdates();
      final newCount = _cachedUsers.length;

      setState(() {
        _newUsersCount = newCount - oldCount;
      });

      if (_newUsersCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تحميل $_newUsersCount عضو جديد 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا توجد بيانات جديدة'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا توجد تحديثات جديدة'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }


  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_users');
    _lastFetchTimestamp = prefs.getInt('last_fetch_timestamp') ?? 0;

    if (cachedData != null) {
      setState(() {
        _cachedUsers = (json.decode(cachedData) as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        _organizeUsersByTalent(_cachedUsers);
      });
    }
  }

  Future<void> _checkForUpdates() async {
    final authProviders = Provider.of<AuthProviders>(context, listen: false);

    try {
      final metadata = await FirebaseFirestore.instance
          .collection('governorate')
          .doc(authProviders.governorate!)
          .collection('church')
          .doc(authProviders.churchCodeL!)
          .collection('users_church')
          .doc('${authProviders.stageTypeL!}_${authProviders.stageYearL!}_metadata')
          .get();

      if (metadata.exists &&
          metadata['lastUpdate'] > _lastFetchTimestamp) {
        _hasUpdates = true;
      }
    } catch (e) {
      _hasUpdates = true; // افترض وجود تحديثات في حالة الخطأ
    }
  }
  Future<void> _resetAndRefetchData() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_users');
    await prefs.remove('last_fetch_timestamp');

    setState(() {
      _cachedUsers = [];
      _usersByTalent = {};
      _allTalents = [];
      _lastFetchTimestamp = 0; // نبدأ من الصفر
    });

    try {
      final authProviders = Provider.of<AuthProviders>(context, listen: false);
      final snapshot = await FirebaseFirestore.instance
          .collection('governorate')
          .doc(authProviders.governorate!)
          .collection('church')
          .doc(authProviders.churchCodeL!)
          .collection('users_church')
          .doc('${authProviders.stageTypeL!}_${authProviders.stageYearL!}')
          .collection('users')
          .get(); // بدون فلترة التاريخ - نجيب الكل

      final users = await _fetchUsersDetails(snapshot.docs);
      await _updateLocalData(users); // هيحدث الـ _cachedUsers ويحفظهم في الكاش

      final now = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt('last_fetch_timestamp', now);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إعادة تحميل جميع الأعضاء (${users.length}) 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في إعادة التحميل: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchUpdates() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final authProviders = Provider.of<AuthProviders>(context, listen: false);
      final snapshot = await FirebaseFirestore.instance
          .collection('governorate')
          .doc(authProviders.governorate!)
          .collection('church')
          .doc(authProviders.churchCodeL!)
          .collection('users_church')
          .doc('${authProviders.stageTypeL!}_${authProviders.stageYearL!}')
          .collection('users')
          .where('lastModified', isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(_lastFetchTimestamp))
          .get();

      final users = await _fetchUsersDetails(snapshot.docs);
      if (users.isNotEmpty) {
        await _updateLocalData(users);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_fetch_timestamp', DateTime.now().millisecondsSinceEpoch);

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ في جلب التحديثات: ${e.toString()}')),
      );
    }
  }
  void _setupDataListener() {
    final authProviders = Provider.of<AuthProviders>(context, listen: false);

    FirebaseFirestore.instance
        .collection('governorate')
        .doc(authProviders.governorate!)
        .collection('church')
        .doc(authProviders.churchCodeL!)
        .collection('users_church')
        .doc('${authProviders.stageTypeL!}_${authProviders.stageYearL!}')
        .collection('users')
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.docChanges.isNotEmpty) {
        await _processChanges(snapshot.docChanges);
        await _updateMetadata();
      }
    });
  }

  Future<void> _processChanges(List<DocumentChange> changes) async {
    for (var change in changes) {
      if (!change.doc.exists) continue;

      final userData = await _fetchUserDetails(change.doc.reference);
      if (userData == null) continue;

      final userId = userData['id'];
      final index = _cachedUsers.indexWhere((u) => u['id'] == userId);

      setState(() {
        switch (change.type) {
          case DocumentChangeType.added:
            if (index == -1) {
              _cachedUsers.add(userData);
            } else {
              _cachedUsers[index] = userData; // تحديث الموجود
            }
            break;

          case DocumentChangeType.modified:
            if (index != -1) {
              _cachedUsers[index] = userData;
            } else {
              _cachedUsers.add(userData); // احتياطي
            }
            break;

          case DocumentChangeType.removed:
            _cachedUsers.removeWhere((u) => u['id'] == userId);
            break;
        }

        _organizeUsersByTalent(_cachedUsers);
      });
    }

    await _updateLocalCache();
  }
  Future<void> _updateMetadata() async {
    final authProviders = Provider.of<AuthProviders>(context, listen: false);

    await FirebaseFirestore.instance
        .collection('governorate')
        .doc(authProviders.governorate!)
        .collection('church')
        .doc(authProviders.churchCodeL!)
        .collection('users_church')
        .doc('${authProviders.stageTypeL!}_${authProviders.stageYearL!}_metadata')
        .set({
      'lastUpdate': FieldValue.serverTimestamp()
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> _fetchUserDetails(DocumentReference userRef) async {
    final userData = await userRef.collection('user').limit(1).get();
    if (userData.docs.isNotEmpty) {
      final data = userData.docs.first.data();
      data['id'] = userRef.id; // نربط الـ ID الأساسي بالبيانات
      return data;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> _fetchUsersDetails(List<QueryDocumentSnapshot> docs) async {
    final List<Map<String, dynamic>> users = [];

    for (final doc in docs) {
      final userData = await _fetchUserDetails(doc.reference);
      if (userData != null) {
        users.add(userData);
      }
    }

    return users;
  }

  Future<void> _updateLocalData(List<Map<String, dynamic>> newUsers) async {
    final Map<String, Map<String, dynamic>> updatedUsers = {
      for (var user in _cachedUsers) user['id']: user
    };

    for (var user in newUsers) {
      updatedUsers[user['id']] = user; // تحديث أو إضافة
    }

    setState(() {
      _cachedUsers = updatedUsers.values.toList();
      _organizeUsersByTalent(_cachedUsers);
    });

    await _updateLocalCache();
  }

  Future<void> _updateLocalCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_users', json.encode(_cachedUsers));
    await prefs.setInt('last_fetch_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  void _organizeUsersByTalent(List<Map<String, dynamic>> users) {
    _usersByTalent.clear();
    _allTalents.clear();

    for (final user in users) {
      final talent = user['talent'] ?? 'غير محدد';
      if (!_usersByTalent.containsKey(talent)) {
        _usersByTalent[talent] = [];
        _allTalents.add(talent);
      }
      _usersByTalent[talent]!.add(user);
    }

    _allTalents.sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      backgroundColor: Colors.grey[100],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _handleManualRefresh,
        child: Column(
          children: [
            _buildTalentsFilterSection(),
            Expanded(
              child: _showAll && _selectedTalent == null && _searchQuery.isEmpty
                  ? _buildAllTalentsView()
                  : _buildFilteredUsersView(_cachedUsers),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildAllTalentsView() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _allTalents.length,
      itemBuilder: (context, index) {
        final talent = _allTalents[index];
        final users = _usersByTalent[talent]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                talent,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
            ...users.map((user) => _buildMemberCard(user)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildFilteredUsersView(List<Map<String, dynamic>> allUsers) {
    List<Map<String, dynamic>> filteredUsers = allUsers.where((user) {
      if (_selectedTalent != null && user['talent'] != _selectedTalent) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final name = user['name']?.toString() ?? '';
        final talent = user['talent']?.toString() ?? '';
        return name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            talent.toLowerCase().contains(_searchQuery.toLowerCase());
      }

      return true;
    }).toList();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        return _buildMemberCard(filteredUsers[index]);
      },
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> userData) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildUserAvatar(userData),
        title: Text(
          userData['name'] ?? 'بدون اسم',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'الموهبة: ${userData['talent'] ?? 'غير محدد'}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            if (userData['university'] != null)
              Text(
                userData['university'],
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.teal),
          onPressed: () {
            if (userData['whatsapp'] != null) {
              openWhatsApp(userData['whatsapp']);
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserAvatar(Map<String, dynamic> user) {
    final profileUrl = user['profileUrl'] as String?;

    return profileUrl != null && profileUrl.isNotEmpty
        ? ClipOval(
      child: Image.network(
        profileUrl,
        width: 60,
        height: 85,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const CircleAvatar(
            backgroundColor: Colors.white,

            radius: 30,
            backgroundImage: AssetImage(AppAssets.user),
          );
        },
      ),
    )
        : const CircleAvatar(
      backgroundColor: Colors.white,
      radius: 30,
      backgroundImage: AssetImage(AppAssets.user),
    );
  }

  Widget _buildTalentsFilterSection() {
    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade800],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [


          Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                const Text(
                  'Team',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.upcoming_outlined),
                  onPressed: _resetAndRefetchData,
                  color: Colors.white,
                  iconSize: 30,
                ),
                if (_newUsersCount > 0)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        '$_newUsersCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: const InputDecoration(
                          hintText: "ابحث عن عضو أو موهبة...",
                          hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        cursorColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                            _showAll = false;
                          });
                        },
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white, size: 20),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                            _searchFocusNode.unfocus();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: FilterChip(

                    backgroundColor:
                    _showAll ? Colors.blue[300]! : Colors.blue[100]!,
                    selectedColor: Colors.blue[300],
                    label: Text(
                      _showAll ? 'إلغاء الكل' : 'عرض الكل',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                        _showAll ? Colors.white : Colors.teal[800],
                      ),
                    ),
                    selected: _showAll,
                    onSelected: (isSelected) {
                      setState(() {
                        _showAll = isSelected;
                        _selectedTalent = null;
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _allTalents.length,
                    itemBuilder: (context, index) {
                      String talent = _allTalents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FilterChip(
                          backgroundColor: _selectedTalent == talent
                              ? Colors.blue[300]!
                              : Colors.blue[100]!,
                          selectedColor: Colors.teal[300],
                          label: Text(
                            talent,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _selectedTalent == talent
                                  ? Colors.white
                                  : Colors.blue[800],
                            ),
                          ),
                          selected: _selectedTalent == talent,
                          onSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                _selectedTalent = talent;
                                _showAll = false;
                                _searchQuery = '';
                                _searchController.clear();
                              } else {
                                if (_selectedTalent == talent) {
                                  _selectedTalent = null;
                                }
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void openWhatsApp(String whatsapp) async {
    await launchUrl(Uri.parse("https://wa.me/+2$whatsapp?"));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}