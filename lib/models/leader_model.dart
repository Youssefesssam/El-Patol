class LeaderModel {
  final String? age;
  final String? name;
  final String? church;
  final String? churchCode;
  final String? code;
  final String? governorateName;
  final String? governorateCode;
  final String? gender;
  final String? image;
  final String? phone;
  final String? role;
  final String? specialty;
  final String? stageType;
  final String? stageYear;
  final String? stageCode;
  final bool? isRegistered;
  final DateTime? createdAt;
  final String? stage;

  LeaderModel({
      this.stage,
    this.age,
    this.name,
    this.church,
    this.churchCode,
    this.code,
    this.governorateName,
    this.governorateCode,
    this.gender,
    this.image,
    this.phone,
    this.role,
    this.specialty,
    this.stageType,
    this.stageYear,
    this.stageCode,
    this.isRegistered,
    this.createdAt,   // ← هنا كمان
  });

  factory LeaderModel.fromMap(Map<String, dynamic> data) {
    return LeaderModel(
      age: data['age']?.toString(),
      name: data['name'],
      church: data['church'],
      churchCode: data['church_code'],
      code: data['code'],
      governorateName: data['governorate'],
      governorateCode: data['governorate_code'],
      gender: data['gender'],
      image: data['image'],
      phone: data['phone'],
      role: data['role'],
      specialty: data['specialty'],
      stageType: data['stage_type'],
      stageYear: data['stage_year'],
      stageCode: data['stage_code'],
      isRegistered: data['is_registered'],
      createdAt: data['created_at']?.toDate(),
    );
  }


}