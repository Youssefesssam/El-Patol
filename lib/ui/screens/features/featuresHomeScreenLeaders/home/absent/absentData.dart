import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../firebase/authProvider.dart';
import '../../../../utilites/appColors.dart';
import '../../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';

class AbsentData extends StatefulWidget {
  static const String routeName = "absentData";

  const AbsentData({super.key});

  @override
  State<AbsentData> createState() => _AbsentDataState();
}

class _AbsentDataState extends State<AbsentData> {
  void openWhatsApp(String whatsapp) async {
    await launchUrl(Uri.parse("https://wa.me/+2$whatsapp?text=اهلين"));
  }

  void openPhone(String phone) async {
    await launchUrl(Uri.parse("tel:$phone"));
  }

  void getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      double lat = locations.first.latitude;
      double lng = locations.first.longitude;
      final url = Uri.parse(
          "https://www.google.com/maps/search/?api=1&query=$lat,$lng");
      await launchUrl(url);
    } catch (e) {
      print("Error: $e");
    }
  }

  void openFacebook(String link) async {
    final url = Uri.parse(link);
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);

    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String profile = args["profile"];
    String name = args["name"];
    String email = args["email"];
    String phone = args["phone"];
    String address = args["address"];
    String whatsapp = args["whatsapp"];
    String facebook = args["facebook"];
    String id = args["id"];
    String code = args["code"];
    late int lackUser;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.only(top: 0, bottom: 30, left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.appBarColor,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// ✅ Avatar and Lack Counter
                  StreamBuilder<int>(
                    stream: New_fire_base_set_data_for_leader.streamLackWeek(
                      id: id,
                      governorate: authProviders.governorate!,
                      church: authProviders.churchCodeL!,
                      code: code,
                      stage: authProviders.stageCode!,
                    ),
                    builder: (context, snapshot) {
                      final lack = snapshot.data ?? 0;


                      return Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(profile),
                                backgroundColor: Colors.white,
                              ),
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    "+$lack",
                                    style: TextStyle(
                                        fontSize: 15, color: AppColors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.teal.shade100,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),

            // Info Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => openPhone(phone),
                    child: buildInfoCard(Icons.phone, "Phone", phone),
                  ),
                  InkWell(
                    onTap: () => getLatLngFromAddress(address),
                    child: buildInfoCard(Icons.location_on, "Address", address),
                  ),
                  InkWell(
                    onTap: () => openWhatsApp(whatsapp),
                    child:
                    buildInfoCard(Icons.phone_android, "WhatsApp", whatsapp),
                  ),
                  InkWell(
                    onTap: () => openFacebook(facebook),
                    child: buildInfoCard(Icons.facebook, "Facebook", facebook),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal[100],
          child: Icon(icon, color: Colors.teal[900]),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
