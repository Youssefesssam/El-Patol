import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../model/modelUserAttend.dart';
import '../../../../utilites/appAssets.dart';

class CardUserAttend extends StatefulWidget {
  final User users;
  String image;

  CardUserAttend({
    super.key,
    required this.users,
    required this.image,
  });

  @override
  _CardUserAttend createState() => _CardUserAttend();
}

class _CardUserAttend extends State<CardUserAttend> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    TextStyle stylishText(double size,
        {Color color = Colors.white, FontWeight weight = FontWeight.w500}) {
      return GoogleFonts.poppins(
        fontSize: size,
        fontWeight: weight,
        color: color,
      );
    }

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Enhanced Avatar Design
            Container(
              padding: EdgeInsets.all(6), // Border width
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent,
                    Colors.purpleAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),


              ),
              child: Container(
                padding: EdgeInsets.all(2), // This is the inner white border
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: CircleAvatar(
                  radius: height * 0.0350,
                  backgroundColor: Colors.transparent,
                  backgroundImage: widget.image.isNotEmpty
                      ? (widget.image.startsWith('http')
                      ? NetworkImage(widget.image)
                      : AssetImage(widget.image)) as ImageProvider
                      : const AssetImage(AppAssets.user),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // User name with improved styling
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.users.name ?? 'No Name',
                style: stylishText(16,
                    color: Colors.white.withOpacity(0.95),
                    weight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 10),

            // Optional: Add user status or additional info
             Text(
               "تم الحضور",
               style: GoogleFonts.cairo(fontSize: 15,fontWeight: FontWeight.bold, color: Colors.green.shade400,),
             ),
          ],
        ),
      ),
    );
  }
}