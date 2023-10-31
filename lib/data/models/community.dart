class Community {
  String benefits;
  List<String> chapters;
  String communityAbout;
  String communityName;
  String communityLink;
  String communityProfilePic;
  String galleryId;
  List<String> tags;
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
