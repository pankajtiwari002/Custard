class Community {
  String benefits;
  List<dynamic> chapters;
  String communityAbout;
  String communityName;
  String communityLink;
  String communityProfilePic;
  String galleryId;
  List<dynamic> tags;
  String theme;

  Community({
    required this.benefits,
    required this.chapters,
    required this.communityAbout,
    required this.communityName,
    required this.communityLink,
    required this.communityProfilePic,
    required this.galleryId,
    required this.tags,
    required this.theme,
  });

  factory Community.fromSnap(Map<String, dynamic> json) {
    return Community(
      benefits: json["benefits"],
      chapters: json["chapters"],
      communityAbout: json["communityAbout"],
      communityName: json["communityName"],
      communityLink: json["communityLink"],
      communityProfilePic: json["communityProfilePic"],
      galleryId: json["galleryId"],
      tags: json["tags"],
      theme: json["theme"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'benefits': benefits,
      'chapters': chapters,
      'communityAbout': communityAbout,
      'communityName': communityName,
      'communityLink': communityLink,
      'communityProfilePic': communityProfilePic,
      'galleryId': galleryId,
      'tags': tags,
      'theme': theme,
    };
  }
}
