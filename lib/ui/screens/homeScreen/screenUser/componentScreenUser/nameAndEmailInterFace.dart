import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../utilites/appColors.dart';
import '../../../utilites/consts.dart';

class NameAndEmailInterFace extends StatelessWidget {
  const NameAndEmailInterFace({super.key});



  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders=Provider.of(context);
    return Positioned(
      top: 35,
      left: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(authProviders.name!,style:GoogleFonts.adamina(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.height * .023,
            color: AppColors.white,
            letterSpacing: 1.2,
          ),),
          SizedBox(
            height: 5,
          ),
          Text(authProviders.email!,style:GoogleFonts.adamina(
            fontWeight: FontWeight.bold,

            fontSize: MediaQuery.of(context).size.height * .012,
            color: AppColors.white,
            letterSpacing: 1.2,
          ), ),      ],
      ),
    );
  }
}
