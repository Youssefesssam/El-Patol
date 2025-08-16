import 'package:easy_stepper/easy_stepper.dart';
import 'package:el_patol/ui/screens/auth/registerScreen/registerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../utilites/appColors.dart';

class BuildAppBar extends StatefulWidget {
  const BuildAppBar({super.key});

  @override
  State<BuildAppBar> createState() => _BuildAppBarState();
}

class _BuildAppBarState extends State<BuildAppBar> {
  @override
  Widget build(BuildContext context) {
   // final RegisterProvider _provider = RegisterProvider();
    final _provider = Provider.of<RegisterProvider>(context);

    return Container(
      padding: const EdgeInsets.only(
        top: 50,
        bottom: 10,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.appBarColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade800.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
               Text(
                AppLocalizations.of(context)!.createAccount,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 0),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: EasyStepper(
              activeStep: _provider.currentStep,
              stepRadius: MediaQuery.of(context).size.width * .05,
              activeStepBorderColor: Colors.white,
              finishedStepBorderColor: Colors.white,
              unreachedStepTextColor: Colors.white.withOpacity(0.7),
              unreachedStepIconColor: Colors.white.withOpacity(0.7),
              unreachedStepBorderColor: Colors.white.withOpacity(0.3),
              activeStepBackgroundColor: Colors.blue.shade700,
              finishedStepBackgroundColor: Colors.blue.shade400,
              activeStepTextColor: Colors.white,
              finishedStepTextColor: Colors.white,
              activeStepIconColor: Colors.white,
              finishedStepIconColor: Colors.white,
              borderThickness: 2,
              padding: EdgeInsets.all(8),
              stepShape: StepShape.rRectangle,
              stepBorderRadius: 20,
              steps: [
                EasyStep(
                  enabled: false,
                  title: AppLocalizations.of(context)!.basicInfo,
                  icon: const Icon(Icons.person_outline),
                ),
                 EasyStep(
                  enabled: false,
                  title: AppLocalizations.of(context)!.details,
                  icon: Icon(Icons.assignment_outlined),
                ),
                 EasyStep(
                  enabled: false,
                  title: AppLocalizations.of(context)!.moreDetails,
                  icon: Icon(Icons.assignment_outlined),
                ),
                 EasyStep(
                  enabled: false,
                  title: AppLocalizations.of(context)!.profile,
                  icon: Icon(Icons.camera_alt_outlined),
                ),
              ],
              onStepReached: (index) {
                setState(() => _provider.currentStep = index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
