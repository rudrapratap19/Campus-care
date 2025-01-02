import 'package:college_complaint/login_screen.dart';
import 'package:flutter/material.dart';
import 'complain_form.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key, required this.student});
  final String student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('College Complaint App', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 10.0,
        shadowColor: Colors.blue.withOpacity(0.5),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 60, 159, 240), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Header Text with enhanced styling
              const Text(
                'Welcome to Student Dashboard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Subtitle Text with subtle color
              Text(
                'Manage your complaints efficiently',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Register Complaint Card with improved design
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComplaintForm(sstudentid: student),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.forum_rounded,
                          size: 60,
                          color: Color.fromARGB(255, 60, 159, 240),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Register Complaint',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 60, 159, 240),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Logout Card with improved styling
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.logout,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Footer with a bolder font and subtle color
              const Text(
                'Powered by CCA - College Complaint App',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
