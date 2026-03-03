import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';
import 'add_event_screen.dart';
import 'rsvp_list_screen.dart';
import 'admin_event_detail_screen.dart';
import 'login_screen.dart';

class AdminDashboard extends StatefulWidget {
  final UserModel user;
  const AdminDashboard({required this.user, Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<EventModel>> eventsFuture;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    eventsFuture = ApiService.getEvents();
  }

  void refreshEvents() {
    setState(() {
      eventsFuture = ApiService.getEvents();
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
            );
          },
        ),
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.blueAccent,
        elevation: 8,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Menu clicked")),
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
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildDashboardView(),
            _buildSettingsView(),
            _buildReportsView(),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Reports",
          ),
        ],
      ),
    );
  }


  Widget _buildDashboardView() {
    return SingleChildScrollView(
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRt9MszX-gjD4HEBgCizpEUXu0Qor8wnti-FuO7VpbV1U3SGPMVG8ShQpM&s", // example admin image URL
              height: 220,
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

          // Add Event Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEventScreen(user: widget.user),
                  ),
                );
                if (result == true) refreshEvents();
              },
              icon: const Icon(Icons.add),
              label: const Text(" Add Event"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),

          // View Events Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.event, size: 40, color: Colors.blue),
                title: const Text(
                  "View Events",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _EventListScreen(user: widget.user),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSettingsView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Settings",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blueAccent),
              title: const Text("Profile"),
              subtitle: const Text("Update your name, email, and image"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.lock, color: Colors.blueAccent),
              title: const Text("Security"),
              subtitle: const Text("Change password and manage access"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildReportsView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFF92B8D3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Reports",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.lightBlueAccent),
              title: const Text("Event Participation"),
              subtitle: const Text("View RSVP statistics per event"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.feedback, color: Colors.lightBlueAccent),
              title: const Text("Feedback Reports"),
              subtitle: const Text("Analyze student feedback"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Event List Screen ----
class _EventListScreen extends StatefulWidget {
  final UserModel user;
  const _EventListScreen({required this.user});

  @override
  State<_EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<_EventListScreen> {
  late Future<List<EventModel>> _events;

  @override
  void initState() {
    super.initState();
    _events = ApiService.getEvents();
  }

  void refreshEvents() {
    setState(() {
      _events = ApiService.getEvents();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Event List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent, // AppBar color
        elevation: 6, // adds subtle shadow
      ),
      body: FutureBuilder<List<EventModel>>(
        future: _events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load events"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No events available"));
          }

          final events = snapshot.data!;
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                      child: const Text("View RSVPs"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RsvpListScreen(eventId: event.id),
                          ),
                        );
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminEventDetailScreen(
                            event: event,
                            role: widget.user.role,
                          ),
                        ),
                      );
                      if (result == true) refreshEvents();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}