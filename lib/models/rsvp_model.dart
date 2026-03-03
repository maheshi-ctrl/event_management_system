class RsvpModel {
  final int eventId;
  final int studentId;

  RsvpModel({
    required this.eventId,
    required this.studentId,
  });

  Map<String, dynamic> toJson() {
    return {
      "event_id": eventId,
      "student_id": studentId,
    };
  }
}