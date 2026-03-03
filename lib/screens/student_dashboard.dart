import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';
import 'event_detail_screen.dart';
import 'login_screen.dart';

class StudentDashboard extends StatefulWidget {
  final UserModel user;
  const StudentDashboard({required this.user, Key? key}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;
  final feedbackController = TextEditingController();

  List<Widget> get _pages => [
    _buildDashboardPage(),
    _buildProfilePage(),
    _buildFeedbackPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.blueAccent,
        elevation: 8,


        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: "Menu",
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Menu clicked")),
            );
          },
        ),


        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _pages[_selectedIndex],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 12,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: "Feedback",
          ),
        ],
      ),
    );
  }


  Widget _buildDashboardPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Online image above cards
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGal507FQLGW-mrBxfEMBX5EEoMP2OiWysqw&s",
              height: 250,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red, size: 50);
              },
            ),
          ),

          // View Events Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const Icon(Icons.event,
                    size: 40, color: Colors.blueAccent),
                title: const Text(
                  "View Events",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventListScreen(user: widget.user),
                    ),
                  );
                },
              ),
            ),
          ),

          // Add Feedback Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const Icon(Icons.feedback,
                    size: 40, color: Colors.blueAccent),
                title: const Text(
                  "Add Feedback",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Navigate directly to Feedback tab
                  setState(() {
                    _selectedIndex = 2; // Feedback tab index
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProfilePage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text("Email: ${widget.user.email}"),
              const SizedBox(height: 5),
              Text("Role: ${widget.user.role}"),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildFeedbackPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Submit Feedback",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: feedbackController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Enter your feedback here...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              if (feedbackController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter feedback")),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Feedback submitted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
              feedbackController.clear();
            },
            icon: const Icon(Icons.send),
            label: const Text("Submit"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Event List Screen ----
class EventListScreen extends StatefulWidget {
  final UserModel user;
  const EventListScreen({required this.user, Key? key}) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late Future<List<EventModel>> eventsFuture;

  @override
  void initState() {
    super.initState();
    eventsFuture = ApiService.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Events"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: FutureBuilder<List<EventModel>>(
                future: eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error loading events"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No events available"));
                  }

                  final events = snapshot.data!;
                  return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Card(
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                                title: Text(
                                    event.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                ),
                              subtitle: Text(event.description),
                              trailing: ElevatedButton(
                                child: const Text("View"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EventDetailScreen(
                                        event: event,
                                        studentId: widget.user.id,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
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

