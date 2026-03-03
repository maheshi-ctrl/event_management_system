import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import 'admin_dashboard.dart';
import 'student_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      UserModel? user = await ApiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        if (user.role.toLowerCase() == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AdminDashboard(user: user)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => StudentDashboard(user: user)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid email or password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Server error. Check connection."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89BDE1), Color(0xFF505985)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            width: 350,
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event, size: 60, color: Color(0xFF2563EB)),
                SizedBox(height: 10),
                Text("Campus Event System",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 25),
                isLoading
                    ? CircularProgressIndicator()
                    : CustomButton(
                  text: "Login",
                  onPressed: handleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}