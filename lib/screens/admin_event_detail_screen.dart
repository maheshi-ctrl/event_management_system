import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';

class AdminEventDetailScreen extends StatefulWidget {
  final EventModel event;
  final String role; // pass "admin" for backend check

  const AdminEventDetailScreen({required this.event, required this.role, Key? key})
      : super(key: key);

  @override
  _AdminEventDetailScreenState createState() => _AdminEventDetailScreenState();
}

class _AdminEventDetailScreenState extends State<AdminEventDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.event.title);
    descController = TextEditingController(text: widget.event.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Event"),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Event Title",
                  prefixIcon: const Icon(Icons.title, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),


              TextField(
                controller: descController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Event Description",
                  prefixIcon: const Icon(Icons.description, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ---- Action Buttons ----
              Row(
                children: [
                  // Update Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        bool success = await ApiService.updateEvent(
                          widget.event.id,
                          titleController.text.trim(),
                          descController.text.trim(),
                          widget.role,
                        );
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Event updated successfully"),
                              backgroundColor: Colors.blueAccent,
                            ),
                          );
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to update event"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text("Update"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Delete Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        bool success = await ApiService.deleteEvent(
                          widget.event.id,
                          widget.role,
                        );
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Event deleted successfully"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to delete event"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}