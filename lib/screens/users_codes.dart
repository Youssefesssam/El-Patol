import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../firebase/authProvider.dart';
import '../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import '../l10n/app_localizations.dart';
import '../ui/screens/utilites/appColors.dart';

class AllUsersCodesScreen extends StatefulWidget {
  static const String routeName = "AllUsersCodesScreen";

  const AllUsersCodesScreen({super.key});

  @override
  State<AllUsersCodesScreen> createState() => _AllUsersCodesScreenState();
}

class _AllUsersCodesScreenState extends State<AllUsersCodesScreen> {
  List<Map<String, String>> users = [];
  List<Map<String, String>> filteredUsers = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cachedUsers');
    final authProviders = Provider.of<AuthProviders>(context, listen: false);

    if (cachedData != null) {
      final List<dynamic> decoded = jsonDecode(cachedData);
      users = decoded.map((e) => Map<String, String>.from(e)).toList();
      filteredUsers = users;
      setState(() => isLoading = false);
    }

    final fetchedUsers = await New_fire_base_get_data_for_leader.fetchAllUsersCodesAndNames(
      governorate: authProviders.governorate!,
      churchCode: authProviders.churchCodeL!,
      stageCode: authProviders.stageCode!,
    );

    // Compare lengths, or you can compare content if needed
    if (fetchedUsers.length != users.length) {
      await prefs.setString('cachedUsers', jsonEncode(fetchedUsers));
      setState(() {
        users = fetchedUsers;
        filteredUsers = users;
        isLoading = false;
      });
    } else {
      // Even if length is same but we had no cache before
      if (cachedData == null) {
        setState(() {
          users = fetchedUsers;
          filteredUsers = users;
          isLoading = false;
        });
      }
    }
  }

  void copyToClipboard(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ $label: $value'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal.shade700,
      ),
    );
  }

  void filterUsers(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        final name = user['name']?.toLowerCase() ?? '';
        final code = user['code']?.toLowerCase() ?? '';
        return name.contains(lowerQuery) || code.contains(lowerQuery);
      }).toList();
    });
  }

  Widget buildInfoRow(String label, String? value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(value ?? '', style: const TextStyle(fontSize: 14)),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 20, color: Colors.teal),
          tooltip: 'انسخ $label',
          onPressed: () {
            if (value != null && value.isNotEmpty) {
              copyToClipboard(label, value);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.usersCode),
        backgroundColor: AppColors.mainColor,
        elevation: 4,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: filterUsers,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.teal.shade300,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user['name'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Column(
                          children: [
                            buildInfoRow(AppLocalizations.of(context)!.code, user['code']),
                            buildInfoRow(AppLocalizations.of(context)!.email, user['email']),
                            buildInfoRow(AppLocalizations.of(context)!.password, user['pass']),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
