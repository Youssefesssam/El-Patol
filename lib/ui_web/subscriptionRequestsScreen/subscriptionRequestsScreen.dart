import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionRequestsScreen extends StatefulWidget {
  final String teacherId;
  final String centerId;
  static const String routeName = 'subscriptionRequestsScreen';

  const SubscriptionRequestsScreen({
    super.key,
    required this.teacherId,
    required this.centerId,
  });

  @override
  State<SubscriptionRequestsScreen> createState() =>
      _SubscriptionRequestsScreenState();
}

class _SubscriptionRequestsScreenState
    extends State<SubscriptionRequestsScreen> with TickerProviderStateMixin {
  final List<String> stages = ["الصف الأول الإعدادي", "الصف الثاني الإعدادي", "الصف الثالث الإعدادي"];
  final Map<String, String> stageDocMap = {"الصف الأول الإعدادي": "P_1", "الصف الثاني الإعدادي": "P_2", "الصف الثالث الإعدادي": "P_3"};

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final tabController = TabController(length: stages.length, vsync: this);

    return Scaffold(
      appBar: AppBar(
        title: const Text("طلبات الاشتراك"),
        bottom: TabBar(controller: tabController, tabs: stages.map((s) => Tab(text: s)).toList()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "ابحث بالاسم أو الكود",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => searchText = val.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: stages.map((stage) {
                final stageDocId = stageDocMap[stage]!;
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('center')
                      .doc(widget.centerId)
                      .collection('Mr')
                      .doc(widget.teacherId)
                      .collection('modules')
                      .doc(stageDocId)
                      .collection('subscriptionRequests')
                      .where("status", isEqualTo: "pending")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                    var docs = snapshot.data!.docs;
                    if (searchText.isNotEmpty) {
                      docs = docs.where((d) {
                        final data = d.data() as Map<String, dynamic>;
                        final name = (data["studentName"] ?? "").toString().toLowerCase();
                        final id = (data["studentId"] ?? "").toString().toLowerCase();
                        return name.contains(searchText) || id.contains(searchText);
                      }).toList();
                    }

                    if (docs.isEmpty) return const Center(child: Text("لا توجد طلبات"));

                    return ListView(
                      padding: const EdgeInsets.all(12),
                      children: docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final studentId = data["studentId"];
                        final studentName = data["studentName"];
                        final moduleId = data["moduleId"];
                        final price = data["price"];
                        final time = (data["timestamp"] as Timestamp).toDate();
                        final title = data["title"];

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(studentName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("الكود: $studentId"),
                                Text("الموديول: $title"),
                                Text("السعر: $price ج.م"),
                                Text("التاريخ: ${DateFormat('dd/MM/yyyy hh:mm a').format(time)}"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('center')
                                        .doc(widget.centerId)
                                        .collection('Student')
                                        .doc(stageDocId)
                                        .collection('users')
                                        .doc(studentId)
                                        .update({"paidModules.${widget.teacherId}_$moduleId": false});

                                    await doc.reference.update({"status": "rejected"});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('center')
                                        .doc(widget.centerId)
                                        .collection('Student')
                                        .doc(stageDocId)
                                        .collection('users')
                                        .doc(studentId)
                                        .update({"paidModules.${widget.teacherId}_$moduleId": true});

                                    await doc.reference.update({"status": "approved"});
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
