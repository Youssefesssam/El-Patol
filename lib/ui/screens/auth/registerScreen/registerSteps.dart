import 'dart:ui';

import 'package:el_patol/ui/screens/auth/registerScreen/registerProvider.dart';
import 'package:el_patol/ui/screens/auth/registerScreen/registerUtils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


import '../../../../l10n/app_localizations.dart';
import 'locationService.dart';



class RegisterSteps {
  static List<Widget> getSteps(RegisterProvider provider,BuildContext context) {
    return [
      _buildStepOne(provider,context),
      _buildStepTwo(provider,context),
      _buildStepThree(provider,context),
      _buildStepFour(provider,context),
    ];
  }

  static Widget _buildStepOne(RegisterProvider provider,BuildContext context) {
    return Form(
      key: provider.formKeys[0],
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: RegisterUtils.buildStepContainer([
          SizedBox(height: 15),
          Text(
            AppLocalizations.of(context)!.basicInfo,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          RegisterUtils.buildTextFieldWithIcon(
            AppLocalizations.of(context)!.firstName,
            Icons.person_outline,
                (value) => provider.firstName = value,
            provider: provider,
          ),
          const SizedBox(height: 20),
          RegisterUtils.buildTextFieldWithIcon(
            AppLocalizations.of(context)!.lastName,
            Icons.person_outline,
                (value) => provider.lastName = value,
            provider: provider,
          ),
          const SizedBox(height: 20),
          RegisterUtils.buildTextFieldWithIcon(
            "Email",
            Icons.email_outlined,
                (value) => provider.email = value,
            provider: provider,
            controller: provider.emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 20),
          RegisterUtils.buildTextPassFieldWithIcon(
            "Password",
            Icons.lock_outline,
                (value) => provider.password = value,
            provider: provider,
            controller: provider.passController,
            obscure: true,
            isPassword: true, // ✅ علشان تظهر شروط الباسورد
          ),

          SizedBox(height: 20),
          RegisterUtils.buildTextFieldWithIcon(
            "Code Number",
            hintText: " U 1 2 3 4 5 6 ",
            Icons.confirmation_num_outlined,
                (value) => provider.code = value,
            provider: provider,
          ),
        ]),
      ),
    );
  }

  static Widget _buildStepTwo(RegisterProvider provider,BuildContext context) {
    return Form(
      key: provider.formKeys[1],
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: RegisterUtils.buildStepContainer([
          SizedBox(height: 15),
          Text(
            AppLocalizations.of(context)!.additionalDetails,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          RegisterUtils.buildTalentDropdown(provider),
          SizedBox(height: 20),
          RegisterUtils.buildTextFieldWithIcon(
            AppLocalizations.of(context)!.university,
            Icons.school_outlined,
                (value) => provider.university = value,
            provider: provider,
          ),
          SizedBox(height: 20),
          RegisterUtils.buildTextFieldDateWithIcon(
            AppLocalizations.of(context)!.birthDay,
            Icons.date_range_outlined,
                (value) => provider.birthDay = value,
            provider: provider,
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                provider.birthDay = formattedDate;
                provider.notifyListeners(); // عشان يتحدث الـ UI لو بيستخدم Consumer أو Provider
              }
            },
          ),

          SizedBox(height: 20),
          RegisterUtils.buildTextFieldWithIcon(
            AppLocalizations.of(context)!.phoneNumber,
            Icons.phone_outlined,
                (value) => provider.phone = value,
            provider: provider,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 20),
          RegisterUtils.buildGenderDropdown(provider),
          SizedBox(height: 30),
        ]),
      ),
    );
  }

  static Widget _buildStepThree(RegisterProvider provider,BuildContext context) {
    return Form(
      key: provider.formKeys[2],
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: RegisterUtils.buildStepContainer([
          SizedBox(height: 15),
          Text(
            AppLocalizations.of(context)!.moreDetails,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          RegisterUtils.buildTextFieldLocationWithIcon(
            AppLocalizations.of(context)!.address,
            hintText: "العنوان بالتفاصيل",
            icon: Icons.home_filled,
            onChanged: (value) => provider.address = value,
            provider: provider,
            suffixIcon: IconButton(
              icon: const Icon(Icons.my_location, color: Colors.blue),
                onPressed: () async {
                  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                  if (!serviceEnabled) {
                    await Geolocator.openLocationSettings();
                    return;
                  }

                  LocationPermission permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission == LocationPermission.denied) {
                      print("❌ تم رفض إذن الموقع.");
                      return;
                    }
                  }

                  if (permission == LocationPermission.deniedForever) {
                    print("❌ لا يمكن طلب إذن الموقع مرة أخرى.");
                    return;
                  }

                  // ✅ هنا تحط السطر اللي قلتلك عليه
                  final position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                    forceAndroidLocationManager: true,
                  );

                  final address = await LocationService.getAddressFromCoordinates(position);
                  if (address != null) {
                    provider.setAddress(address);
                  } else {
                    print("⚠️ تعذر تحويل الإحداثيات إلى عنوان.");
                  }
                }
            ),
          ),

          SizedBox(height: 30),
          RegisterUtils.buildTextFieldWithIcon(
            "Facebook",
            hintText: "facebook url",
            Icons.facebook,
                (value) => provider.facebook = value,
            provider: provider,
          ),
          SizedBox(height: 20),
          RegisterUtils.buildTextFieldWithIcon(
            "ًWahtsapp",
            Icons.phone_android_rounded,
                (value) => provider.whatsapp = value,
            provider: provider,
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  static Widget _buildStepFour(RegisterProvider provider,BuildContext context) {
    return Form(
      key: provider.formKeys[3],
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: RegisterUtils.buildStepContainer([
          SizedBox(height: 15),
          Text(
            AppLocalizations.of(context)!.profile,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                if (provider.imageUrl == null)
                  GestureDetector(
                    onTap: () => provider.uploadImage(context),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey[200],
                      child: provider.isUploading
                          ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, size: 40, color: Colors.grey[600]),
                          SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.addPicture,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (provider.imageUrl != null)
                  GestureDetector(
                    onTap: () => provider.uploadImage(context),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 10, end: provider.isUploading ? 10 : 0),
                      duration: Duration(seconds: 2),
                      builder: (context, value, child) {
                        return Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(provider.imageUrl!),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.blue.shade400,
                              width: 3,
                            ),
                          ),
                          child: Stack(
                            children: [
                              if (provider.isUploading)
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: value,
                                    sigmaY: value,
                                  ),
                                  child: Container(color: Colors.transparent),
                                ),
                              if (provider.isUploading)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.2),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 10),
                if (provider.imageUrl != null)
                  Text(
                    AppLocalizations.of(context)!.addPicture,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => provider.uploadImage(context),
            icon: Icon(Icons.upload_outlined),
            label: Text(
              provider.imageUrl == null ? "Upload Profile Picture" : "Change Picture",
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade400,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              shadowColor: Colors.blue.shade300,
            ),
          ),
          SizedBox(height: 30),
        ]),
      ),
    );
  }

}