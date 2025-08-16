import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../homeScreen/screenUser/mainComponent/compitionWidget/compettion/natification/natification.dart';

class DesignCard extends StatelessWidget {
  final String titleCard;
  final String? path;
  final Color colorNatification;
  final bool appearNatification;
  final int numNatification;

  DesignCard({
    super.key,
    required this.titleCard,
    required this.appearNatification,
    required this.colorNatification,
    required this.numNatification,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(

            width: 200,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                 titleCard,
                  style: GoogleFonts.aclonica(fontSize: 20, color: Colors.black, letterSpacing: 1.2,),
                ),
                const SizedBox(height: 10),
                if (path != null)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(path!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (appearNatification)
            Positioned(
              top: -10,
              right: -8,
              child: Notifications(
                color: colorNatification,
                appear: appearNatification,
                num: numNatification, appearIcon: false,
              ),
            ),
        ],
      ),
    );
  }
}
