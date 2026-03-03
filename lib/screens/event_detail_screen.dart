import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  final int studentId;

  EventDetailScreen({required this.event, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: Colors.blueAccent,
        elevation: 8,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        event.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  bool success = await ApiService.rsvp(event.id, studentId);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Registered Successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to register"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.check_circle, color: Colors.white),
                label: Text(
                  "Accept Event",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey, // standout action color
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}