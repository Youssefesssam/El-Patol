import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class IntroVideoWidget extends StatefulWidget {
  const IntroVideoWidget({Key? key}) : super(key: key);

  @override
  State<IntroVideoWidget> createState() => _IntroVideoWidgetState();
}

class _IntroVideoWidgetState extends State<IntroVideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/introvideo.mp4')
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ));


  }
}
