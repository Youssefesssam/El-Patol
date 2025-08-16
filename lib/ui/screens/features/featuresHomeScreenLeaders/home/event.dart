import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_get_data_for_leader.dart';
import '../../../../../firebase/fireBase/fireBaseForLeader/New_fire_base_set_data_for_leader.dart';
import '../../../../../model/modelEvent.dart';
import '../../../utilites/appAssets.dart';
import '../../../utilites/appTexts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:path_provider/path_provider.dart';import 'dart:io';
import 'package:flutter/foundation.dart';

class Event extends StatefulWidget {
  Event({super.key});

  @override
  State<Event> createState() => _Event();
}

class _Event extends State<Event> {
  String? imageUrl;
  bool? eventExists;
  bool isUploading = false;
  double blurValue = 0;
  bool _isExpanded = false;
  String? errorMessage;
  TextEditingController textEvent = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('Initializing Event...');
    checkEventExistence();
  }

  bool isValidForm() {
    print('Validating form...');
    print('Text: ${textEvent.text}');
    print('Image URL: $imageUrl');

    if (textEvent.text.trim().isEmpty) {
      print('Validation failed: Event text is empty');
      setState(() {
        errorMessage = "Please enter a message.";
      });
      return false;
    } else if (imageUrl == null) {
      print('Validation failed: Image URL is null');
      setState(() {
        errorMessage = "Please upload an image.";
      });
      return false;
    }
    print('Form is valid');
    setState(() {
      errorMessage = null;
    });
    return true;
  }

  Future<void> checkEventExistence() async {
    print('Checking if Event exists...');
    AuthProviders authProviders = Provider.of<AuthProviders>(context, listen: false);

    print('Governorate: ${authProviders.governorate}');
    print('Church Code: ${authProviders.churchCodeL}');
    print('Stage: ${authProviders.stageTypeL}_${authProviders.stageYearL}');

    bool exists = await New_fire_base_get_data_for_leader.eventExist(
      governorate: authProviders.governorate!,
      church: authProviders.churchCodeL!,
      stage: '${authProviders.stageTypeL!}_${authProviders.stageYearL}',
    );

    print('Event exists: $exists');

    setState(() {
      eventExists = exists;
    });
  }

  Future<void> uploadImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() {
        isUploading = true;
        blurValue = 10;
      });

      final Uint8List imageData = await pickedFile.readAsBytes();
      final cropController = CropController();

      double aspectRatio = 1;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setLocalState) {
              return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'اقتصاص الصورة',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[100],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Crop(
                            controller: cropController,
                            image: imageData,
                            aspectRatio: aspectRatio,
                            onCropped: (croppedData) async {
                              Navigator.of(context, rootNavigator: true).pop();

                              final tempDir = await getTemporaryDirectory();
                              final filePath = '${tempDir.path}/cropped_image.png';
                              final file = await File(filePath).writeAsBytes(croppedData);

                              String? uploadedImageUrl =
                              await New_fire_base_get_data_for_leader.uploadImageToImgBB(file: file);

                              setState(() {
                                isUploading = false;
                                imageUrl = uploadedImageUrl;
                                blurValue = 0;
                              });
                            },
                            maskColor: Colors.black.withOpacity(0.5),
                            cornerDotBuilder: (size, edgeAlignment) =>
                            const DotControl(color: Colors.teal),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAspectButton(
                            icon: Icons.crop_square,
                            label: 'مربع',
                            color: Colors.blue.shade900,
                            onTap: () {
                              setLocalState(() => aspectRatio = 1);
                              cropController.aspectRatio = 1;
                            },
                          ),
                          _buildAspectButton(
                            icon: Icons.crop_16_9,
                            label: 'مستطيل',
                            color: Colors.blue.shade900,
                            onTap: () {
                              setLocalState(() => aspectRatio = 3 / 2);
                              cropController.aspectRatio = 3 / 2;
                            },
                          ),
                          _buildAspectButton(
                            icon: Icons.crop_free,
                            label: 'حر',
                            color: Colors.blue.shade900,
                            onTap: () {
                              setLocalState(() => aspectRatio = 0); // صفر يعني بدون نسبة ثابتة
                              cropController.aspectRatio = null;    // هذا مهم: null = free
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('تأكيد الاقتصاص'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: GoogleFonts.poppins(fontSize: 16),
                        ),
                        onPressed: () => cropController.crop(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      setState(() {
        isUploading = false;
        blurValue = 0;
      });
      debugPrint('Image upload error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders = Provider.of<AuthProviders>(context);
    print('Building Event widget...');
    print('Current auth provider values:');
    print('- Governorate: ${authProviders.governorate}');
    print('- Church Code: ${authProviders.churchCodeL}');
    print('- Stage Type: ${authProviders.stageTypeL}');
    print('- Stage Year: ${authProviders.stageYearL}');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hi.Event!",
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.event, size: 30, color: Colors.blue[800]),
                      Spacer(),
                      Visibility(
                        visible: !isUploading,
                        child: InkWell(
                          onTap: uploadImage,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                eventExists == null
                    ? _buildLoadingState(authProviders)
                    : eventExists!
                    ? _buildExistingEvent(authProviders)
                    : _buildNewEventForm(authProviders),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(AuthProviders authProviders) {
    print('Building loading state');
    return const SizedBox(
      height: 150,
      child: Column(
        children: [
          CircularProgressIndicator(),

        ],
      ),
    );
  }

  Widget _buildExistingEvent(AuthProviders authProviders) {
    print('Building existing Event UI');
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(15),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("governorate")
                  .doc(authProviders.governorate!)
                  .collection('church')
                  .doc(authProviders.churchCodeL)
                  .collection('activites')
                  .doc('${authProviders.stageTypeL!}_${authProviders.stageYearL}')
                  .collection(ModelHiEvent.collection)
                  .snapshots(),
              builder: (context, snapshot) {
                print('StreamBuilder snapshot state: ${snapshot.connectionState}');
                print('StreamBuilder has data: ${snapshot.hasData}');

                if (!snapshot.hasData || snapshot.data == null) {
                  print('No data available in Event collection');
                  return const Center(child: CircularProgressIndicator());
                }

                var docs = snapshot.data!.docs;
                print('Number of documents in Event: ${docs.length}');

                String? imageUrl;
                String lastMessage = "";

                if (docs.isNotEmpty && docs.first.data() != null) {
                  var data = docs.first.data() as Map<String, dynamic>;
                  print('Event document data: $data');

                  imageUrl = data.containsKey('image') ? data['image'] as String? : null;
                  lastMessage = data['hiEvent'] ?? "";

                  print('Retrieved image URL: $imageUrl');
                  print('Retrieved message: $lastMessage');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: imageUrl != null && imageUrl!.isNotEmpty
                            ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Image.asset(
                              AppAssets.nothing,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * .45,
                            );
                          },
                        )
                            : Image.asset(
                          AppAssets.nothing,
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * .45,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, bottom: 15),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("governorate")
                            .doc(authProviders.governorate!)
                            .collection('church')
                            .doc(authProviders.churchCodeL)
                            .collection('activites')
                            .doc('${authProviders.stageTypeL!}_${authProviders.stageYearL}')
                            .collection(ModelHiEvent.collection)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          var docs = snapshot.data!.docs;
                          String lastMessage = docs.isNotEmpty
                              ? docs.first['hiEvent'] ?? ""
                              : "";

                          return Builder(
                            builder: (context) {
                              bool isLongText = lastMessage.length > 100;
                              String displayText = isLongText
                                  ? (_isExpanded
                                  ? lastMessage
                                  : lastMessage.substring(0, 100) + "...")
                                  : lastMessage;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black),
                                      children: [
                                        TextSpan(text: displayText),
                                        if (isLongText)
                                          TextSpan(
                                            text: _isExpanded ? " Less" : "More",
                                            style: GoogleFonts.poppins(
                                              color: Colors.blue[800],
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                setState(() {
                                                  _isExpanded = !_isExpanded;
                                                });
                                              },
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: SlideAction(
                        innerColor: Colors.white,
                        outerColor: Colors.red[600],
                        elevation: 10,
                        textColor: Colors.white,
                        sliderButtonIconSize: 10,
                        sliderButtonIconPadding: 8,
                        sliderButtonIcon: Icon(Icons.delete,
                            size: 20, color: Colors.red),
                        submittedIcon: Icon(Icons.check,
                            size: 30, color: Colors.white),
                        onSubmit: () {
                          print('Deleting Event...');
                          New_fire_base_get_data_for_leader.deleteEvent(
                            governorate: authProviders.governorate!,
                            church: authProviders.churchCodeL!,
                            stage: '${authProviders.stageTypeL!}_${authProviders.stageYearL}',
                          );
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "Delete",
                            style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewEventForm(AuthProviders authProviders) {
    print('Building new Event form');
    return Column(
      children: [
        if (imageUrl == null)
          Center(
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: isUploading
                  ? Center(
                  child: Text(
                    'Loding...!',
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ))
                  : Center(
                child: Text(
                  "No Image Uploaded",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        if (imageUrl != null)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 10, end: blurValue),
            duration: Duration(seconds: 2),
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .55,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: value,
                        sigmaY: value,
                      ),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    if (isUploading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.2),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        const SizedBox(height: 10),
        TextField(
          controller: textEvent,
          onChanged: (value) {
            print('Text changed: $value');
            isValidForm();
          },
          maxLines: 3,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            hintText: 'Type your message...',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.4,
              child: SlideAction(
                innerColor: Colors.white,
                outerColor: Colors.red[600],
                elevation: 10,
                textColor: Colors.white,
                sliderButtonIconSize: 10,
                sliderButtonIconPadding: 8,
                animationDuration: Duration(milliseconds: 750),
                sliderButtonIcon: Icon(
                    Icons.exit_to_app_outlined,
                    size: 20,
                    color: Colors.red),
                submittedIcon: Icon(Icons.check,
                    size: 30, color: Colors.white),
                onSubmit: () {
                  print('Exit button pressed');
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    "Exit",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.4,
              child: SlideAction(
                innerColor: Colors.white,
                outerColor: (imageUrl != null && textEvent.text.isNotEmpty)
                    ? Colors.blue[800]!
                    : Colors.grey,
                elevation: 10,
                textColor: Colors.white,
                sliderButtonIconSize: 10,
                sliderButtonIconPadding: 8,
                sliderButtonIcon: Icon(Icons.send,
                    size: 20,
                    color: (imageUrl != null && textEvent.text.isNotEmpty)
                        ? Colors.blue[800]
                        : Colors.grey),
                submittedIcon: Icon(Icons.check,
                    size: 30, color: Colors.white),
                onSubmit: () async {
                  print('Share button pressed');
                  print(''' 
                  imageUrl: $imageUrl,
                  governorate: ${authProviders.governorate},
                  church: ${authProviders.churchCodeL},
                  stage: "${authProviders.stageTypeL}_${authProviders.stageYearL}",
                  Event text: ${textEvent.text}
                  ''');

                  if (isValidForm()) {
                    if (imageUrl != null) {
                      print('Saving image URL to Firestore...');
                      await New_fire_base_set_data_for_leader.saveImageUrlEventToFirestore(
                          imageUrl: imageUrl!,
                          governorate: authProviders.governorate!,
                          church: authProviders.churchCodeL!,
                          stage: "${authProviders.stageTypeL!}_${authProviders.stageYearL}");
                    }
                    print('Saving Event data...');
                    New_fire_base_set_data_for_leader.HiEventSet(
                      hiEvent: textEvent.text,
                      leader:authProviders.nameL!,
                      governorate: authProviders.governorate!,
                      church: authProviders.churchCodeL!,
                      stage: "${authProviders.stageTypeL!}_${authProviders.stageYearL}",
                    );
                    AppTexts.fristSeenEvent(true);

                    Navigator.pop(context);
                  } else {
                    print('Form validation failed');
                  }
                },
                child: Center(
                  child: Text(
                    "Share",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildAspectButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        // Button Container
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutQuart,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: AnimatedScale(
              duration: Duration(milliseconds: 200),
              scale: 1,
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Label Text
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
            letterSpacing: 0.4,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}