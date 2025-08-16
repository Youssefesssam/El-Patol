import 'package:el_patol/ui/screens/auth/registerScreen/registerProvider.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../utilites/appColors.dart';
import '../loginScreen/loginScreen.dart';

class BuildNavigationButtons extends StatefulWidget {
  const BuildNavigationButtons({super.key});

  @override
  State<BuildNavigationButtons> createState() => _BuildNavigationButtonsState();
}
final RegisterProvider _provider = RegisterProvider();

class _BuildNavigationButtonsState extends State<BuildNavigationButtons> {
  @override
  Widget build(BuildContext context) {
   return Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [
       ElevatedButton(
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
             print("^^^^^^ ${_provider.imageUrl}^^^^^^^^^^^^^^^^^^^^");

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
           width: 20,
           height: 20,
           child: CircularProgressIndicator(
             color: Colors.white,
             strokeWidth: 2,
           ),
         )
             : Text(
           _provider.currentStep == 3 ?AppLocalizations.of(context)!.register : AppLocalizations.of(context)!.next,
           style: TextStyle(
             fontSize: 16,
             color: AppColors.white,
           ),
         ),
         style: ElevatedButton.styleFrom(
           backgroundColor: Colors.blue.shade700,
           padding: EdgeInsets.symmetric(
             horizontal: 32,
             vertical: 14,
           ),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(12),
           ),
           elevation: 5,
           shadowColor: Colors.blue.shade600,
         ),
       ),

       if (_provider.currentStep != 0)
         ElevatedButton(
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
               horizontal: 32,
               vertical: 14,
             ),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12),
             ),
             elevation: 5,
             shadowColor: Colors.blue.shade300,
           ),
         ),
     ],
   );

  }
}
