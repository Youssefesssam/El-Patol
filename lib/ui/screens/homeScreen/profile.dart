import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../firebase/authProvider.dart';
import '../../../firebase/fireBase/fireBaseForUser/New_fire_base_set_data_for_user.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = "UserProfilePage";

  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isEditing = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final talentController = TextEditingController();
  final BDController = TextEditingController();
  final facebookController = TextEditingController();
  final whatsappController = TextEditingController();
  final universityController = TextEditingController();
  String selectedGender = "male";
  String originalProfile = "";
  String? newProfileUrl;
  String originalName = "";
  String originalEmail = "";
  String originalPhone = "";
  String originalAddress = "";
  String originalTalent = "";
  String originalBD = "";
  String originalFacebook = "";
  String originalWhatsapp = "";
  String originalUniversity = "";
  String originalGender = "";
  bool isUploadingImage = false;
  double blurValue = 0;
  File? _selectedImageFile; // ملف الصورة المختارة مؤقتاً

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  static Future<String?> uploadImageFileToImgBB(File imageFile) async {
    String apiKey = "0ad219bb6e48aab453b37fc28ac923ed"; // 🔥 نفس الـ API Key بتاعك
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey"),
    );
    request.files.add(
      await http.MultipartFile.fromPath("image", imageFile.path),
    );
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = json.decode(await response.stream.bytesToString());
      return responseData["data"]["url"]; // 🔥 رابط الصورة المرفوعة
    } else {
      print("❌ فشل الرفع: ${response.statusCode}");
      return null;
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? "";
      emailController.text = prefs.getString('email') ?? "";
      phoneController.text = prefs.getString('phone') ?? "";
      addressController.text = prefs.getString('address') ?? "";
      talentController.text = prefs.getString('talent') ?? "Singing";
      universityController.text = prefs.getString('university') ?? "";
      selectedGender = prefs.getString('gender') ?? "male";
      originalProfile = prefs.getString("profile") ?? "";
      BDController.text = prefs.getString("age") ?? "";
      facebookController.text = prefs.getString("facebook") ?? "";
      whatsappController.text = prefs.getString("whatsapp") ?? "";

      originalName = nameController.text;
      originalEmail = emailController.text;
      originalPhone = phoneController.text;
      originalAddress = addressController.text;
      originalTalent = talentController.text;
      originalUniversity = universityController.text;
      originalGender = selectedGender;
      originalBD = BDController.text;
      originalFacebook = facebookController.text;
      originalWhatsapp = whatsappController.text;

      newProfileUrl = originalProfile;
    });
  }

  Future<void> _pickImage() async {
    setState(() {
      isUploadingImage = true;
      blurValue = 10;
    });

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
        newProfileUrl = pickedFile.path; // عرض الصورة فورًا
      });
    }

    // بعد ما تختاري الصورة، شيل البلور
    setState(() {
      isUploadingImage = false;
      blurValue = 0;
    });
  }

  Future<void> _saveUserData() async {
    AuthProviders authProviders = Provider.of(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> updatedData = {};

    // رفع الصورة أولاً إذا تم اختيار صورة جديدة
    if (_selectedImageFile != null) {
      setState(() {
        isUploadingImage = true;
      });

      try {
        String? uploadedImageUrl = await uploadImageFileToImgBB(_selectedImageFile!);
        if (uploadedImageUrl != null) {
          await New_fire_base_set_data_for_user.saveProfileUrlToFirestore(
            imageUrl: uploadedImageUrl,
            userId: authProviders.userId!,
            governorate: authProviders.governorateUs!,
            churchCode: authProviders.churchCodeUs!,
            stage: authProviders.stageCodeUs!,
            userCode: authProviders.codeUs!,
          );

          await prefs.setString('profile', uploadedImageUrl);
          newProfileUrl = uploadedImageUrl;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading image: $e")),
        );
      } finally {
        setState(() {
          isUploadingImage = false;
        });
      }
    }

    // تحديث البيانات الأخرى
    if (nameController.text != originalName) {
      updatedData['name'] = nameController.text;
      await prefs.setString('name', nameController.text);
    }
    if (BDController.text != originalBD) {
      updatedData['birthDay'] = BDController.text;
      await prefs.setString('birthDay', BDController.text);
    }
    if (facebookController.text != originalFacebook) {
      updatedData['facebook'] = facebookController.text;
      await prefs.setString('facebook', facebookController.text);
    }
    if (whatsappController.text != originalWhatsapp) {
      updatedData['whatsapp'] = whatsappController.text;
      await prefs.setString('whatsapp', whatsappController.text);
    }
    if (phoneController.text != originalPhone) {
      updatedData['phone'] = phoneController.text;
      await prefs.setString('phone', phoneController.text);
    }
    if (addressController.text != originalAddress) {
      updatedData['address'] = addressController.text;
      await prefs.setString('address', addressController.text);
    }
    if (talentController.text != originalTalent) {
      updatedData['talent'] = talentController.text;
      await prefs.setString('talent', talentController.text);
    }
    if (universityController.text != originalUniversity) {
      updatedData['university'] = universityController.text;
      await prefs.setString('university', universityController.text);
    }
    if (selectedGender != originalGender) {
      updatedData['gender'] = selectedGender;
      await prefs.setString('gender', selectedGender);
    }

    if (updatedData.isNotEmpty) {
      await authProviders.updateUserData(
        updatedData: updatedData,
        governorate: authProviders.governorateUs!,
        church: authProviders.churchCodeUs!,
        stage: authProviders.stageCodeUs!,
        code: authProviders.codeUs!,
        userId: authProviders.userId!,
      );
    }

    authProviders.setUserData();
    setState(() => isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProviders>(context);
    final size = MediaQuery.of(context).size;
    final profileSize = size.width * 0.4;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal[800],
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.white),
            onPressed: () async {
              if (isEditing) {
                await _saveUserData();
              } else {
                setState(() => isEditing = true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: profileSize,
                      height: profileSize,
                      child: Stack(
                        children: [
                          // عرض الصورة المختارة أو الصورة الحالية
                          if (_selectedImageFile != null)
                            Image.file(
                              _selectedImageFile!,
                              width: profileSize,
                              height: profileSize,
                              fit: BoxFit.cover,
                            )
                          else if (newProfileUrl != null && newProfileUrl!.isNotEmpty)
                            Image.network(
                              newProfileUrl!,
                              width: profileSize,
                              height: profileSize,
                              fit: BoxFit.cover,
                            )
                          else if (auth.profileURl != null && auth.profileURl!.isNotEmpty)
                              Image.network(
                                auth.profileURl!,
                                width: profileSize,
                                height: profileSize,
                                fit: BoxFit.cover,
                              )
                            else
                              Container(
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.person,
                                  size: profileSize * 0.6,
                                  color: Colors.grey[600],
                                ),
                              ),

                          // تأثير البلور أثناء التحميل
                          if (isUploadingImage)
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: blurValue,
                                sigmaY: blurValue,
                              ),
                              child: Container(
                                color: Colors.black.withOpacity(0.3),
                                width: profileSize,
                                height: profileSize,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // مؤشر التحميل
                  if (isUploadingImage)
                    Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                          strokeWidth: 3,
                        ),
                      ),
                    ),

                  // زر اختيار الصورة (يظهر فقط في وضع التعديل)
                  if (isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.teal,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildProfileItem("Name", nameController),
            buildProfileItem("Email", emailController),
            buildProfileItem("Phone", phoneController),
            buildProfileItem("Address", addressController),
            buildProfileItem("Talent", talentController),
            buildProfileItem("University", universityController),
            buildProfileItem("BirthDay", BDController),
            buildProfileItem("Facebook", facebookController),
            buildProfileItem("Whatsapp", whatsappController),
            buildGenderItem(),
            const SizedBox(height: 20),
            if (!isEditing)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => setState(() => isEditing = true),
                child: const Text("Edit Profile",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileItem(String title, TextEditingController controller) {
    final isEmail = title.toLowerCase() == "email";
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: isEmail ? false : isEditing,
            style: TextStyle(color: isEmail ? Colors.grey : Colors.black),
            decoration: InputDecoration(
              border: (isEmail || !isEditing)
                  ? InputBorder.none
                  : const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGenderItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gender",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal)),
          const SizedBox(height: 8),
          isEditing
              ? DropdownButtonFormField<String>(
            value: selectedGender,
            items: ["male", "female"].map((gender) {
              return DropdownMenuItem(value: gender, child: Text(gender));
            }).toList(),
            onChanged: (val) => setState(() => selectedGender = val!),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          )
              : Text(
            selectedGender,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}