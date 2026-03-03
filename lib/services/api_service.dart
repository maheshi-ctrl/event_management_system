import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = "http://172.20.10.9:5000";

  // LOGIN
  static Future<UserModel?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    }
    return null;
  }

  // GET EVENTS
  static Future<List<EventModel>> getEvents() async {
    final response = await http.get(Uri.parse("$baseUrl/events"));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => EventModel.fromJson(e)).toList();
    }
    return [];
  }

  // ADD EVENT (admin only)
  static Future<bool> addEvent(String title, String description, String role) async {
    final response = await http.post(
      Uri.parse("$baseUrl/events"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "role": role,
      }),
    );

    return response.statusCode == 200;
  }

  // UPDATE EVENT (admin only)
  static Future<bool> updateEvent(int eventId, String title, String description, String role) async {
    final response = await http.put(
      Uri.parse("$baseUrl/events/$eventId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "role": role,
      }),
    );

    return response.statusCode == 200;
  }

  // DELETE EVENT (admin only)
  static Future<bool> deleteEvent(int eventId, String role) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/events/$eventId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "role": role,
      }),
    );

    return response.statusCode == 200;
  }

  // RSVP (student only)
  static Future<bool> rsvp(int eventId, int studentId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/rsvp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "event_id": eventId,
        "student_id": studentId,
      }),
    );

    return response.statusCode == 200;
  }

  // GET RSVP LIST (all events - admin view)
  static Future<List<Map<String, dynamic>>> getRsvp() async {
    final response = await http.get(Uri.parse("$baseUrl/rsvp"));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    }
    return [];
  }

  // ✅ NEW: GET RSVPs for a specific event
  static Future<List<UserModel>> getRsvpsForEvent(int eventId) async {
    final response = await http.get(Uri.parse("$baseUrl/events/$eventId/rsvps"));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    }
    return [];
  }
}