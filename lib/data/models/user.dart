
class User{
  final String name;
  final String bio;
  final String gender;
  final bool isPhoneVerified;
  final String lastLocation;
  final String phone;
  final String profilePic;
  final List<String> communities;
  
  User({
    required this.name,
    required this.bio,
    required this.gender,
    required this.isPhoneVerified,
    required this.lastLocation,
    required this.phone,
    required this.profilePic,
    required this.communities
  });

  Map<String,dynamic> toJson() => {
      "name": name,
      "communities": communities,
      "bio": bio,
      "gender": gender,
      "isPhoneVerified": isPhoneVerified,
      "lastLocation": lastLocation,
      "phone": phone,
      "profilePic": profilePic
    };
}