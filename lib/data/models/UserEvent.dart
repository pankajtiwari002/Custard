class UserEvent {
  String id;
  String eventId;
  String uid;
  String paid;
  String ticket;
  String qrlink;

  UserEvent({
    required this.id,
    required this.eventId,
    required this.uid,
    required this.paid,
    required this.ticket,
    required this.qrlink,
  });

  // Convert the UserEvent object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'uid': uid,
      'paid': paid,
      'ticket': ticket,
      'qrlink': qrlink,
    };
  }
}