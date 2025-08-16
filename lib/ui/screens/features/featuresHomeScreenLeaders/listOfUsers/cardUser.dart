import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../firebase/dataProvider.dart';
import '../../../../../model/modelUser.dart';
import '../../../utilites/appAssets.dart';

class CardUser extends StatefulWidget {
  final MyUser users;
  int score;
  String image;
  int rank;
  final String userId;
  final bool isMeetingActive;

  CardUser({
    super.key,
    required this.users,
    required this.userId,
    required this.score,
    required this.rank,
    required this.image,
    required this.isMeetingActive,
  });

  @override
  _CardUserState createState() => _CardUserState();
}

class _CardUserState extends State<CardUser> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // استخدم نسبة مناسبة للارتفاع بناءً على نوع الجهاز
    final cardHeight = screenHeight * 0.12;
    final avatarRadius = screenWidth * 0.07;
    final paddingHorizontal = screenWidth * 0.04;
    final nameFontSize = screenWidth * 0.045;
    final rankFontSize = screenWidth * 0.05;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: widget.isMeetingActive
            ? LinearGradient(
          colors: [
            Colors.green.shade800,
            Colors.green.shade300,
            Colors.green.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : LinearGradient(
          colors: [
            Colors.deepPurple.shade800,
            Colors.blue,
            Colors.indigo.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: avatarRadius,
              backgroundImage: widget.image.isNotEmpty
                  ? (widget.image.startsWith('http')
                      ? NetworkImage(widget.image)
                      : AssetImage(widget.image)) as ImageProvider
                  : const AssetImage(AppAssets.user),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.users.name ?? "",
                  style: TextStyle(
                    fontSize: nameFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${widget.score}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.sports_score,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            "#${widget.rank}",
            style: TextStyle(
              fontSize: rankFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.yellowAccent,
            ),
          ),
        ],
      ),
    );
  }
}
