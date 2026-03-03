class EventModel {
  final int id;
  final String title;
  final String description;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}