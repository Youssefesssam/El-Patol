import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../../firebase/authProvider.dart';
import '../../../../../model/modelEvent.dart';
import '../../../../../model/modelSweetTalk.dart';
import '../explainVideo/introVideoWidget.dart';

class AdInterFace extends StatefulWidget {
  static const String routeName = 'adInterFace';

  const AdInterFace({Key? key}) : super(key: key);

  @override
  State<AdInterFace> createState() => _AdInterFaceState();
}

class _AdInterFaceState extends State<AdInterFace> {
  bool _isExpanded = false;
  String _source = "";

  Widget _buildTextWithImage({
    required String text,
    String? imageUrl,
    required String source,
  }) {
    // تقسيم النص إلى كلمات
    List<String> words = text.split(' ');
    bool isLongText = words.length > 4;
    String displayText = isLongText
        ? words.take(4).join(' ') + ' ...'
        : text;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with source indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: source == "SweetTalk"
                    ? [Colors.blue.shade900, Colors.blue.shade600]
                    : [Colors.blue.shade900, Colors.blue.shade700],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  source == "SweetTalk" ? Icons.campaign : Icons.event,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  source == "SweetTalk" ?  " إعلان  SweetTalk" : " إعلان Event",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Image with better loading and error handling
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
                  : _buildPlaceholderImage(),
            ),
          ),
          const SizedBox(height: 20),
          // Content text with shortening
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Text(
                displayText,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  height: 1.6,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Action button with improved styling
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: source == "SweetTalk"
                    ? Colors.blue.shade900
                    : Colors.blue.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.2),
              ),
              onPressed: () {
                // Handle button press
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.favorite),
                  SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.title),
                  SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.event),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Swipe hint with icon
          Column(
            children: [
              Row(
                children: [
                   SizedBox(width: MediaQuery.of(context).size.width/6),

                  Icon(
                    Icons.swipe_right,
                    color: Colors.grey.shade500,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اسحب للكسب المزيد من النقاط!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                ],
              ),
              Row(
                children: [
                   SizedBox(width: MediaQuery.of(context).size.width/6),

                  Icon(
                    Icons.star,
                    color: Colors.grey.shade500,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'انت فطريق الفوز باكبر نقاط',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                ],
              ),
              Row(
                children: [
                   SizedBox(width: MediaQuery.of(context).size.width/6),

                  Icon(
                    Icons.auto_fix_high,
                    color: Colors.grey.shade500,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تابع كل جديد لتحقيق الفارق',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                ],
              ),

            ],
          ),
          // Video section with title
          Column(
            children: [
              const SizedBox(height: 8),
              SizedBox(
                height: 220,
                child: const IntroVideoWidget(),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'لا توجد صورة متاحة',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProviders authProviders=Provider.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child:  Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                 [Colors.blue.shade900, Colors.white,Colors.white],
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter

          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
            children: [
              // Main content
              StreamBuilder<QuerySnapshot>(
                stream:FirebaseFirestore.instance
                    .collection("governorate")
                    .doc(authProviders.governorateUs)
                    .collection('church')
                    .doc(authProviders.churchCodeUs)
                    .collection('activites')
                    .doc(authProviders.stageCodeUs)
                    .collection(ModelHiEvent.collection)
                    .snapshots(),
                builder: (context, eventSnapshot) {
                  if (eventSnapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingIndicator();
                  }

                  if (eventSnapshot.hasData && eventSnapshot.data!.docs.isNotEmpty) {
                    var eventDoc = eventSnapshot.data!.docs.first;
                    String lastMessage = eventDoc['hiEvent'] ?? "لا يوجد محتوى";
                    final data = eventDoc.data() as Map<String, dynamic>? ?? {};
                    String? imageUrl = data['image'] as String?;

                    _source = "Event";
                    return _buildTextWithImage(
                        text: lastMessage, imageUrl: imageUrl, source: _source);
                  } else {
                    return StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance
                          .collection("governorate")
                          .doc(authProviders.governorateUs)
                          .collection('church')
                          .doc(authProviders.churchCodeUs)
                          .collection('activites')
                          .doc(authProviders.stageCodeUs)
                          .collection(ModelSweetTalk.collection)
                          .snapshots(),
                      builder: (context, sweetSnapshot) {
                        if (sweetSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingIndicator();
                        }

                        var docs = sweetSnapshot.data?.docs ?? [];
                        String lastMessage = docs.isNotEmpty
                            ? docs.first['talk'] ?? "لا يوجد محتوى"
                            : "لا يوجد محتوى";
                        final data = docs.isNotEmpty
                            ? docs.first.data() as Map<String, dynamic>
                            : {};
                        String? imageUrl = data['image'] as String?;

                        _source = "SweetTalk";
                        return _buildTextWithImage(
                            text: lastMessage, imageUrl: imageUrl, source: _source);
                      },
                    );
                  }
                },
              ),

              // Close button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.red.shade700,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),

    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}