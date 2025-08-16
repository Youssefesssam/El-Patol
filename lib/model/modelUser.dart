class MyUser {
  static const String collection = 'user';
  late var id ;
  int lack=0 ;
  int lackWeek =0 ;
  int rank=0 ;
  late String name;
  late String email;
  late String pass;
  late String address;
  late String phone;
  late String talent;
  late String university;
  late String gender;
  late String code;
  late String facebook;
  late String whatsapp;
  late String profileUrl;
  late String birthDay;

  


  MyUser({

    required this.name,
    required this.id,
    required this.rank,
    required this.lack,
    required this.lackWeek,
    required this.email,
    required this.pass,
    required this.phone,
    required this.address,
    required this.gender,
    required this.talent,
    required this.code,
    required this.facebook,
    required this.birthDay,
    required this.whatsapp,
    required this.university,
    required this.profileUrl,

  });

  MyUser.fromJson(Map<String, dynamic> json) {

    name =json["name"]??'';
    id =json["id"]??'' ;
    rank =json["rank"] ;
    lack =json["lack"] ;
    lackWeek =json["lackWeek"] ;
    email =json["email"];
    phone =json["phone"];
    address =json["address"];
    gender =json["gender"];
    pass =json["pass"];
    talent = json["talent"];
    code = json["code"];
    facebook = json["facebook"];
    whatsapp = json["whatsapp"];
    university=json["university"];
    profileUrl=json["profileUrl"];
    birthDay=json["birthDay"];
  }

  Map<String, dynamic> toJson() {
    return {
      'name' :name,
      'id' :id,
      'pass' :pass,
      'lack' :lack,
      'lackWeek' :lackWeek,
      'rank' :rank,
      'code' :code,
      'facebook' :facebook,
      'whatsapp' :whatsapp,
      'email':email,
      'phone' :phone,
      'address':address,
      'gender':gender,
      'talent':talent,
      'university':university,
      "profileUrl":profileUrl,
      "birthDay":birthDay
    };
  }
}