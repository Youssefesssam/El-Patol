import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../mainComponent/picGeneralAndCompition.dart';

class ViewMainComponent extends StatelessWidget {
  final Function(int) onPageChanged;
  final int currentIndex;

  const ViewMainComponent({
    super.key,
    required this.onPageChanged,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double sliderHeight = max(min(screenWidth * 0.44, screenWidth * 1.1), 360);


    return CarouselSlider(
      items: PicGeneralAndCompition.pic,
      options: CarouselOptions(
        height: sliderHeight,
        viewportFraction: 1.0,
        initialPage: currentIndex,
        enableInfiniteScroll: true,
        autoPlay: false,
        onPageChanged: (index, reason) => onPageChanged(index),
      ),
    );
  }
}
