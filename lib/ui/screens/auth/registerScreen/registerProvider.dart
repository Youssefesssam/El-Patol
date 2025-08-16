import 'dart:typed_data';
import 'dart:io'; // لـ File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import '../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../firebase/fireBase/fireBaseForUser/New_fire_base_set_data_for_user.dart';
import '../../../../model/modelUser.dart';
import '../../../../services/governorateserveces.dart';

class RegisterProvider with ChangeNotifier {
  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  int _currentStep = 0;
  String? selectedTalent;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  String university = "";
  String phone = "";
  String whatsapp = "";
  String? gender;
  String address = "";
  String code = "";
  String facebook = "";
  String birthDay = "";
  bool isUploading = false;
  double blurValue = 0;
  String? imageUrl;
  String? userId;
  late String churchCode;
  late String stageCode;
  late String governateCode;
  late String stageType;
  late String stageYear;

  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String? selectedGovernorate;

  void setAddress(String newAddress) {
    address = newAddress;
    notifyListeners();
  }


  int get currentStep => _currentStep;
  set currentStep(int value) {
    _currentStep = value;
    notifyListeners();
  }

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void setSelectedTalent(String value) {
    selectedTalent = value;
    notifyListeners();
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Za-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  Future<bool> isEmailAlreadyRegistered(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Widget _buildAspectButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
        ),
        const SizedBox(height: 10),
        Text(label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            )),
      ],
    );
  }

  Future<String?> uploadImage(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      isUploading = true;
      blurValue = 10;
      notifyListeners();

      final Uint8List imageData = await pickedFile.readAsBytes();
      final cropController = CropController();
      double aspectRatio = 1;

      String? finalImageUrl;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setLocalState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('اقتصاص الصورة',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              )),
                          Icon(Icons.exit_to_app, color: Colors.red[900], size: 30)
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[100],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Crop(
                            controller: cropController,
                            image: imageData,
                            aspectRatio: aspectRatio,
                            onCropped: (croppedData) async {
                              Navigator.of(context, rootNavigator: true).pop();

                              final tempDir = await getTemporaryDirectory();
                              final filePath = '${tempDir.path}/cropped_image.png';
                              final file = await File(filePath).writeAsBytes(croppedData);

                              String? uploadedImageUrl =
                              await New_fire_base_get_data_for_leader.uploadImageToImgBB(file: file);

                              if (uploadedImageUrl != null) {
                                imageUrl = uploadedImageUrl;
                                finalImageUrl = uploadedImageUrl;
                                await saveProfileImage();
                              }

                              isUploading = false;
                              blurValue = 0;
                              notifyListeners();
                            },
                            maskColor: Colors.black.withOpacity(0.5),
                            cornerDotBuilder: (size, edge) =>
                            const DotControl(color: Colors.teal),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAspectButton(
                            icon: Icons.crop_square,
                            label: 'مربع',
                            color: Colors.blue.shade900,
                            onTap: () {
                              setLocalState(() => aspectRatio = 1);
                              cropController.aspectRatio = 1;
                            },
                          ),
                          _buildAspectButton(
                            icon: Icons.crop_16_9,
                            label: 'مستطيل',
                            color: Colors.blue.shade900,
                            onTap: () {
                              setLocalState(() => aspectRatio = 3 / 2);
                              cropController.aspectRatio = 3 / 2;
                            },
                          ),
                          _buildAspectButton(
                            icon: Icons.crop_free,
                            label: 'حر',
                            color: Colors.blue.shade900,
                            onTap: () {
                              setLocalState(() => aspectRatio = 0);
                              cropController.aspectRatio = null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('تأكيد الاقتصاص'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: GoogleFonts.poppins(fontSize: 16),
                        ),
                        onPressed: () => cropController.crop(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );

      return finalImageUrl;
    } catch (e) {
      isUploading = false;
      blurValue = 0;
      notifyListeners();
      debugPrint('Image upload error: $e');
      return null;
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  Future<void> nextStep(BuildContext context) async {
    if (!formKeys[_currentStep].currentState!.validate()) return;

    if (_currentStep == 0) {
      if (!isValidEmail(email)) {
        showErrorMessage(context, "البريد الإلكتروني غير صحيح");
        return;
      }

      if (!isValidPassword(password)) {
        showErrorMessage(context, "كلمة المرور يجب أن تحتوي على رقم وحرف وألا تقل عن 8 حروف");
        return;
      }

      isUploading = true;
      notifyListeners();

      try {
        if (await isEmailAlreadyRegistered(email)) {
          showErrorMessage(context, "هذا البريد الإلكتروني مسجل بالفعل");
          return;
        }
        if (await checkCode(codeController.text) == false) {
          showErrorMessage(context, "الكود غير صحيح");
          return;
        }
      } finally {
        isUploading = false;
        notifyListeners();
      }
    }

    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    }
  }

  Future<bool> registerUser() async {
    try {
      String emailToUse = emailController.text.trim();
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailToUse,
        password: password,
      );

      userId = userCredential.user!.uid;
      notifyListeners();

      MyUser myUser = MyUser(
        name: "$firstName $lastName",
        id: userId!,
        email: emailToUse,
        phone: phone,
        pass: passController.text,
        address: address,
        gender: gender!,
        talent: selectedTalent!,
        university: university,
        profileUrl: imageUrl ?? '',
        code: code,
        rank: 0,
        lack: 0,
        lackWeek: 0,
        facebook: facebook,
        whatsapp: whatsapp,
        birthDay: birthDay,
      );

      await New_fire_base_set_data_for_leader.addUser(
        myUser: myUser,
        churchCode: churchCode,
        stageCode: stageCode,
        userCode: code,
        governate: governateCode,
      );

      return true;
    } catch (e) {
      debugPrint("Registration error: $e");
      return false;
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool> checkCode(String userCode) async {
    if (code.isNotEmpty && code.length >= 7 && code.startsWith('U')) {
      governateCode = code.substring(1, 3);
      governateCode = GovernorateService.getName(governateCode, 'en');
      churchCode = code.substring(3, 6);
      stageType = code[6];
      stageYear = code.length > 7 ? code.substring(7, 8) : 'X';
    } else {
      churchCode = 'XXX';
      stageType = 'X';
      stageYear = 'X';
    }

    stageCode = '${stageType}_$stageYear';

    var snapshot = await FirebaseFirestore.instance
        .collection("governorate")
        .doc(governateCode)
        .collection('church')
        .doc(churchCode)
        .collection('users_church')
        .doc(stageCode)
        .collection('users')
        .doc(code)
        .get();

    return snapshot.exists;
  }

  Future<void> saveProfileImage() async {
    if (imageUrl != null && userId != null) {
      await New_fire_base_set_data_for_user.saveProfileUrlToFirestore(
        imageUrl: imageUrl!,
        userId: userId!,
        governorate: governateCode,
        churchCode: churchCode,
        stage: stageCode,
        userCode: code,
      );
    }
  }
}
