import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_complaint/registered_complaints.dart';
import 'package:flutter/material.dart';

class ComplaintForm extends StatefulWidget {
  const ComplaintForm({required this.sstudentid});
  final String sstudentid;

  @override
  _ComplaintFormState createState() => _ComplaintFormState(studentid: sstudentid);
}

class _ComplaintFormState extends State<ComplaintForm> {
  _ComplaintFormState({required this.studentid});

  final String studentid;
  final _formKey = GlobalKey<FormState>();
  String? selectedComplaintType;
  String? selectedStudentType;
  String? selectedDepartment;
  String? selectedSemester;
  String? selectedBatch;
  String? selectedAuthority;
  TextEditingController contactController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerComplaint() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final complaintId = _firestore.collection('complaints').doc().id;
        await _firestore.collection('complaints').doc(complaintId).set({
          'complaint_id': complaintId,
          'complaint_type': selectedComplaintType.toString(),
          'student_type': selectedStudentType.toString(),
          'department': selectedDepartment.toString(),
          'semester': selectedSemester.toString(),
          'batch': selectedBatch.toString(),
          'authority': selectedAuthority.toString(),
          'contact': contactController.text,
          'date': dateController.text,
          'details': detailsController.text,
          'status': 'Pending',
          'student_id': studentid,
        });

        _clearFields();
        _showSuccessDialog();
      } catch (e) {
        print("Error adding complaint: $e");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearFields() {
    setState(() {
      selectedComplaintType = null;
      selectedStudentType = null;
      selectedDepartment = null;
      selectedSemester = null;
      selectedBatch = null;
      selectedAuthority = null;
      contactController.clear();
      dateController.clear();
      detailsController.clear();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Submission Successful"),
          content: const Text("Your complaint has been submitted successfully."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisteredComplaints(studentId: studentid),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Form'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildDropdown(
                    label: "Complaint Type",
                    value: selectedComplaintType,
                    items: ["Academic", "Infrastructure", "Financial", "Other"],
                    onChanged: (value) => setState(() => selectedComplaintType = value),
                  ),
                  _buildDropdown(
                    label: "Student Type",
                    value: selectedStudentType,
                    items: ["Undergraduate", "Postgraduate"],
                    onChanged: (value) => setState(() => selectedStudentType = value),
                  ),
                  _buildDropdown(
                    label: "Department",
                    value: selectedDepartment,
                    items: ["CSE", "M&C", "AI&DS"],
                    onChanged: (value) => setState(() => selectedDepartment = value),
                  ),
                  _buildDropdown(
                    label: "Semester",
                    value: selectedSemester,
                    items: ["1", "2", "3", "4", "5", "6", "7", "8"],
                    onChanged: (value) => setState(() => selectedSemester = value),
                  ),
                  _buildDropdown(
                    label: "Batch",
                    value: selectedBatch,
                    items: ["2021", "2022", "2023", "2024"],
                    onChanged: (value) => setState(() => selectedBatch = value),
                  ),
                  _buildDropdown(
                    label: "Authority",
                    value: selectedAuthority,
                    items: [
                      "Director", "Academic FIC", "Hostel Warden", "Student FIC",
                      "Sport Secretary", "Cultural Secretary", "General Secretary",
                      "Academic Secretary", "Mess Secretary", "Registrar",
                    ],
                    onChanged: (value) => setState(() => selectedAuthority = value),
                  ),
                  _buildTextFormField(
                    label: "Contact Number",
                    icon: Icons.phone,
                    controller: contactController,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextFormField(
                    label: "Select Date",
                    icon: Icons.calendar_today,
                    controller: dateController,
                    onTap: () => _selectDate(context),
                    readOnly: true,
                  ),
                  _buildTextFormField(
                    label: "Complaint Details",
                    icon: Icons.description,
                    controller: detailsController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : registerComplaint,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.teal,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.arrow_drop_down),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value == null ? "Please select $label" : null,
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    GestureTapCallback? onTap,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value == null || value.isEmpty ? "Enter $label" : null,
      ),
    );
  }
}
