// widgets/shimmer_card.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utilites/appColors.dart';


class ShimmerCard extends StatelessWidget {
  final double size;
  final Widget child;
  final bool isLoading;

  const ShimmerCard({
    super.key,
    required this.size,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors:AppColors.smoothColorTeal,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 9,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (true)
                Shimmer.fromColors(
                  period:Duration(milliseconds: 2500),
                  baseColor: Colors.teal.withOpacity(.1),
                  highlightColor: Colors.white.withOpacity(.7),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black87.withOpacity(.9),
                    ),
                  ),
                ),
              child,
            ],
          ),
        ),
      ],
    );
  }
}