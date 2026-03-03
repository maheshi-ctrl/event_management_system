import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class AddEventScreen extends StatefulWidget {
  final UserModel user; // receive logged-in user

  const AddEventScreen({required this.user, Key? key}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    bool success = await ApiService.addEvent(
      _titleController.text.trim(),
      _descController.text.trim(),
      widget.user.role, // pass role to backend
    );

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Event added successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // return success to dashboard
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to add event"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Event"),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: "Event Title",
                            prefixIcon: const Icon(Icons.title, color: Colors.blueAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? "Enter event title" : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _descController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: "Event Description",
                            prefixIcon: const Icon(Icons.description, color: Colors.blueAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Enter event description"
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                  onPressed: _saveEvent,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "Save Event",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    minimumSize: const Size(double.infinity, 55),
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
      ),
    );
  }
}