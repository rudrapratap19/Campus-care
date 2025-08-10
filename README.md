# 🎓 Campus Care - College Complaint Management System

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-blue.svg" alt="Flutter Version">
  <img src="https://img.shields.io/badge/Firebase-Enabled-orange.svg" alt="Firebase">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green.svg" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
</div>

<div align="center">
  <h3>📝 🏫 🔧 📋</h3>
  <p><em>A comprehensive complaint management system built with Flutter for college students, faculty, and administrators to streamline issue reporting and resolution.</em></p>
</div>

---

## 📱 Features

### 🎓 Student Portal
- **Easy Complaint Registration**: Submit complaints with detailed descriptions
- **Category-based Complaints**: Hostel, Academic, Infrastructure, Canteen, Transportation
- **Photo/Video Upload**: Attach media evidence to complaints
- **Real-time Status Tracking**: Track complaint resolution progress
- **Complaint History**: View all previously submitted complaints
- **Anonymous Complaints**: Option to submit complaints anonymously

### 👨‍🏫 Faculty & Staff Portal
- **Department-wise Access**: View complaints specific to departments
- **Priority Management**: Set and manage complaint priorities
- **Status Updates**: Update complaint status and add remarks
- **Bulk Actions**: Handle multiple complaints efficiently
- **Analytics Dashboard**: View complaint statistics and trends

### 🏛️ Admin Dashboard
- **Complete System Overview**: Centralized complaint management
- **User Management**: Manage students, faculty, and staff accounts
- **Department Management**: Create and manage different departments
- **Report Generation**: Generate detailed reports and analytics
- **System Configuration**: Configure complaint categories and workflows
- **Notification Management**: Send updates and announcements

### 📊 Real-time Features
- **Live Status Updates**: Real-time complaint status notifications
- **Push Notifications**: Instant alerts for new complaints and updates
- **Dashboard Analytics**: Real-time charts and statistics
- **Auto-assignment**: Automatically assign complaints to relevant departments

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform mobile development |
| **Dart** | Programming language |
| **Firebase Firestore** | Real-time database |
| **Firebase Auth** | Authentication system |
| **Firebase Storage** | File and image storage |


---


---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (2.17+)
- Firebase project setup
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
git clone https://github.com/rudrapratap19/Campus-care.git
cd Campus-care

text

2. **Install dependencies**
flutter pub get

text

3. **Firebase Setup**
- Create a new Firebase project
- Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- Enable Firestore Database, Authentication, and Storage
- Set up Firebase Cloud Messaging for notifications

4. **Run the application**
flutter run

text

---

## 🎯 Key Functionality

### Complaint Submission
// Submit new complaint
Complaint complaint = Complaint(
title: "AC not working in Room 101",
description: "The air conditioner has been...",
category: ComplaintCategory.hostel,
priority: Priority.medium,
submittedBy: currentUser.id,
attachments: [imageFile],
timestamp: DateTime.now(),
);


### Real-time Status Updates
// Stream complaint updates
StreamBuilder<DocumentSnapshot>(
stream: FirebaseFirestore.instance
.collection('complaints')
.doc(complaintId)
.snapshots(),
builder: (context, snapshot) {
// Build real-time status widget
},
);


### Department Assignment
// Auto-assign complaint to department
void assignComplaint(Complaint complaint) {
String departmentId = getDepartmentByCategory(complaint.category);
complaint.assignedTo = departmentId;
complaint.status = ComplaintStatus.assigned;
}


---

## 📸 Screenshots

<div align="center">
  <table>
    <tr>
      <td><img src="screenshots/login.png" width="200"/></td>
      <td><img src="screenshots/student-dashboard.png" width="200"/></td>
      <td><img src="screenshots/submit-complaint.png" width="200"/></td>
      <td><img src="screenshots/admin-dashboard.png" width="200"/></td>
    </tr>
    <tr>
      <td align="center"><em>Login Screen</em></td>
      <td align="center"><em>Student Dashboard</em></td>
      <td align="center"><em>Submit Complaint</em></td>
      <td align="center"><em>Admin Dashboard</em></td>
    </tr>
  </table>
</div>

---

## 🎨 User Roles & Permissions

### 👨‍🎓 Student
- Submit new complaints
- View own complaint history
- Track complaint status


### 👨‍🏫 Faculty/Staff
- View department-specific complaints
- Update complaint status
- Add remarks and solutions
- Manage student queries

---

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Firebase** for backend services
- **Material Design** for UI/UX guidelines
- **College Administration** for requirements and feedback
- **Open Source Community** for continuous support

---

## 📞 Contact & Support

- **Developer**: [Rudra Pratap](https://github.com/rudrapratap19)
- **Email**: [rpsinghiiitr@gmail.com]
- **Project Link**: [https://github.com/rudrapratap19/Campus-care](https://github.com/rudrapratap19/Campus-care)
- **Issues**: [Report Issues](https://github.com/rudrapratap19/Campus-care/issues)

---

<div align="center">
  <h3>🏫 Transforming Campus Life, One Complaint at a Time!</h3>
  <p>Making campus management more efficient and student-friendly.</p>
  
  **⭐ Star this repository if you find it helpful!**
</div>

---

