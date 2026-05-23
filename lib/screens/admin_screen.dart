import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_reports_screen.dart';
import 'profession_screen.dart';
import 'settings_screen.dart';
import 'notification_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeContent(),
    CustomerReportsScreen(),
    ProfessionScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        height: 85,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomItem(
              icon: Icons.home,
              title: "Home",
              active: currentIndex == 0,
              onTap: () => setState(() => currentIndex = 0),
            ),
            BottomItem(
              icon: Icons.assessment_outlined,
              title: "Report",
              active: currentIndex == 1,
              onTap: () => setState(() => currentIndex = 1),
            ),
            BottomItem(
              icon: Icons.handyman_outlined,
              title: "Professions",
              active: currentIndex == 2,
              onTap: () => setState(() => currentIndex = 2),
            ),
            BottomItem(
              icon: Icons.settings_outlined,
              title: "Settings",
              active: currentIndex == 3,
              onTap: () => setState(() => currentIndex = 3),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  Future<int> countAllTechnicians() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('technicians')
        .get();
    return snapshot.docs.length;
  }

  Future<int> countPendingTechnicians() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('technicians')
        .where('isVerified', isEqualTo: false)
        .get();
    return snapshot.docs.length;
  }

  Future<int> countActiveRequests() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('service_requests')
        .where('status', whereIn: ['pending', 'accepted', 'arrived'])
        .get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.build, color: Color(0xff0A6C8E)),
                  SizedBox(width: 8),
                  Text(
                    "FixIt Jo",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('notifications')
                        .where('userId', isEqualTo: 'admin')
                        .where('isRead', isEqualTo: false)
                        .snapshots(),

                    builder: (context, snapshot) {
                      final unreadCount = snapshot.data?.docs.length ?? 0;

                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none,
                              size: 28,
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const NotificationScreen(userId: 'admin'),
                                ),
                              );
                            },
                          ),

                          if (unreadCount > 0)
                            Positioned(
                              right: 10,
                              top: 10,

                              child: Container(
                                width: 10,
                                height: 10,

                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(width: 10),

                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xff0A6C8E),

                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,

                      child: Icon(Icons.person, color: Color(0xff0A6C8E)),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            "System Overview",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(
            "Platform health and operational status.",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),

          const SizedBox(height: 24),

          FutureBuilder<int>(
            future: countAllTechnicians(),
            builder: (context, snapshot) {
              return overviewCard(
                color: const Color(0xff46B7F1),
                title: "TOTAL TECHNICIANS",
                value: "${snapshot.data ?? 0}",
                icon: Icons.engineering,
              );
            },
          ),

          const SizedBox(height: 18),

          FutureBuilder<int>(
            future: countActiveRequests(),
            builder: (context, snapshot) {
              return overviewCard(
                color: Colors.white,
                title: "ACTIVE REQUESTS",
                value: "${snapshot.data ?? 0}",
                subtitle: "Live service requests",
                darkText: true,
              );
            },
          ),

          const SizedBox(height: 18),

          FutureBuilder<int>(
            future: countPendingTechnicians(),
            builder: (context, snapshot) {
              return Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xffF6A33E),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "PENDING VERIFICATIONS",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${snapshot.data ?? 0}",
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff5C3A16),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "REVIEW QUEUE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 28),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Pending Verifications",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Profiles requiring administrative approval.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("View All", style: TextStyle(fontSize: 13)),
              ),
            ],
          ),

          const SizedBox(height: 18),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('technicians')
                .where('isVerified', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text(
                  "No pending technicians",
                  style: TextStyle(color: Colors.grey),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  return personCard(
                    context: context,
                    techId: doc.id,
                    imageUrl: data['imageUrl']?.toString() ?? '',
                    name: data['name']?.toString() ?? 'Technician',
                    job: data['specializations'] is List
                        ? (data['specializations'] as List).join(", ")
                        : 'Technician',
                    phone: data['phone']?.toString() ?? '',
                    tags: const ["PENDING APPROVAL"],
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 28),

          const Text(
            "Active Service Requests",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),

          const SizedBox(height: 6),

          const Text(
            "Live job tracking and service overview.",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 18),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('service_requests')
                .where('status', whereIn: ['pending', 'accepted', 'arrived'])
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text(
                  "No active service requests",
                  style: TextStyle(color: Colors.grey),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  return requestTile(
                    initials: getInitials(data['customerName'] ?? 'Customer'),
                    name: data['customerName']?.toString() ?? 'Customer',
                    service:
                        "${data['category'] ?? 'Service'} • ${doc.id.substring(0, 5)}",
                    technician:
                        data['technicianName']?.toString() ?? 'Not assigned',
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

String getInitials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  return name.isNotEmpty ? name[0].toUpperCase() : 'U';
}

Widget overviewCard({
  required Color color,
  required String title,
  required String value,
  String? subtitle,
  IconData? icon,
  bool darkText = false,
}) {
  return Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: darkText ? Colors.black87 : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: darkText ? Colors.black : Colors.white,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        if (icon != null)
          Icon(icon, size: 65, color: Colors.white.withOpacity(0.2)),
      ],
    ),
  );
}

Widget personCard({
  required BuildContext context,
  required String techId,
  required String imageUrl,
  required String name,
  required String job,
  required String phone,
  required List<String> tags,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          child: imageUrl.isEmpty ? const Icon(Icons.person, size: 36) : null,
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(job, style: const TextStyle(color: Colors.grey, fontSize: 15)),
        const SizedBox(height: 5),
        Text(phone, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: tags
              .map(
                (e) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('technicians')
                      .doc(techId)
                      .update({
                        'isVerified': true,
                        'available': true,
                        'rejected': false,
                      });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Technician verified")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('technicians')
                      .doc(techId)
                      .update({
                        'isVerified': false,
                        'available': false,
                        'rejected': true,
                      });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Technician rejected")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Reject",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget requestTile({
  required String initials,
  required String name,
  required String service,
  required String technician,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            initials,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(service, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Row(
          children: [
            const Icon(Icons.circle, size: 10, color: Colors.teal),
            const SizedBox(width: 6),
            Text(
              technician,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    ),
  );
}

class BottomItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;
  final VoidCallback onTap;

  const BottomItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xff4EC3F7) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? Colors.white : Colors.black54),
            const SizedBox(height: 4),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: active ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
