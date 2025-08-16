import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';

import '../../../../../utilites/appAssets.dart';

class MyEmoji extends StatefulWidget {
  static const String routeName = "emoji";

  @override
  _MyEmojiState createState() => _MyEmojiState();
}

class _MyEmojiState extends State<MyEmoji> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> emojis = [

    {
      'name': 'crying',
      'path': AppAssets.b,
      'verses': [
        "الَّذِينَ يَزْرَعُونَ بِالدُّمُوعِ يَحْصُدُونَ بِالابْتِهَاجِ. (سفر المزامير 126: 5)",
        "في العالم سيكون لكم ضيق، ولكن ثقوا، أنا قد غلبت العالم. (يوحنا ١٦: ٣٣)",
        "فلتُطرح عليكم كل همومكم، لأنه هو يعتني بكم. (١ بطرس ٥: ٧)",
        "جعلت بكائي ترقصًا لي. (مزمور ٣٠: ١١)",
        "إله كل تعزية، يعزينا في كل ضيقتنا، حتى نستطيع أن نعزي الذين هم في كل ضيقة بالتعزية التي نتعزى بها نحن من الله. (٢ كورنثوس ١: ٣-٤)",
        "لا تخف، لأني معك. لا تتلفت حولي، لأني إلهك. قد عززتك وساعدتك، وعضدتك بيمين بري. (إشعياء ٤١: ١٠)",
        "طوبى للحزانى، لأنهم يتعزون. (متى ٥: ٤)",
        "الرب قريب لكسيري القلب، ويخلّص المنحني الروح. (مزمور ٣٤: ١٨)",
        "هو يعين الضعفاء - رومية ٨:٢٦",
        "ألقي همك على الرب فهو يعولك - مزمور ٥٥:٢٢",

      ],
    },
    {
      'name': 'angry',
      'path': AppAssets.c,
      'verses': [
        "اِغْضَبُوا وَلاَ تُخْطِئُوا. لاَ تَغْرُبِ الشَّمْسُ عَلَى غَيْظِكُمْ، وَلاَ تُعْطُوا إِبْلِيسَ مَكَانًا. (أفسس ٤: ٢٦-٢٧)",
        "بَطِيءُ الْغَضَبِ كَثِيرُ الْفَهْمِ، وَقَصِيرُ الرُّوحِ يُعْلِي الْحَمَاقَةَ. (أمثال ١٤:٢٩)",
        "اَلْجَوَابُ اللَّيِّنُ يُرْجِعُ الْغَضَبَ، وَالْكَلاَمُ الْقَاسِي يُهَيِّجُ السَّخَطَ. (أمثال ١٥:١)",
        "لاَ تَعْجَلْ بِرُوحِكَ إِلَى الْغَضَبِ، لأَنَّ الْغَضَبَ يَسْتَقِرُّ فِي حِضْنِ الْجُهَّالِ. (جامعة ٧:٩)",
        "وَأَمَّا أَنَا فَأَقُولُ لَكُمْ: إِنَّ كُلَّ مَنْ يَغْضَبُ عَلَى أَخِيهِ بَاطِلاً يَسْتَوْجِبُ الدِّينُونَةَ. (متى ٥: ٢٢)",
        "كَفَّ عَنِ الْغَضَبِ وَاتْرُكِ السَّخَطَ، لاَ تَحْتَدْ لِفِعْلِ الشَّرِّ. (مزمور ٣٧: ٨)",
        "وَأَمَّا الآنَ فَاطْرَحُوا عَنْكُمْ أَنْتُمْ أَيْضًا كُلَّ شَيْءٍ: الْغَضَبَ، السَّخَطَ، الشَّرَّ، التَّجَادُفَ، كَلاَمَ الْفُحْشِ مِنْ فَمِكُمْ. (كولوسي ٣: ٨)",
      ]
    },
    {
      'name': 'HeartEyes',
      'path': AppAssets.d,
      'verses': [
        "المحبة لا تسقط أبدًا - 1 كورنثوس ١٣:٨",
        "كل شيء تعمل معًا للخير للذين يحبون الله - رومية ٨:٢٨",
        "ليكن كل شيء فيكم بمحبة - 1 كورنثوس ١٦:١٤",
        "الله محبة، ومن يثبت في المحبة يثبت في الله - 1 يوحنا ٤:١٦",
        "المحبة تتأنى وترفق - 1 كورنثوس ١٣:٤",
        "المحبة لا تحسد - 1 كورنثوس ١٣:٤",
        "أحبوا بعضكم بعضًا - يوحنا ١٥:١٢",
        "المحبة تستر كثرة من الخطايا - 1 بطرس ٤:٨",
        "أحب الرب إلهك من كل قلبك - متى ٢٢:٣٧",
        "وصيتي هي أن تحبوا بعضكم - يوحنا ١٥:١٢",
        "في هذا تظهر محبة الله فينا - 1 يوحنا ٤:٩",
        "المحبة لا تصنع شرًا للقريب - رومية ١٣:١٠",
        "لأن الله أحب العالم حتى بذل ابنه - يوحنا ٣:١٦",
        "ليكن فيكم هذا الفكر - فيلبي ٢:٥",
        "كونوا لطفاء بعضكم نحو بعض - أفسس ٤:٣٢",
        "سلام الله الذي يفوق كل عقل - فيلبي ٤:٧",
        "أحبوا أعداءكم - متى ٥:٤٤",
        "بالمحبة اخدموا بعضكم - غلاطية ٥:١٣",
        "لنحب لا بالكلام بل بالعمل - 1 يوحنا ٣:١٨",
        "نعرف أننا قد انتقلنا من الموت إلى الحياة لأننا نحب الإخوة - 1 يوحنا ٣:١٤",

      ]
    },

    {
      'name': 'sick',
      'path': AppAssets.e,
      'verses': [
        "ٱلرَّبُّ يَفْتَحُ أَعْيُنَ ٱلْعُمْيِ. ٱلرَّبُّ يُقَوِّمُ ٱلْمُنْحَنِينَ. ٱلرَّبُّ يُحِبُّ ٱلصِّدِّيقِينَ. (اَلْمَزَامِيرُ ١٤٦:٨)",
        "وَٱشْفُوا ٱلْمَرْضَى ٱلَّذِينَ فِيهَا، وَقُولُوا لَهُمْ: قَدِ ٱقْتَرَبَ مِنْكُمْ مَلَكُوتُ ٱللهِ. (لُوقَا ١٠:‏٩)",
        "اِشْفُوا مَرْضَى. طَهِّرُوا بُرْصًا. أَقِيمُوا مَوْتَى. أَخْرِجُوا شَيَاطِينَ. مَجَّانًا أَخَذْتُمْ، مَجَّانًا أَعْطُوا. (مَتَّى ١٠:‏٨)",
        "فَقَالَ: «إِنْ كُنْتَ تَسْمَعُ لِصَوْتِ ٱلرَّبِّ إِلَهِكَ، وَتَصْنَعُ ٱلْحَقَّ فِي عَيْنَيْهِ، وَتَصْغَى إِلَى وَصَايَاهُ وَتَحْفَظُ جَمِيعَ فَرَائِضِهِ، فَمَرَضًا مَا مِمَّا وَضَعْتُهُ عَلَى ٱلْمِصْرِيِّينَ لَا أَضَعُ عَلَيْكَ. فَإِنِّي أَنَا ٱلرَّبُّ شَافِيكَ». (اَلْخُرُوجُ ١٥:‏٢٦)",
        "اِشْفِنِي يَا رَبُّ فَأُشْفَى. خَلِّصْنِي فَأُخَلَّصَ، لِأَنَّكَ أَنْتَ تَسْبِيحَتِي. (إِرْمِيَا ١٧:‏١٤)",
        "ٱلْقَلْبُ ٱلْفَرْحَانُ يُطَيِّبُ ٱلْجِسْمَ، وَٱلرُّوحُ ٱلْمُنْسَحِقَةُ تُجَفِّفُ ٱلْعَظْمَ. (أَمْثَالٌ ١٧:‏٢٢)",
        "لَكِنَّ أَحْزَانَنَا حَمَلَهَا، وَأَوْجَاعَنَا تَحَمَّلَهَا. وَنَحْنُ حَسِبْنَاهُ مُصَابًا مَضْرُوبًا مِنَ ٱللهِ وَمَذْلُولًا. (إِشَعْيَاءَ ٥٣:‏٤)",
        "يَشْفِي ٱلْمُنْكَسِرِي ٱلْقُلُوبِ، وَيَجْبُرُ كَسْرَهُمْ. (اَلْمَزَامِيرُ ١٤٧:‏٣)",
        "وَتَعْبُدُونَ ٱلرَّبَّ إِلَهَكُمْ، فَيُبَارِكُ خُبْزَكَ وَمَاءَكَ، وَأُزِيلُ ٱلْمَرَضَ مِنْ بَيْنِكُمْ. (اَلْخُرُوجُ ٢٣:‏٢٥)",
        "أَمَرِيضٌ أَحَدٌ بَيْنَكُمْ؟ فَلْيَدْعُ شُيُوخَ ٱلْكَنِيسَةِ فَيُصَلُّوا عَلَيْهِ وَيَدْهُنُوهُ بِزَيْتٍ بِٱسْمِ ٱلرَّبِّ، وَصَلَاةُ ٱلْإِيمَانِ تَشْفِي ٱلْمَرِيضَ، وَٱلرَّبُّ يُقِيمُهُ، وَإِنْ كَانَ قَدْ فَعَلَ خَطِيَّةً تُغْفَرُ لَهُ. (يَعْقُوبَ ٥:‏١٤-‏١٥)",
      ]
    },
    {
      'name': 'Kiss',
      'path': AppAssets.f,
      'verses': [
        "أَنَا غَرِيبٌ عِنْدَكَ. لاَ تَسْتُرْ عَنِّي وَصَايَاكَ. (مزمور 119: 19)",
        "لِمَاذَا تَنْسَانِي دَائِمًا؟ لِمَاذَا أَحْزِنُ مِنْ عَدُوٍّ يُضَايِقُنِي؟ (مزمور 42: 9)",
        "مَا أَبْعَدَ أَحْكَامَهُ عَنِ الْفَحْصِ، وَطُرُقَهُ عَنِ الاسْتِقْصَاءِ! (رومية 11: 33)",
        "كُلُّ يَوْمٍ أَشْكُو وَأَتَأَنَّى. (مزمور 38: 6)",
        "أَيُّهَا الرَّبُّ، حَتَّى مَتَى أَنْسَانِي؟ إِلَى الأَبَدِ؟ حَتَّى مَتَى تَحْجُبُ وَجْهَكَ عَنِّي؟ (مزمور 13: 1)",
        "إِنَّ أَحِبَّائِي قَدْ خَذَلُونِي، وَأَقَارِبِي قَدْ نَسُونِي. (أيوب 19: 14)",
        "وكان الشعب كالْمُتَذَمِّرِينَ الأَشْرَارَ فِي مَسَامِعِ الرَّبِّ. فَلَمَّا سَمِعَ الرَّبُّ أَشْعَلَ غَضَبَهُ، وَاشْتَعَلَتْ نَارٌ بَيْنَهُمْ وَأَكَلَتْ فِي أَطْرَافِ الْمَحَلَّةِ (عدد 11: 1)",
        "«حَتَّى مَتَى أَغْفِرُ لِهَذِهِ الجَمَاعَةِ الشِّرِّيرَةِ المُتَذَمِّرَةِ عَليَّ؟ قَدْ سَمِعْتُ تَذَمُّرَ بَنِي إِسْرَائِيل الذِي يَتَذَمَّرُونَهُ عَليَّ. (عدد 14: 27)",
        "لاَ يَئِنَّ بَعْضُكُمْ عَلَى بَعْضٍ أَيُّهَا الإِخْوَةُ لِئَلاَّ تُدَانُوا. هُوَذَا الدَّيَّانُ وَاقِفٌ قُدَّامَ الْبَابِ. (يعقوب 5: 9)",
        "اِفْعَلُوا كُلَّ شَيْءٍ بِلاَ دَمْدَمَةٍ وَلاَ مُجَادَلَةٍ، (فيلبي 2: 14)",
      ]
    },
    {
      'name': 'Sick',
      'path': AppAssets.h,
      'verses': [
        "اغضبوا ولا تخطئوا - أفسس ٤:٢٦",
        "البطيء الغضب خير من الجبار - أمثال ١٦:٣٢",
        "الذي لا يبطئ غضبه خير من المقتحم مدينة - أمثال ١٤:٢٩",
        "الغضب يسكن في حضن الجهال - جامعة ٧:٩",
        "لا تنتقموا لأنفسكم أيها الأحباء - رومية ١٢:١٩",
      ]
    },
    {
      'name': 'Nerve',
      'path': AppAssets.i,
      'verses': [
        "هو الشافي لكل أمراضك - مزمور ١٠٣:٣",
        "قد شفيتم بجراحه - 1 بطرس ٢:٢٤",
        "أنا هو الرب شافيك - خروج ١٥:٢٦",
        "فالرب يعينهم على فراش الضعف - مزمور ٤١:٣",
        "تعالوا إليّ... وأنا أريحكم - متى ١١:٢٨",
      ]
    },
    {
      'name': 'Gentel',
      'path': AppAssets.j,
      'verses': [
        "تعالوا إليّ يا جميع المتعبين وأنا أريحكم - متى ١١:٢٨",
        "هو يعين الضعفاء - رومية ٨:٢٦",
        "صار حزينًا حتى الموت - متى ٢٦:٣٨",
        "ألقي همك على الرب فهو يعولك - مزمور ٥٥:٢٢",
        "الرب قريب من المنكسرين القلوب - مزمور ٣٤:١٨",
      ]
    },
    {
      'name': 'lughing',
      'path': AppAssets.k,
      'verses': [
        "ثم امتلأ فمنا ضحكًا ولساننا ترنمًا - مزمور ١٢٦:٢",
        "القلب الفرحان يجعل الوجه طليقًا - أمثال ١٥:١٣",
        "القلب الطيب وجهه بشوش - أمثال ١٧:٢٢",
        "الفرح في القلب يبهج الوجه - أمثال ١٥:٣٠",
        "ضحك سارة وقالت: أَيَولد لشيخٍ ولد؟ - تكوين ١٨:١٢",
        "فرحت حين قيل لي إلى بيت الرب نذهب - مزمور ١٢٢:١",
        "افرحوا مع الفرحين - رومية ١٢:١٥",
        "تبتهج عظامي التي سحقتها - مزمور ٥١:٨",
        "أنشد للرب لأنه صنع مجيدًا - إشعياء ١٢:٥",
        "التسبيح في أفواههم - مزمور ١٤٩:٦",
        "يبتهج قلبي بالرب - 1 صموئيل ٢:١",
        "ضحكت ولباسها العز - أمثال ٣١:٢٥",
        "هللوا للرب يا كل الأرض - مزمور ١٠٠:١",
        "مبتهجون في رجاء - رومية ٥:٢",
        "ابتهجوا وتهللوا لأن أجركم عظيم - متى ٥:١٢",
        "أبتهج بكلامك كمن وجد غنيمة - مزمور ١١٩:١٦٢",
        "افرحوا لأن أسماءكم مكتوبة في السماء - لوقا ١٠:٢٠",
        "رجع التلاميذ بفرح - لوقا ٢٤:٥٢",
        "صرخة فرح كانت في شعب الرب - عزرا ٣:١١",
        "هتف الشعب بصوت عظيم - يشوع ٦:٢٠",

      ]
    },
    {
      'name': 'happy',
      'path': AppAssets.l,
      'verses': [
        "افرحوا في الرب كل حين، وأقول أيضًا: افرحوا! - فيلبي ٤:٤",
        "فرح الرب هو قوتكم - نحميا ٨:١٠",
        "أنت تملأ فمي ضحكًا وشفتي ترنمًا - أيوب ٨:٢١",
        "هذا هو اليوم الذي صنعه الرب، نبتهج ونفرح فيه - مزمور ١١٨:٢٤",
        "كل حين افرحوا. صلوا بلا انقطاع - 1 تسالونيكي ٥:١٦-١٧",
        "يبتهج الصديقون ويفرحون أمام الله - مزمور ٦٨:٣",
        "فرحت بكلامك كمن وجد غنيمة وافرة - مزمور ١١٩:١٦٢",
        "غنوا للرب تسبيحًا جديدًا - مزمور ٩٦:١",
        "يبتهج قلبي بخلاصك - مزمور ١٣:٥",
        "صوت ترنم وخلاص في خيام الأبرار - مزمور ١١٨:١٥",
        "هتفنا بفرح وسبّحنا - إشعياء ٥٢:٩",
        "إفرحي جدًا يا ابنة صهيون - زكريا ٩:٩",
        "ابتهجت نفسي بالرب - حبقوق ٣:١٨",
        "ابتهجوا بالرجاء، صابرين في الضيق - رومية ١٢:١٢",
        "لا تفرح بي يا عدوتي. إذا سقطت أقوم - ميخا ٧:٨",
        "الرب قريب. لا تهتموا بشيء - فيلبي ٤:٥-٦",
        "طوبى للشعب العارفين الهتاف - مزمور ٨٩:١٥",
        "فرحًا أفرح بالرب - إشعياء ٦١:١٠",
        "رجعوا بفرح عظيم إلى أورشليم - نحميا ١٢:٤٣",
        "فرحي بكم عظيم - 2 كورنثوس ٧:٤",
      ]
    },
    {
      'name': 'Clown',
      'path': AppAssets.a,
      'verses': [
        'إيه الجمال ده؟ هو إحنا في السيرك ولا في حفلة؟',
        'اللي مزاجه وحش يقرب... أنا عندي حلول غير تقليدية!',
        'دخلت المكان، لقيت الهدوء... قولت أزعجه شوية.',
        'أنا مخلوق للدوشة الحلوة والمفاجآت!',
        'اللي بيضحك معايا بيبقى صاحبي غصب عنه.',
        'إوعى تبصلي كده... أنا كده بطبيعتي!',
        'أنا أول ما أظهر... الجو يتعدل.',
        'شكلي كده بيطمن الناس، أو بيخوفهم... حسب المزاج!',
        'أنا مش بظهر في أي وقت، أنا بختار اللحظة الصح.',
        'محدش يعرف أنا بفكر في إيه، وأنا كمان مش عارف.',
        'مفيش خطة... بس دايمًا فيه مفاجأة.',
        'لو كنت بتدور على الجد، يبقى دخلت السيرك بالغلط.',
        'كل واحد جاي يتفرج... بس أنا هنا علشان أدوّخهم!',
        'أنا مش مهرج... أنا لغز بلون أحمر وأنف كبيرة.',
        'مش لازم أتكلم كتير... وجودي كفاية يخلّي الجو يهيص.',
        'أنا بحب اللف، والزحمة، والصوت العالي... كأنك دخلت فرح !',
        'بمشي بخطوة مش مفهومة... بس الكل ورايا بيتحرك.',
        'أنا مفيش زيي، وده مش غرور... ده واقع!',
        'أنا بضحك، بس ممكن فجأة أبصلك كده وتتوتر.',
        'إوعى تفتكرني بسيط... أنا بسيط معقد جدًا!',
        'كل حاجة فيا معمولة تحيّر، حتى الضحكة.',
      ]
    }
  ];

  final List<String> _encouragements = [
    "Great tap!",
    "Awesome!",
    "You're on fire!",
    "Keep going!",
    "Emoji master!",
    "So much fun!",
    "Incredible!",
    "Wow!",
  ];

  final PageController _pageController =
  PageController(viewportFraction: 0.3, initialPage: 1);

  // Animation Controllers
  late AnimationController _fallController;
  late Animation<double> _fallAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _spinController;
  late ConfettiController _confettiController;

  // State Variables
  int _currentIndex = 1;
  int _previousIndex = 1;
  bool _isFromRight = true;
  double _scale = 1.0;
  bool _isFalling = false;
  double _rotation = 0.0;
  double _startAngle = 0.0;
  double _spinVelocity = 0.0;
  bool _isSpinning = false;
  Offset _emojiOffset = Offset.zero;
  bool _isPulsing = false;
  Color _currentGlowColor = Colors.blueAccent;
  int _tapCount = 0;
  double _pressScale = 1.0;
  bool _isPressed = false;
  String _currentEncouragement = "";
  bool _showEncouragement = false;
  int _comboCount = 0;
  DateTime? _lastTapTime;
  List<String> _achievements = [];
  bool _showEmojiInfo = false;
  String _currentEmojiVerses = "";
  bool _gameMode = false;
  int _score = 0;
  int _highScore = 0;
  int _timeLeft = 30;
  Timer? _gameTimer;
  Color _backgroundColor = Color(0xFF0C2340);
  bool _showColorPicker = false;
  bool _isSaved = false;
  final List<Color> _availableColors = [
    Color(0xFF800000),
    Color(0xFF006400),
    Color(0xFF0C2340),
    Color(0xFFFADB02),

  ];

  @override
  void initState() {
    super.initState();
    _loadHighScore();

    _pageController.addListener(_onPageChanged);

    // Fall animation setup
    _fallController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fallAnimation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _fallController, curve: Curves.bounceOut),
    );
    _fallController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 400), () {
          _fallController.reset();
          setState(() => _isFalling = false);
        });
      }
    }


    );

    // Pulse animation setup
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Color animation setup
    _colorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _colorAnimation = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.pinkAccent,
    ).animate(_colorController);

    // Shake animation setup
    _shakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 8.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);

    // Spin animation setup
    _spinController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addListener(() {
      setState(() {
        _rotation += _spinVelocity;
        _spinVelocity *= 0.98;
        if (_spinVelocity.abs() < 0.01) {
          _spinVelocity = 0.0;
          _isSpinning = false;
        }
      });
    });

    // Confetti controller setup
    _confettiController = ConfettiController(duration: Duration(seconds: 1));
  }

  void _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('highScore') ?? 0;
    });
  }
  void _onPageChanged() {
    final newIndex = _pageController.page!.round();
    if (newIndex != _currentIndex) {
      setState(() {
        _isFromRight = newIndex > _currentIndex;
        _previousIndex = _currentIndex;
        _currentIndex = newIndex;
        _emojiOffset = Offset(_isFromRight ? 1.5 : -1.5, 0);
        _scale = 0.2;
        _vibrate();
        _shakeController.forward(from: 0);
        _currentGlowColor = _getGlowColorForEmoji(_currentIndex);
        _colorController.forward(from: 0);
      });

      Future.delayed(Duration(milliseconds: 50), () {
        setState(() => _emojiOffset = Offset.zero);
      });

      Future.delayed(Duration(milliseconds: 300), () {
        setState(() => _scale = 1.0);
      });
    }
  }

  Color _getGlowColorForEmoji(int index) {
    switch (index) {
      case 0: return Colors.yellow;
      case 1: return Colors.orange;
      case 2: return Colors.red;
      case 3: return Colors.red.shade900;
      case 4: return Colors.green;
      case 5: return Colors.white;
      case 6: return Colors.deepOrange;
      case 7: return Colors.yellow;
      case 8: return Colors.teal;
      case 9: return Colors.red;
      default: return Colors.blueAccent;
    }
  }

  String _getEmojiComment(int index) {
    switch (index) {
      case 0: return "Stay happy!";
      case 1: return "Laugh out loud!";
      case 2: return "So much love!";
      case 3: return "Cool vibes!";
      case 4: return "Feeling loved!";
      case 5: return "Smooch!";
      case 6: return "Angry? Breathe!";
      case 7: return "Not feeling well?";
      case 8: return "Take it easy!";
      default: return "Feeling the vibe!";
    }
  }
  void _saveEmojiAndVerse() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final emojiName = emojis[_currentIndex]['name']!;
      final emojiPath = emojis[_currentIndex]['path']!;
      final verses = emojis[_currentIndex]['verses']!;
      final randomVerse = verses[Random().nextInt(verses.length)];

      await prefs.setString('saved_emoji_name', emojiName);
      await prefs.setString('saved_emoji_path', emojiPath);
      await prefs.setString('saved_emoji_verse', randomVerse);

      setState(() {
        _isSaved = true;
      });

      _vibrate();

      // إعادة تعيين اللون بعد 3 ثواني
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isSaved = false;
          });
        }
      });

    } catch (e) {
      print('Error saving emoji: $e');
    }
  }
  void _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 40);
    }
  }
  void _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', _highScore);
  }


  void _fallEmoji() {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!) < Duration(seconds: 1)) {
      _comboCount++;
      if (_comboCount == 5 && !_achievements.contains("Combo Master")) {
        _achievements.add("Combo Master");
        _showAchievement("Combo Master!");
      }
      if (_comboCount == 10 && !_achievements.contains("Ultra Combo")) {
        _achievements.add("Ultra Combo");
        _showAchievement("Ultra Combo!!");
      }
    } else {
      _comboCount = 1;
    }
    _lastTapTime = now;

    if (_gameMode) {
      setState(() {
        _isFalling = true;
        _score += 10 * _comboCount;

        // هنا نحدث الـ highScore لو السكور الجديد أعلى
        if (_score > _highScore) {
          _highScore = _score;
          _saveHighScore();
        }
      });

      _fallController.forward().then((_) {
        if (_gameMode && _timeLeft > 0) {
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() => _isFalling = false);
            _fallEmoji();
          });
        }
      });
    }
    else {
      setState(() {
        _isFalling = true;
        _isPulsing = true;
        _tapCount++;
        _currentEncouragement = _encouragements[Random().nextInt(_encouragements.length)];
        _showEncouragement = true;
      });

      _fallController.forward();
      _confettiController.play();

      Future.delayed(Duration(seconds: 2), () {
        setState(() => _showEncouragement = false);
      });

      Future.delayed(Duration(milliseconds: 800), () {
        setState(() => _isPulsing = false);
      });
    }
  }

  void _showAchievement(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startGame() {
    setState(() {
      _gameMode = true;
      _score = 0;
      _timeLeft = 30;
      _isFalling = false;
    });

    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        timer.cancel();
        _endGame();
      }
    });

    _fallEmoji();
  }

  void _endGame() {
    _gameTimer?.cancel();
    setState(() => _gameMode = false);
    _showAchievement("نقاطك: $_score");
  }

  void _checkAchievements() {
    if (_tapCount == 1 && !_achievements.contains("First Tap")) {
      _achievements.add("First Tap");
      _showAchievement("First Tap!");
    }
    if (_currentIndex == emojis.length-1 && !_achievements.contains("Emoji Explorer")) {
      _achievements.add("Emoji Explorer");
      _showAchievement("Emoji Explorer!");
    }
    if (_tapCount >= 50 && !_achievements.contains("Power Tapper")) {
      _achievements.add("Power Tapper");
      _showAchievement("Power Tapper!!");
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fallController.dispose();
    _pulseController.dispose();
    _colorController.dispose();
    _shakeController.dispose();
    _spinController.dispose();
    _confettiController.dispose();
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emojiSize = 250.0;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _backgroundColor,
              _backgroundColor,
              _backgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    "Taps: $_tapCount",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12, bottom: 8),
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(width: 60),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_emotions_outlined, color: Colors.white.withOpacity(0.7)),
                  SizedBox(width: 12),
                  Text(
                    "Emoji Vibe",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.emoji_emotions_outlined, color: Colors.white.withOpacity(0.7)),
                ],
              ),
            ),

            SizedBox(height: 20),

            Container(
              height: 120,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        _pageController.animateToPage(
                          _currentIndex,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                      return false;
                    },
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: emojis.length,
                      itemBuilder: (context, index) {
                        final isCenter = index == _currentIndex;
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          margin: EdgeInsets.only(
                            top: isCenter ? 20 : 40,
                            bottom: isCenter ? 20 : 40,
                          ),
                          child: AnimatedScale(
                            scale: isCenter ? 1.2 : 0.8,
                            duration: Duration(milliseconds: 200),
                            child: GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  index,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              },
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: isCenter
                                        ? [
                                      BoxShadow(
                                        color: _getGlowColorForEmoji(index)
                                            .withOpacity(0.3),
                                        blurRadius: 15,
                                        spreadRadius: 4,
                                      ),
                                    ]
                                        : null,
                                  ),
                                  child: Lottie.asset(
                                    emojis[index]['path']!,
                                    width: isCenter ? 70 : 50,
                                    height: isCenter ? 70 : 50,
                                    repeat: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _gameMode
                  ? SizedBox(
                key: ValueKey("highScore"),
                child: Text(
                  "🏆 High Score: $_highScore",
                  style: TextStyle(fontSize: 20, color: Colors.amber),
                ),
              )
                  : SizedBox(
                key: ValueKey("emojiInfo"),
                child: Column(
                  children: [
                    Text(
                      emojis[_currentIndex]['name']!,
                      style: GoogleFonts.quicksand(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _getEmojiComment(_currentIndex),
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            SizedBox(height: 10),

            Flexible(
              fit: FlexFit.loose,
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onPanStart: (details) {
                        final touchPosition = details.localPosition;
                        final dx = touchPosition.dx - emojiSize / 2;
                        final dy = touchPosition.dy - emojiSize / 2;
                        _startAngle = atan2(dy, dx) - _rotation;
                      },
                      onPanUpdate: (details) {
                        final touchPosition = details.localPosition;
                        final dx = touchPosition.dx - emojiSize / 2;
                        final dy = touchPosition.dy - emojiSize / 2;
                        final newAngle = atan2(dy, dx);
                        _spinVelocity = (newAngle - _startAngle) * 0.2;
                        _startAngle = newAngle;
                        setState(() {
                          _rotation = newAngle - _startAngle;
                        });
                      },
                      onPanEnd: (_) {
                        if (_spinVelocity.abs() > 0.5) {
                          _isSpinning = true;
                          _vibrate();
                          _spinController.forward();
                        }
                        _emojiOffset = Offset.zero;
                      },
                      onVerticalDragUpdate: (details) {
                        setState(() {
                          _emojiOffset += Offset(0, details.delta.dy / 5);
                        });
                      },
                      onVerticalDragEnd: (_) {
                        setState(() {
                          _emojiOffset = Offset.zero;
                        });
                      },
                      onLongPress: () {
                        setState(() {
                          _showEmojiInfo = true;
                          List<String> verses = emojis[_currentIndex]['verses']!;
                          String randomVerse = verses[Random().nextInt(verses.length)];
                          _currentEmojiVerses = randomVerse;
                        });
                        _vibrate();
                        Future.delayed(Duration(seconds: 3), () {
                          setState(() => _showEmojiInfo = false);
                        });
                      },
                      onTapDown: (_) {
                        setState(() {
                          _pressScale = 0.95;
                          _isPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _pressScale = 1.0;
                          _isPressed = false;
                        });
                        _vibrate();
                        _fallEmoji();
                      },
                      onTapCancel: () {
                        setState(() {
                          _pressScale = 1.0;
                          _isPressed = false;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ConfettiWidget(
                            confettiController: _confettiController,
                            blastDirectionality: BlastDirectionality.explosive,
                            shouldLoop: false,
                            colors: [Colors.yellow, Colors.orange, Colors.pink],
                            numberOfParticles: 20,
                          ),
                          Positioned(
                            bottom: 40,
                            child: AnimatedOpacity(
                              opacity: _isFalling ? 0.2 : 0.4,
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                width: 150,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _colorController,
                            builder: (context, child) {
                              return Container(
                                width: emojiSize * 1.4,
                                height: emojiSize * 1.4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      _colorAnimation.value!.withOpacity(0.2),
                                      _colorAnimation.value!.withOpacity(0.05),
                                      Colors.transparent,
                                    ],
                                    stops: [0.1, 0.3, 0.8],
                                  ),
                                ),
                              );
                            },
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            width: _isPressed ? emojiSize * 1.5 : emojiSize * 1.2,
                            height: _isPressed ? emojiSize * 1.5 : emojiSize * 1.2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                          ),
                          if (_showEmojiInfo)
                            Positioned(
                              bottom: 260,
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  _currentEmojiVerses,
                                  style: GoogleFonts.tajawal(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          if (_showEncouragement)
                            Positioned(
                              top: 100,
                              child: Text(
                                _currentEncouragement,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (_gameMode)
                            Positioned(
                              top: 50,
                              child: Column(
                                children: [
                                  Text(
                                    "الوقت: $_timeLeft",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  Text(
                                    "النقاط: $_score",
                                    style: TextStyle(color: Colors.yellow, fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                          AnimatedBuilder(
                            animation: Listenable.merge(
                                [_fallController, _shakeController, _pulseController]),
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  _shakeAnimation.value * (_isFromRight ? 1 : -1),
                                  _isFalling ? _fallAnimation.value : 0,
                                ) +
                                    _emojiOffset,
                                child: Transform.scale(
                                  scale: (_isPulsing
                                      ? _pulseAnimation.value * _scale
                                      : _scale) *
                                      _pressScale,
                                  child: Transform.rotate(
                                    angle: _rotation +
                                        (_isSpinning ? _spinVelocity * 10 : 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: _currentGlowColor.withOpacity(0.5),
                                            blurRadius: 30,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Lottie.asset(
                                        emojis[_currentIndex]['path']!,
                                        width: emojiSize,
                                        height: emojiSize,
                                        repeat: true,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          if (_showColorPicker)
                            Positioned(
                              bottom: 110,
                              right: 0,
                              child: Container(
                                height:MediaQuery.of(context).size.height/7,

                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: _availableColors.map((color) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _backgroundColor = color;
                                          _showColorPicker = false;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 4),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 70,
                            right: 10,
                            child: FloatingActionButton(
                              onPressed: () {
                                setState(() => _showColorPicker = !_showColorPicker);
                              },
                              child: Icon(Icons.color_lens),
                              backgroundColor: Colors.purple,
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 25,
                            child: FloatingActionButton(
                              onPressed: _saveEmojiAndVerse,
                              child: Icon(Icons.done_all),
                              backgroundColor: _isSaved ? Colors.green : Colors.blue,
                              tooltip: 'حفظ الإيموجي والآية',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: Column(
                children: [
                  Text(
                    "Tap to drop • Drag to rotate",
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _gameMode ? _endGame : _startGame,
                    icon: Icon(_gameMode ? Icons.stop : Icons.gamepad),
                    label: Text(_gameMode ? "End Game" : "Start Game"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _gameMode ? Colors.red : Colors.green,
                      shape: StadiumBorder(),
                    ),
                  ),

                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [

                      Icon(Icons.touch_app, color: Colors.white70),
                      Text("$_tapCount", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.emoji_emotions, color: Colors.white70),
                      Text("${emojis.length}", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.star, color: Colors.white70),
                      Text("${_achievements.length}", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );}
}