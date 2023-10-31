class Chapter {
  String aboutChapter;
  String analiticsID;
  String approvalFlow;
  String approvalRequired;
  String chapter_id;
  String community_id;
  String location;
  String price;
  String theme;

  Chapter({
    required this.aboutChapter,
    required this.analiticsID,
    required this.approvalFlow,
    required this.approvalRequired,
    required this.chapter_id,
    required this.community_id,
    required this.location,
    required this.price,
    required this.theme,
  });

  Map<String, dynamic> toJson() {
    return {
      'aboutChapter': aboutChapter,
      'analiticsID': analiticsID,
      'approvalFlow': approvalFlow,
      'approvalRequired': approvalRequired,
      'chapter_id': chapter_id,
      'community_id': community_id,
      'location': location,
      'price': price,
      'theme': theme,
    };
  }
}
