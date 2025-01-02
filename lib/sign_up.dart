import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SignUpPanel extends StatefulWidget {
  const SignUpPanel({Key? key}) : super(key: key);

  @override
  _SignUpPanelState createState() => _SignUpPanelState();
}

class _SignUpPanelState extends State<SignUpPanel> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController = TextEditingController();

  String? _userType;
  String? _authorityRole;

  final List<String> _authorityRoles = [
    'Director', 'Academic FIC', 'Hostel Warden', 'Student FIC', 'Sport Secretary',
    'Cultural Secretary', 'General Secretary', 'Academic Secretary', 'Mess Secretary', 'Registrar',
  ];

  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': _nameController.text,
        'email': _emailController.text.trim(),
        'rollNo': _rollNoController.text,
        'user_type': _userType,
        'authority_role': _userType == 'Authority' ? _authorityRole : null,
      });

      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog("Sign up failed. Please try again.");
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Created'),
        content: const Text('Your account has been successfully created!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
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
      appBar: AppBar(title: const Text('Create Account'), backgroundColor: Colors.blueAccent),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(_nameController, 'Name', Icons.person),
                const SizedBox(height: 16),
                _buildTextField(_rollNoController, 'Roll No. / Code No.', Icons.numbers),
                const SizedBox(height: 16),
                _buildTextField(_emailController, 'Email', Icons.email, inputType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField(_passwordController, 'Password', Icons.lock, isPassword: true),
                const SizedBox(height: 16),
                _buildTextField(_reEnterPasswordController, 'Re-enter Password', Icons.lock, isPassword: true),
                const SizedBox(height: 16),
                _buildDropdownField(
                  label: 'User Type',
                  value: _userType,
                  items: const ['Student', 'Authority'],
                  onChanged: (value) => setState(() => _userType = value),
                ),
                const SizedBox(height: 16),
                if (_userType == 'Authority')
                  _buildDropdownField(
                    label: 'Authority Role',
                    value: _authorityRole,
                    items: _authorityRoles,
                    onChanged: (value) => setState(() => _authorityRole = value),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _signUp,
                  child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    ),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType inputType = TextInputType.text, bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
      keyboardType: inputType,
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }
}
