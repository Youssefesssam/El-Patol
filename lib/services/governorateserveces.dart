class GovernorateService {
  // قائمة المحافظات الرسمية في مصر (27 محافظة)
  static final Map<String, Map<String, String>> governorates = {
    '01': {'ar': 'القاهرة', 'en': 'Cairo'},
    '02': {'ar': 'الجيزة', 'en': 'Giza'},
    '03': {'ar': 'الإسكندرية', 'en': 'Alexandria'},
    '04': {'ar': 'القليوبية', 'en': 'Qalyubia'},
    '05': {'ar': 'البحيرة', 'en': 'Beheira'},
    '06': {'ar': 'كفر الشيخ', 'en': 'Kafr El Sheikh'},
    '07': {'ar': 'الغربية', 'en': 'Gharbia'},
    '08': {'ar': 'المنوفية', 'en': 'Menoufia'},
    '09': {'ar': 'الدقهلية', 'en': 'Dakahlia'},
    '10': {'ar': 'دمياط', 'en': 'Damietta'},
    '11': {'ar': 'الشرقية', 'en': 'Sharqia'},
    '12': {'ar': 'الإسماعيلية', 'en': 'Ismailia'},
    '13': {'ar': 'بورسعيد', 'en': 'Port Said'},
    '14': {'ar': 'السويس', 'en': 'Suez'},
    '15': {'ar': 'شمال سيناء', 'en': 'North Sinai'},
    '16': {'ar': 'جنوب سيناء', 'en': 'South Sinai'},
    '17': {'ar': 'بني سويف', 'en': 'Beni Suef'},
    '18': {'ar': 'الفيوم', 'en': 'Fayoum'},
    '19': {'ar': 'المنيا', 'en': 'Minya'},
    '20': {'ar': 'أسيوط', 'en': 'Assiut'},
    '21': {'ar': 'الوادي الجديد', 'en': 'New Valley'},
    '22': {'ar': 'سوهاج', 'en': 'Sohag'},
    '23': {'ar': 'قنا', 'en': 'Qena'},
    '24': {'ar': 'الأقصر', 'en': 'Luxor'},
    '25': {'ar': 'أسوان', 'en': 'Aswan'},
    '26': {'ar': 'مطروح', 'en': 'Matrouh'},
    '27': {'ar': 'البحر الأحمر', 'en': 'Red Sea'},
  };

  static String getArabicName(String code) {
    return governorates[code]?['ar'] ?? 'غير معروف';
  }

  static String getEnglishName(String code) {
    return governorates[code]?['en'] ?? 'Unknown';
  }

  static String getName(String code, String lang) {
    if (!governorates.containsKey(code)) return code;
    return governorates[code]![lang] ?? code;
  }


  static List<String> getGovernorateListAr() {
    return governorates.entries.map((e) => '${e.value['ar']} (${e.key})').toList();
  }

  static List<String> getGovernorateListEn() {
    return governorates.entries.map((e) => '${e.value['en']} (${e.key})').toList();
  }
}
