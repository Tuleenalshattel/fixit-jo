import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'edit_profile_customer.dart';
import 'settings_customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String phone;
  final String userType;

  const ProfilePage({
    super.key,
    required this.name,
    required this.phone,
    required this.userType,
  });

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "No date";

    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }

  IconData getServiceIcon(String title) {
    if (title == 'Plumbing') return Icons.plumbing;
    if (title == 'Electrical') return Icons.flash_on;
    if (title == 'AC Repair') return Icons.ac_unit;
    if (title == 'Carpentry') return Icons.handyman;
    return Icons.build;
  }

  Color getStatusColor(String status) {
    if (status == 'COMPLETED') return Colors.green;
    if (status == 'DECLINED' || status == 'CANCELLED') return Colors.red;
    if (status == 'ACCEPTED' || status == 'ARRIVED') return Colors.blue;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SettingsScreen(name: name, phone: phone),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 3),
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("images/user.png"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "User",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("", style: TextStyle(color: Colors.grey)),
                    ],
                  );
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;

                final realName = data?['name']?.toString() ?? 'User';
                final realPhone = data?['phone']?.toString() ?? '';

                return Column(
                  children: [
                    Text(
                      realName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(realPhone, style: const TextStyle(color: Colors.grey)),
                  ],
                );
              },
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5DBCEB), Color(0xFF4AA3D8)],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Text(
                    "My Requests",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text("View all", style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('service_requests')
                    .where('customerId', isEqualTo: uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No requests yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final requests = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final data =
                          requests[index].data() as Map<String, dynamic>;

                      final title = data['category']?.toString() ?? 'Service';

                      final status =
                          data['status']?.toString().toUpperCase() ?? 'PENDING';

                      final createdAt = data['createdAt'] as Timestamp?;

                      return RequestItem(
                        title: title,
                        date: formatDate(createdAt),
                        status: status,
                        icon: getServiceIcon(title),
                        color: getStatusColor(status),
                      );
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Request"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class RequestItem extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final IconData icon;
  final Color color;

  const RequestItem({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(date, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: TextStyle(color: color, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
