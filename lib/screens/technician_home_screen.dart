import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_customer.dart';
import 'package:geolocator/geolocator.dart';
import 'tracking_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fixitjo_app/screens/notification_screen.dart';

class TechnicianHomeScreen extends StatefulWidget {
  const TechnicianHomeScreen({super.key});

  static const primary = Color(0xFF2196F3);

  @override
  State<TechnicianHomeScreen> createState() => _TechnicianHomeScreenState();
}

class _TechnicianHomeScreenState extends State<TechnicianHomeScreen> {
  bool isAvailable = true;
  int _selectedIndex = 0;

  String technicianName = "Technician";
  String technicianPhone = "";
  double ratingAverage = 0.0;
  int jobsDone = 0;
  int ratingCount = 0;

  @override
  void initState() {
    super.initState();
    getTechnicianData();
    updateTechnicianLocation();
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) {
        return "Location not available";
      }

      final place = placemarks.first;

      final street = place.street ?? '';
      final area = place.subLocality ?? place.locality ?? '';
      final city = place.administrativeArea ?? '';

      return [
        street,
        area,
        city,
      ].where((part) => part.trim().isNotEmpty).join(', ');
    } catch (e) {
      return "Location not available";
    }
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

      ratingAverage = (data?['ratingAverage'] as num?)?.toDouble() ?? 0.0;

      jobsDone = (data?['jobsDone'] as num?)?.toInt() ?? 0;

      ratingCount = (data?['ratingCount'] as num?)?.toInt() ?? 0;
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
          'technicianPhone': techData['phone'],
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final requestRef = FirebaseFirestore.instance
        .collection('service_requests')
        .doc(requestId);

    final requestDoc = await requestRef.get();
    final requestData = requestDoc.data();

    if (requestData == null) return;

    // قائمة التقنيين يلي رفضو
    final List declined = List.from(requestData['declinedTechnicians'] ?? []);

    declined.add(user.uid);

    final category = requestData['category'];

    final customerLat = (requestData['latitude'] as num?)?.toDouble();

    final customerLng = (requestData['longitude'] as num?)?.toDouble();

    if (customerLat == null || customerLng == null) return;

    // جيب التقنيين المتاحين
    final techSnapshot = await FirebaseFirestore.instance
        .collection('technicians')
        .where('available', isEqualTo: true)
        .where('isVerified', isEqualTo: true)
        .get();

    QueryDocumentSnapshot<Map<String, dynamic>>? nearestTech;

    double minDistance = double.infinity;

    for (final tech in techSnapshot.docs) {
      final techData = tech.data();

      // إذا رفض قبل هيك تخطاه
      if (declined.contains(tech.id)) continue;

      // تحقق من التخصص
      final specs = techData['specializations'];

      if (specs is List && !specs.contains(category)) {
        continue;
      }

      final techLat = (techData['latitude'] as num?)?.toDouble();

      final techLng = (techData['longitude'] as num?)?.toDouble();

      if (techLat == null || techLng == null) continue;

      final distance = Geolocator.distanceBetween(
        customerLat,
        customerLng,
        techLat,
        techLng,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestTech = tech;
      }
    }

    // ما لقينا حد
    if (nearestTech == null) {
      await requestRef.update({
        'status': 'declined',
        'declinedTechnicians': declined,
      });
    } else {
      final newTechData = nearestTech.data();

      await requestRef.update({
        'status': 'pending',
        'technicianId': nearestTech.id,
        'technicianName': newTechData['name'],
        'declinedTechnicians': declined,
      });
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request moved to another technician')),
    );
  }

  void showReportCustomerDialog({
    required String requestId,
    required String customerId,
    required String customerName,
    required String customerPhone,
  }) {
    String selectedType = "Unpaid Service";
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Report Customer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                items: const [
                  DropdownMenuItem(
                    value: "Unpaid Service",
                    child: Text("Unpaid Service"),
                  ),
                  DropdownMenuItem(
                    value: "Abusive Behavior",
                    child: Text("Abusive Behavior"),
                  ),
                  DropdownMenuItem(
                    value: "Fake Request",
                    child: Text("Fake Request"),
                  ),
                  DropdownMenuItem(value: "Other", child: Text("Other")),
                ],
                onChanged: (value) {
                  selectedType = value!;
                },
                decoration: const InputDecoration(labelText: "Report Type"),
              ),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Reason"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final techId = FirebaseAuth.instance.currentUser!.uid;

                await FirebaseFirestore.instance
                    .collection('customer_reports')
                    .add({
                      'customerId': customerId,
                      'customerName': customerName,
                      'customerPhone': customerPhone,
                      'technicianId': techId,
                      'technicianName': technicianName,
                      'requestId': requestId,
                      'reportType': selectedType,
                      'reason': reasonController.text.trim(),
                      'status': 'pending',
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                if (!context.mounted) return;
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Report submitted to admin")),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
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
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFF2196F3)),
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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('notifications')
                        .where(
                          'userId',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                        )
                        .where('isRead', isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final unreadCount = snapshot.data?.docs.length ?? 0;
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NotificationScreen(),
                                ),
                              );
                            },
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
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
                          child: Icon(Icons.bolt, color: Color(0xFF2196F3)),
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
                              onTap: () async {
                                setState(() {
                                  isAvailable = true;
                                });

                                final user = FirebaseAuth.instance.currentUser;

                                if (user != null) {
                                  await FirebaseFirestore.instance
                                      .collection('technicians')
                                      .doc(user.uid)
                                      .update({'available': true});
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isAvailable
                                      ? const Color(0xFF2196F3)
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
                              onTap: () async {
                                setState(() {
                                  isAvailable = false;
                                });

                                final user = FirebaseAuth.instance.currentUser;

                                if (user != null) {
                                  await FirebaseFirestore.instance
                                      .collection('technicians')
                                      .doc(user.uid)
                                      .update({'available': false});
                                }
                              },
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

              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('technicians')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  final data = snapshot.data?.data() as Map<String, dynamic>?;

                  final liveJobsDone =
                      (data?['jobsDone'] as num?)?.toInt() ?? 0;
                  final liveRatingAverage =
                      (data?['ratingAverage'] as num?)?.toDouble() ?? 0.0;
                  final liveRatingCount =
                      (data?['ratingCount'] as num?)?.toInt() ?? 0;

                  return Column(
                    children: [
                      Row(
                        children: [
                          statCard(
                            "JOBS DONE",
                            liveJobsDone.toString(),
                            "Completed jobs",
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          statCard(
                            "RATING",
                            "${liveRatingAverage.toStringAsFixed(1)} ★",
                            "$liveRatingCount reviews",
                          ),
                        ],
                      ),
                    ],
                  );
                },
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
                      final String customerPhone =
                          data['customerPhone']?.toString() ?? '';
                      final String customerId =
                          data['customerId']?.toString() ?? '';
                      final String category =
                          data['category']?.toString() ?? 'Service';
                      final String description =
                          data['description']?.toString() ?? 'No description';
                      final double lat =
                          (data['latitude'] as num?)?.toDouble() ?? 0.0;
                      final double lng =
                          (data['longitude'] as num?)?.toDouble() ?? 0.0;
                      final String status = data['status'] ?? 'pending';
                      final List<String> imageUrls = List<String>.from(
                        data['imageUrls'] ?? [],
                      );

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
                        customerId: customerId,
                        customerPhone: customerPhone,
                        service: category,
                        lat: lat,
                        lng: lng,
                        time: description,
                        imageUrls: imageUrls,
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
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.grey,
        onTap: (index) async {
          setState(() => _selectedIndex = index);
          if (index == 1) {
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
    required String customerPhone,
    required String customerId,
    required String service,
    required double lat,
    required double lng,
    required List<String> imageUrls,
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
                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),

                    const SizedBox(width: 6),

                    Text(
                      customerPhone,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                FutureBuilder<String>(
                  future: getAddressFromLatLng(lat, lng),
                  builder: (context, snapshot) {
                    final address = snapshot.data ?? "Loading location...";

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    );
                  },
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
                if (imageUrls.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(imageUrls[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
                        backgroundColor: const Color(0xFF2196F3),
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
                        final techId = FirebaseAuth.instance.currentUser!.uid;
                        final reqDoc = await FirebaseFirestore.instance
                            .collection('service_requests')
                            .doc(requestId)
                            .get();
                        final customerId = reqDoc.data()?['customerId'];
                        await FirebaseFirestore.instance
                            .collection('service_requests')
                            .doc(requestId)
                            .update({
                              'status': 'completed',
                              'completedAt': FieldValue.serverTimestamp(),
                            });

                        await FirebaseFirestore.instance
                            .collection('technicians')
                            .doc(techId)
                            .update({'jobsDone': FieldValue.increment(1)});
                        // إشعار للزبون
                        if (customerId != null) {
                          await FirebaseFirestore.instance
                              .collection('notifications')
                              .add({
                                'userId': customerId,
                                'title': 'Service Completed ✅',
                                'body':
                                    'Your service has been completed. Please rate your experience.',
                                'type': 'service_completed',
                                'requestId': requestId,
                                'isRead': false,
                                'createdAt': FieldValue.serverTimestamp(),
                              });
                        }

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
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        showReportCustomerDialog(
                          requestId: requestId,
                          customerId: customerId,
                          customerName: name,
                          customerPhone: customerPhone,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Report Customer"),
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
          Icon(icon, size: 18, color: const Color(0xFF2196F3)),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}
