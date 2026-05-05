import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_customer.dart';
import 'package:geolocator/geolocator.dart';
import 'tracking_screen.dart';

class TechnicianHomeScreen extends StatefulWidget {
  const TechnicianHomeScreen({super.key});

  static const primary = Color(0xFF0C6A85);

  @override
  State<TechnicianHomeScreen> createState() => _TechnicianHomeScreenState();
}

class _TechnicianHomeScreenState extends State<TechnicianHomeScreen> {
  bool isAvailable = true;
  int _selectedIndex = 0;

  String technicianName = "Technician";
  String technicianPhone = "";

  @override
  void initState() {
    super.initState();
    getTechnicianData();
    updateTechnicianLocation();
  }

  Future<void> getTechnicianData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('technicians')
        .doc(user.uid)
        .get();

    final data = doc.data();
    if (!mounted) return;

    setState(() {
      technicianName = data?['name']?.toString() ?? 'Technician';
      technicianPhone = data?['phone']?.toString() ?? '';
    });
  }

  Future<void> updateTechnicianLocation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever)
      return;

    final position = await Geolocator.getCurrentPosition();

    await FirebaseFirestore.instance
        .collection('technicians')
        .doc(user.uid)
        .update({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'available': true,
        });
  }

  Future<void> acceptRequest(String requestId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final techDoc = await FirebaseFirestore.instance
        .collection('technicians')
        .doc(user.uid)
        .get();

    if (!techDoc.exists) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Technician data not found')),
      );
      return;
    }

    final techData = techDoc.data()!;

    final requestDoc = await FirebaseFirestore.instance
        .collection('service_requests')
        .doc(requestId)
        .get();

    final requestData = requestDoc.data();
    if (requestData == null) return;

    await FirebaseFirestore.instance
        .collection('service_requests')
        .doc(requestId)
        .update({
          'status': 'accepted',
          'technicianId': user.uid,
          'technicianName': techData['name'],
          'technicianImage': techData['imageUrl'],
          'acceptedAt': FieldValue.serverTimestamp(),
          'arrivalTime': '20 min',
        });

    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': requestData['customerId'],
      'title': 'Request Accepted',
      'body': '${techData['name']} accepted your request',
      'type': 'request_accepted',
      'requestId': requestId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Request accepted')));
  }

  Future<void> declineRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection('service_requests')
        .doc(requestId)
        .update({'status': 'declined'});

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Request declined')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: TechnicianHomeScreen.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "WELCOME BACK",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "Hello, $technicianName",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications_none),
                ],
              ),

              const SizedBox(height: 20),

              // Service Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        CircleAvatar(
                          backgroundColor: Color(0xFFE6EEF1),
                          child: Icon(
                            Icons.bolt,
                            color: TechnicianHomeScreen.primary,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Service Status",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Manage your work visibility",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECECEC),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isAvailable = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isAvailable
                                      ? TechnicianHomeScreen.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    "Available",
                                    style: TextStyle(
                                      color: isAvailable
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isAvailable = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: !isAvailable
                                      ? TechnicianHomeScreen.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    "Busy",
                                    style: TextStyle(
                                      color: !isAvailable
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stats
              Row(
                children: [
                  statCard("EARNINGS", "\$1,240", "+12% from last week"),
                  const SizedBox(width: 10),
                  statCard("JOBS DONE", "42", "This month"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  statCard("RATING", "4.9 ★", "128 reviews"),
                  const SizedBox(width: 10),
                  statCard("EFFICIENCY", "94%", "On-time rate"),
                ],
              ),

              const SizedBox(height: 20),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Incoming Requests",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Live request",
                    style: TextStyle(color: TechnicianHomeScreen.primary),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Stream of requests
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('service_requests')
                    .where(
                      'technicianId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                    )
                    .where(
                      'status',
                      whereIn: ['pending', 'accepted', 'arrived'],
                    )
                    .orderBy('createdAt', descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "No requests yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  // فلترة إضافية أمان
                  final activeDocs = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final status = data['status'];
                    return status != 'completed';
                  }).toList();

                  if (activeDocs.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "No current job",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: activeDocs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final String customerName =
                          data['customerName']?.toString() ?? 'Customer';
                      final String category =
                          data['category']?.toString() ?? 'Service';
                      final String description =
                          data['description']?.toString() ?? 'No description';
                      final double lat =
                          (data['latitude'] as num?)?.toDouble() ?? 0.0;
                      final double lng =
                          (data['longitude'] as num?)?.toDouble() ?? 0.0;
                      final String status = data['status'] ?? 'pending';

                      IconData serviceIcon = Icons.build;
                      if (category == 'Plumbing')
                        serviceIcon = Icons.plumbing;
                      else if (category == 'Electrical')
                        serviceIcon = Icons.electrical_services;
                      else if (category == 'Carpentry')
                        serviceIcon = Icons.handyman;
                      else if (category == 'Cleaning')
                        serviceIcon = Icons.cleaning_services;
                      else if (category == 'AC Repair')
                        serviceIcon = Icons.ac_unit;

                      return requestCard(
                        requestId: doc.id,
                        name: customerName,
                        service: category,
                        location:
                            "Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}",
                        time: description,
                        icon: serviceIcon,
                        status: status,
                        badge: "NEW REQUEST",
                        onAccept: () => acceptRequest(doc.id),
                        onDecline: () => declineRequest(doc.id),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Quick Links",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  quickBtn(Icons.verified, "View Certifications"),
                  quickBtn(Icons.access_time, "Service Logs"),
                  quickBtn(Icons.support_agent, "Help Center"),
                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: TechnicianHomeScreen.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) async {
          setState(() => _selectedIndex = index);
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(
                  name: technicianName,
                  phone: technicianPhone,
                ),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "HOME"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "REQUESTS"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "MAP"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "PROFILE"),
        ],
      ),
    );
  }

  Widget statCard(String title, String value, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget requestCard({
    required String requestId,
    required String name,
    required String service,
    required String location,
    required String time,
    required IconData icon,
    required String status,
    String? badge,
    required VoidCallback onAccept,
    required VoidCallback onDecline,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Color(0xFFF1F5F9),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 46,
                    color: TechnicianHomeScreen.primary,
                  ),
                ),
              ),
              if (badge != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: badge == "URGENT" ? Colors.orange : Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color(0xFFE6EEF1),
                      child: Icon(icon, color: TechnicianHomeScreen.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(service, style: const TextStyle(color: Colors.blue)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.description, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        time,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (status == 'pending') ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TechnicianHomeScreen.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: onAccept,
                          child: const Text(
                            "Accept",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE0E0E0),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: onDecline,
                          child: const Text(
                            "Decline",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                if (status == 'accepted') ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TechnicianHomeScreen.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrackingScreen(
                              requestId: requestId,
                              isTechnician: true,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Track Customer",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],

                if (status == 'arrived') ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('service_requests')
                            .doc(requestId)
                            .update({'status': 'completed'});
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Job Completed")),
                        );
                      },
                      child: const Text(
                        "Finish Job",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget quickBtn(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: TechnicianHomeScreen.primary),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}
