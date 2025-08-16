import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyInfo extends StatelessWidget {
  static const String routeName ='myInfo';
  const MyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Info'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('church')
            .doc('011')
            .collection('master_leader_church')
            .doc('M031026161')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data found'));
          }

          // استخراج البيانات من المستند
          final data = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ListTile(
                title: const Text('code'),
                subtitle: Text(data['code'] ?? 'N/A'),
              ),
              ListTile(
                title: const Text('Name'),
                subtitle: Text(data['name'] ?? 'N/A'),
              ),
              ListTile(
                title: const Text('Email'),
                subtitle: Text(data['email'] ?? 'N/A'),
              ),
              ListTile(
                title: const Text('Phone'),
                subtitle: Text(data['phone'] ?? 'N/A'),
              ),
              ListTile(
                title: const Text('Church'),
                subtitle: Text(data['church'] ?? 'N/A'),
              ),
              ListTile(
                title: const Text('Governorate'),
                subtitle: Text(data['governorate'] ?? 'N/A'),
              ),
              ListTile(
                title: const Text('Role'),
                subtitle: Text(data['role'] ?? 'N/A'),
              ),
              ListTile(
                title: const Text('Specialty'),
                subtitle: Text(data['specialty'] ?? 'N/A'),
              ),

              ListTile(
                title: const Text('Registered At'),
                subtitle: Text(
                  data['registered_at'] != null
                      ? (data['registered_at'] as Timestamp).toDate()
                      .toString()
                      : 'N/A',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}