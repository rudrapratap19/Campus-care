import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'complaint_details_screen.dart';

class AuthorityDashboard extends StatelessWidget {
  final String authorityId; // Pass authority ID

  AuthorityDashboard({required this.authorityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authority Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .where('authority', isEqualTo: authorityId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No complaints found.'));
          }
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var complaint = doc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  title: Text(
                    'Complaint: ${complaint['complaint_type']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.grey, size: 18),
                            SizedBox(width: 5),
                            Text(
                              'Status: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              complaint['status'],
                              style: TextStyle(
                                color: complaint['status'] == 'Resolved'
                                    ? Colors.green
                                    : (complaint['status'] == 'In Progress'
                                        ? Colors.orange
                                        : Colors.red),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Submitted by: ${complaint['student_id'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  trailing: DropdownButton<String>(
                    value: complaint['status'],
                    icon: Icon(Icons.arrow_drop_down),
                    underline: SizedBox(),
                    items: ['Pending', 'In Progress', 'Resolved'].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (newStatus) {
                      FirebaseFirestore.instance
                          .collection('complaints')
                          .doc(doc.id)
                          .update({'status': newStatus});
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComplaintDetailsScreen(
                          complaintId: doc.id,
                        ),
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
