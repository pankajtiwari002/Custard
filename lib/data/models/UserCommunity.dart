class UserCommunity {
  List<dynamic> chapters;
  String communityId;
  String leaderboards;
  String onboardingAnswers;
  String permissions;
  String status;
  String streak;
  String uid;
  String userRole;

  UserCommunity({
    required this.chapters,
    required this.communityId,
    required this.leaderboards,
    required this.onboardingAnswers,
    required this.permissions,
    required this.status,
    required this.streak,
    required this.uid,
    required this.userRole,
  });

  // Convert the UserCommunity object to a Map
  Map<String, dynamic> toJson() {
    return {
      'chapters': chapters,
      'community_id': communityId,
      'leaderboards': leaderboards,
      'onboardingAnswers': onboardingAnswers,
      'permissions': permissions,
      'status': status,
      'streak': streak,
      'uid': uid,
      'userRole': userRole,
    };
  }

  // Factory method to create a UserCommunity object from a Map
  factory UserCommunity.fromJson(Map<String, dynamic> json) {
    return UserCommunity(
      chapters: List<String>.from(json['chapters']),
      communityId: json['community_id'],
      leaderboards: json['leaderboards'],
      onboardingAnswers: json['onboardingAnswers'],
      permissions: json['permissions'],
      status: json['status'],
      streak: json['streak'],
      uid: json['uid'],
      userRole: json['userRole'],
    );
  }
}