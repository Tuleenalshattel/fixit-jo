import 'package:fixitjo_app/screens/chatbot_screen.dart';
import 'package:fixitjo_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'profile_customer_screen.dart';
import 'request_service_screen.dart';
import 'package:fixitjo_app/screens/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'rating_screen.dart';
import 'tracking_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = "";
  String customerName = "";

  @override
  void initState() {
    super.initState();
    getCustomerName();
  }

  Future<void> getCustomerName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      setState(() {
        customerName = doc.data()?['name'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('images/user.png'),
            ),
            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "WELCOME BACK",
                  style: TextStyle(fontSize: 10, color: Color(0xFF1E88E5)),
                ),
                Text(
                  "Hello ${customerName.isNotEmpty ? customerName : 'User'}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1E88E5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            const Text(
              "FixIt Jo",
              style: TextStyle(
                color: Color(0xFF1E88E5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Color(0xFF1E88E5),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔵 TOP BOX + SEARCH
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Need a fix?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Find the best pros in seconds.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),

                  /// 🔍 SEARCH
                  _SearchBox(
                    onChanged: (value) {
                      setState(() {
                        searchText = value.toLowerCase();
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔧 SERVICES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Service Categories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E88E5),
                  ),
                ),
                Text("View all", style: TextStyle(color: Color(0xFF1E88E5))),
              ],
            ),

            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                if ("plumbing".contains(searchText))
                  buildCategory(Icons.plumbing, "Plumbing"),

                if ("electrical".contains(searchText))
                  buildCategory(Icons.electrical_services, "Electrical"),

                if ("carpentry".contains(searchText))
                  buildCategory(Icons.handyman, "Carpentry"),

                if ("ac repair".contains(searchText))
                  buildCategory(Icons.ac_unit, "AC Repair"),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Ongoing Requests",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
              ),
            ),

            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('service_requests')
                  .orderBy('createdAt', descending: true)
                  .limit(1)
                  .snapshots(),
              builder: (context, snapshot) {
                print(
                  "CURRENT USER UID: ${FirebaseAuth.instance.currentUser?.uid}",
                );

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "No ongoing requests",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final data =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;
                final requestId = snapshot.data!.docs.first.id;

                final String category =
                    data['category']?.toString() ?? 'Service';

                final String technicianName =
                    data['technicianName']?.toString() ?? 'Waiting...';

                final String arrivalTime =
                    data['arrivalTime']?.toString() ?? '';

                final String status = data['status']?.toString() ?? 'pending';

                final bool isRated = data['rating'] != null;

                if (status == 'completed' && isRated) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "No ongoing requests",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.handyman, color: Colors.blue),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              status == 'accepted'
                                  ? "Technician: $technicianName"
                                  : status == 'completed'
                                  ? "Service completed"
                                  : "Waiting for technician...",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            if (status == 'accepted') ...[
                              const SizedBox(height: 4),
                              Text(
                                "Arriving in: $arrivalTime",

                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                            if (status == 'accepted') ...[
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E88E5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrackingScreen(
                                        requestId: requestId,
                                        isTechnician: false,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                label: const Text(
                                  'Track Technician',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                            if (status == 'completed' &&
                                data['rating'] == null) ...[
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RatingScreen(
                                        requestId: requestId,
                                        technicianId:
                                            data['technicianId']?.toString() ??
                                            '',
                                        technicianName:
                                            data['technicianName']
                                                ?.toString() ??
                                            'Technician',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("Rate Technician"),
                              ),
                            ],
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: status == 'accepted'
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: status == 'accepted'
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF1E88E5),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RequestServiceScreen(),
              ),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapScreen()),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatbotScreen()),
            );
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(name: "User", phone: "", userType: "Customer"),
              ),
            );
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

  Widget buildCategory(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(title),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final Function(String) onChanged;

  const _SearchBox({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Search for electrical, plumbing...",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
