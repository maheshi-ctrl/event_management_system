import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class RsvpListScreen extends StatefulWidget {
  final int eventId;
  const RsvpListScreen({required this.eventId, Key? key}) : super(key: key);

  @override
  State<RsvpListScreen> createState() => _RsvpListScreenState();
}

class _RsvpListScreenState extends State<RsvpListScreen> {
  late Future<List<UserModel>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = ApiService.getRsvpsForEvent(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accepted Students"),
        backgroundColor: Colors.blueAccent,
        elevation: 8,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<UserModel>>(
          future: _studentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Failed to load RSVPs",
                  style: TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No students have registered yet",
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              );
            }

            final students = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      student.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Text(student.email),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}