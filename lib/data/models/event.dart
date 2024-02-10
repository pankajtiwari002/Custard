import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String communityId;
  String title;
  String description;
  int dateTime;
  GeoPoint location;
  String coverPhotoUrl;
  double ticketPrice;
  bool isFreeEvent;
  bool isApproved;
  bool isRemoveLimit;
  int capacity;
  List hostedBy;

  Event({
    required this.id,
    required this.communityId,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.ticketPrice,
    required this.capacity,
    required this.hostedBy,
    required this.coverPhotoUrl,
    required this.isApproved,
    required this.isFreeEvent,
    required this.isRemoveLimit,
  });

  // From JSON method to convert a map to an Event object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dateTime: (json['dateTime']), // Assuming date is stored as a Firestore Timestamp
      location: json['location'] ?? GeoPoint(0.0, 0.0),
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      capacity: json['capacity'] ?? 0,
      hostedBy: List.from(json['hostedBy'] ?? []),
      coverPhotoUrl: json["coverPhotoUrl"],
      isFreeEvent: json["isFreeEvent"],
      isRemoveLimit: json["isRemoveLimit"],
      isApproved: json["isApproved"],
      communityId: json["communityId"] ?? ""
    );
  }

  // To JSON method to convert an Event object to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime, // Depending on your use case, you might want to convert date to a format like Timestamp for Firestore
      'location': location,
      'ticketPrice': ticketPrice,
      'capacity': capacity,
      'hostedBy': hostedBy,
      "coverPhotoUrl": coverPhotoUrl,
      "isFreeEvent": isFreeEvent,
      "isRemoveLimit": isRemoveLimit,
      "isApproved": isApproved,
      "communityId": communityId
    };
  }
}
