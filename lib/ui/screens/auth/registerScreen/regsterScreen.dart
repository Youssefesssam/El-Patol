import 'package:el_patol/ui/screens/auth/registerScreen/registerProvider.dart';
import 'package:el_patol/ui/screens/auth/registerScreen/registerSteps.dart';
import 'package:flutter/material.dart';


import '../../../../l10n/app_localizations.dart';
import '../../utilites/appColors.dart';
import '../loginScreen/loginScreen.dart';
import '_buildAppBar.dart';


class RegisterScreen extends StatefulWidget {
  static const String routeName = "register";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterProvider _provider = RegisterProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade800.withOpacity(0.2),
                  Colors.blue.shade200.withOpacity(0.1),
                ],
              ),
            ),
          ),
          Column(
            children: [
              BuildAppBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SizeTransition(
                                sizeFactor: animation,
                                axis: Axis.vertical,
                                child: child,
                              ),
                            );
                          },
                          child: IndexedStack(
                            key: ValueKey<int>(_provider.currentStep),
                            index: _provider.currentStep,
                            children: RegisterSteps.getSteps(_provider,context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      _buildNavigationButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildNavigationButtons() {
    return Row(
      children: [
        // زر Back على الشمال
        if (_provider.currentStep != 0)
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  _provider.previousStep();
                  setState(() {});
                },
                child: Text(
                  AppLocalizations.of(context)!.back,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade400,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width/30,
                    vertical:  MediaQuery.of(context).size.height/100,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: Colors.blue.shade300,
                ),
              ),
            ),
          )
        else
          Spacer(), // علشان نحافظ على المسافة لما مفيش زر Back

        // زر Next أو Register على اليمين
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () async {
                if (_provider.isUploading) return;

                if (_provider.currentStep == 2) {
                  await _provider.registerUser();
                  print("${_provider.userId}");
                }
                if (_provider.currentStep == 3) {
                  if (_provider.imageUrl != null) {
                    print("^^^^^^ ${_provider.imageUrl}^^^^^^^^^^^^^^^^^^^^");
                    await _provider.saveProfileImage();
                  }

                  Navigator.pushNamed(
                    context,
                    LoginScreen.routeName,
                  );
                } else {
                  await _provider.nextStep(context);
                  setState(() {});
                }
              },
              child: _provider.isUploading && _provider.currentStep == 0
                  ? SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                _provider.currentStep == 3 ? AppLocalizations.of(context)!.register : AppLocalizations.of(context)!.next,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width/30,
                  vertical:  MediaQuery.of(context).size.height/100,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: Colors.blue.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }


}