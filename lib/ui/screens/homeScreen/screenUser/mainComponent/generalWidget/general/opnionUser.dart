import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';


import '../../../../../../../firebase/authProvider.dart';
import '../../../../../../../firebase/fireBase/fireBaseForUser/New_fire_base_set_data_for_user.dart';
import '../../../../../../../l10n/app_localizations.dart';


class OpinionUser extends StatelessWidget {
  OpinionUser({super.key});

  final TextEditingController opinion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // خط السحب
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.writeYourOpinion,
                      style: GoogleFonts.abyssinicaSil(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.favorite, size: 20, color: Colors.blue.shade900),
                  ],
                ),
                const SizedBox(height: 30),

                // صورة رمزية لحدث
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .12,
                    width: MediaQuery.of(context).size.width * .5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade900, Colors.blue[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.8),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.event,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // حقل إدخال النص
                TextField(
                  controller: opinion,
                  maxLines: 2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    hintText: AppLocalizations.of(context)!.typeYourOpinionHere,
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: GoogleFonts.poppins(color: Colors.grey[800]),
                ),
                const SizedBox(height: 40),

                // أزرار المشاركة والخروج
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: SlideAction(
                        innerColor: Colors.white,
                        outerColor: Color(0xffd32f2f),
                        // تغيير اللون الأحمر إلى أحمر أغمق
                        elevation: 10,
                        textColor: Colors.white,
                        sliderButtonIconSize: 10,
                        sliderButtonIconPadding: 8,
                        animationDuration: Duration(milliseconds: 200),

                        sliderButtonIcon: Icon(
                          Icons.exit_to_app,
                          size: 25,
                          color: Color(0xffd32f2f),

                        ),
                        submittedIcon: Icon(
                          Icons.check,
                          size: 30,
                          color: Colors.white,
                        ),
                        key: GlobalKey<SlideActionState>(),
                        onSubmit: () {
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: 20),
                            Text(
                              AppLocalizations.of(context)!.exit, // تصحيح التسمية إلى Exit
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: SlideAction(
                        innerColor: Colors.white,
                        outerColor: Colors.blue.shade900,
                        elevation: 10,
                        textColor: Colors.white,
                        sliderButtonIconSize: 10,
                        sliderButtonIconPadding: 8,
                        animationDuration: Duration(milliseconds: 450),
                        sliderButtonIcon: Transform(
                          alignment: Alignment.center,
                          transform: AppLocalizations.of(context)!.language == "العربية"
                              ? Matrix4.rotationY(3.14) // يقلب الاتجاه للعربي
                              : Matrix4.identity(),     // يسيبه زي ما هو للإنجليزي
                          child: Icon(
                            Icons.send,
                            size: 20,
                            color: Colors.blue.shade900,
                          ),
                        ),

                        submittedIcon: Icon(
                          Icons.check,
                          size: 30,
                          color: Colors.white,
                        ),
                        key: GlobalKey<SlideActionState>(),
                        onSubmit: () async {
                          // أضف async هنا
                          await New_fire_base_set_data_for_user.addOpinionUser(
                            opinionText: opinion.text,
                            userId: authProviders.userId!,
                            governorateUs: authProviders.governorateUs??authProviders.governorate!,
                            churchCodeUs: authProviders.churchCodeUs??authProviders.churchCodeL!,
                            stageCodeUs: authProviders.stageCodeUs??authProviders.stageCode!,
                          ); // استخدم await
                          opinion.clear(); // مسح النص بعد اكتمال العملية
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.share,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
