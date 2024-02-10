
class User{
  final String name;
  final String bio;
  final String gender;
  final bool isPhoneVerified;
  final String lastLocation;
  final String phone;
  final String profilePic;
  final List<dynamic> communities;
  final bool isFirstTime;
  final String uid;
  final String role;
  
  User({
    required this.name,
    required this.bio,
    required this.gender,
    required this.isPhoneVerified,
    required this.lastLocation,
    required this.phone,
    required this.profilePic,
    required this.communities,
    required this.uid,
    required this.isFirstTime,
    required this.role
  });

  factory User.fromSnap(Map<String,dynamic> json){
    return User(name: json['name'],
        bio: json['bio'],
        gender: json['gender'],
        isPhoneVerified: true,
        lastLocation: json['lastLocation'],
        phone: json['phone'],
        profilePic: json["profilePic"],
        communities: json["communities"],
        uid: json["uid"],
        isFirstTime: json["isFirstTime"] ?? false,
        role: json["role"] ?? "user"
    );
  }

  Map<String,dynamic> toJson() => {
      "name": name,
      "communities": communities,
      "bio": bio,
      "gender": gender,
      "isPhoneVerified": isPhoneVerified,
      "lastLocation": lastLocation,
      "phone": phone,
      "profilePic": profilePic,
      "uid": uid,
      "isFirstTime": isFirstTime,
      "role": role
    };
}