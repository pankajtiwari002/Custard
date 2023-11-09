class Gallery {
  String chapterId;
  String communityId;
  String eventId;
  String galleryId;
  DateTime createdOn;
  List<String> participants;
  String thumbnails;
  List<String> urls;

  Gallery({
    required this.chapterId,
    required this.communityId,
    required this.eventId,
    required this.galleryId,
    required this.createdOn,
    required this.participants,
    required this.thumbnails,
    required this.urls,
  });

  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'communityId': communityId,
      'eventId': eventId,
      'galleryId': galleryId,
      'createdOn': createdOn.toIso8601String(),
      'participants': participants,
      'thumbnails': thumbnails,
      'urls': urls,
    };
  }
}
