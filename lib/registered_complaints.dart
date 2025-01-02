import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'complaint_details_screen.dart';

class RegisteredComplaints extends StatelessWidget {
  final String studentId;

  RegisteredComplaints({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .where('student_id', isEqualTo: studentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No complaints submitted.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var complaint = doc.data() as Map<String, dynamic>;
              String complaintType = complaint['complaint_type'] ?? 'N/A';
              String status = complaint['status'] ?? 'N/A';
              IconData statusIcon;
              Color statusColor;

              // Set icon and color based on status
              switch (status.toLowerCase()) {
                case 'resolved':
                  statusIcon = Icons.check_circle;
                  statusColor = Colors.green;
                  break;
                case 'pending':
                  statusIcon = Icons.hourglass_empty;
                  statusColor = Colors.orange;
                  break;
                case 'in progress':
                  statusIcon = Icons.loop;
                  statusColor = Colors.blue;
                  break;
                default:
                  statusIcon = Icons.info;
                  statusColor = Colors.grey;
              }

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    complaintType,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(statusIcon, color: statusColor),
                      const SizedBox(width: 8),
                      Text(
                        'Status: $status',
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComplaintDetailsScreen(complaintId: doc.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
