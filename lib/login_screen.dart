import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authority_dashboard.dart';
import 'student_dashboard.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      DocumentSnapshot userDoc = await _firestore.collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        String userType = userDoc['user_type'] ?? 'Unknown';
        String? authorityRole = userDoc['authority_role'];

        if (userType == 'Student') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentDashboard(student: userDoc['name'])),
          );
        } else if (userType == 'Authority') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthorityDashboard(authorityId: authorityRole ?? '')),
          );
        } else {
          _showErrorDialog("Unknown user type. Please contact support.");
        }
      } else {
        _showErrorDialog("User data not found. Please contact support.");
      }
    } catch (e) {
      _showErrorDialog("Sign in failed. Please check your credentials.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'College Complaint App',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.blueAccent,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(25),
                  child: const Icon(
                    Icons.support_agent,
                    size: 80,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  isPassword: false,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPanel()),
                  ),
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for building input fields with icons
  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      required bool isPassword}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueAccent),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.blueAccent.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Please enter your $label' : null,
    );
  }
}
