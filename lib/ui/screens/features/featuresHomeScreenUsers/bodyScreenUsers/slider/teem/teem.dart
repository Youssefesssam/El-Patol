import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../../../utilites/appAssets.dart';

class TeemScreen extends StatelessWidget {
  static const String routeName="teemScreen";
  const TeemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ModelViewer(
        src: AppAssets.loder,
        alt: "3D Model",
        autoRotate: true,
        cameraControls: true,
        backgroundColor: Colors.grey,

      ),
    );
  }
}
