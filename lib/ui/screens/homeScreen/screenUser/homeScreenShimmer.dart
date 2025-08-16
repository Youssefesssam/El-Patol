import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utilites/appColors.dart';

class HomeScreenShimmer extends StatelessWidget {
  static const String routeName = '/homeShimmer';

  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final chartHeight = screenHeight * 0.30;
    final chartWidth = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App Bar
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.appBarColor,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Container(
                margin:
                    EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 10),
                padding: EdgeInsets.all(10),

                child: Column(

                  children: [
                    Row(
                      children: [
                        _buildShimmerCircle(50),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 20,
                        ),
                        Column(
                          children: [
                            _buildShimmerRect(height: 10, width: 120),
                            const SizedBox(height: 5),
                            _buildShimmerRect(height: 10, width: 90),
                          ],
                        ),
                        Spacer(),
                        _buildShimmerCircle(30),
                      ],
                    ),
                     SizedBox(height: MediaQuery.of(context).size.height/16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          3, (_) => _buildShimmerRect(height: 20, width: 80)),
                    ),
                  ],
                ),
              ),
            ),

            // Chart Placeholder
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildShimmerRect(
                height: chartHeight,
                width: chartWidth,
                borderRadius: 16,
              ),
            ),

            const SizedBox(height: 10),
            // Chart



            // Grid of buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(8, (_) {
                  return _buildShimmerRect(height: 75, width: 75, borderRadius: 20);
                }),
              ),
            ),

            const SizedBox(height: 40),


          ],
        ),
      ),
    );
  }

  Widget _buildShimmerRect({
    required double height,
    required double width,
    double borderRadius = 8.0,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _buildShimmerCircle(double size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: size,
        width: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
