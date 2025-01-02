import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  final String complaintId;

  ComplaintDetailsScreen({required this.complaintId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Details'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('complaints')
            .doc(complaintId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Complaint not found.'));
          }

          var complaint = snapshot.data!.data() as Map<String, dynamic>? ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.report, color: Colors.blueAccent, size: 30),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Complaint Type: ${complaint['complaint_type'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey.shade400, height: 30),
                    _buildSectionTitle('Description'),
                    SizedBox(height: 5),
                    Text(
                      complaint['details'] ?? 'No description provided.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    Divider(color: Colors.grey.shade400, height: 30),
                    Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: complaint['status'] == 'Resolved'
                                ? Colors.green
                                : complaint['status'] == 'In Progress'
                                    ? Colors.orangeAccent
                                    : Colors.red,
                            size: 22),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Status: ${complaint['status'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildInfoRow(
                        icon: Icons.person,
                        label: 'Submitted by',
                        value: complaint['student_id'] ?? 'N/A',
                        iconColor: Colors.blueGrey),
                    SizedBox(height: 10),
                    _buildInfoRow(
                        icon: Icons.date_range,
                        label: 'Date Submitted',
                        value: complaint['date'] ?? 'N/A',
                        iconColor: Colors.orangeAccent),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method to create section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Helper method to build a row with an icon and text for information display
  Widget _buildInfoRow(
      {required IconData icon,
      required String label,
      required String value,
      required Color iconColor}) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
