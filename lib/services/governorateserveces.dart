class GovernorateService {
  // قائمة المحافظات الرسمية في مصر (27 محافظة)
  static final Map<String, Map<String, String>> governorates = {
    '01': {'ar': ' السويس باتول', 'en': 'suez patol'},
    '02': {'ar': 'الاربعين باتول', 'en': 'al arbaan patol'},
    '03': {'ar': 'الفرنسسكان باتول', 'en': 'al frencecan batol'},

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
