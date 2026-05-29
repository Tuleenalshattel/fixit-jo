import 'package:fixitjo_app/screens/chatbot_screen.dart';
import 'package:flutter/material.dart';
import 'profile_customer_screen.dart';
import 'request_service_screen.dart';
import 'package:fixitjo_app/screens/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'rating_screen.dart';
import 'tracking_screen.dart';
import 'all_categories.dart';
import 'package:provider/provider.dart';
import 'package:fixitjo_app/services/app_language.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = "";
  String customerName = "";
  int _currentIndex = 0;

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
    final lang = Provider.of<AppLanguage>(context);

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
                  lang.welcomeBackHome,
                  style: TextStyle(fontSize: 10, color: Color(0xFF1E88E5)),
                ),
                Text(
                  lang.helloUser(
                    customerName.isNotEmpty ? customerName : lang.user,
                  ),
                  style: const TextStyle(
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOP CARD
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
                  Text(
                    lang.needAFix,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lang.findBestPros,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      hintText: lang.searchFor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang.serviceCategories,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E88E5),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllCategoriesScreen(),
                      ),
                    );
                  },
                  child: Text(
                    lang.viewAll,
                    style: TextStyle(color: Color(0xFF1E88E5)),
                  ),
                ),
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
                if ("plumbing ${lang.plumbing}".toLowerCase().contains(
                  searchText,
                ))
                  buildCategory(Icons.plumbing, "Plumbing"),
                if ("electrical ${lang.electrical}".toLowerCase().contains(
                  searchText,
                ))
                  buildCategory(Icons.electrical_services, "Electrical"),
                if ("carpentry ${lang.carpentry}".toLowerCase().contains(
                  searchText,
                ))
                  buildCategory(Icons.handyman, "Carpentry"),
                if ("ac repair ${lang.acRepair}".toLowerCase().contains(
                  searchText,
                ))
                  buildCategory(Icons.ac_unit, "AC Repair"),
              ],
            ),

            const SizedBox(height: 25),

            Text(
              lang.ongoingRequests,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E88E5),
              ),
            ),

            const SizedBox(height: 10),

            //Observe Pattern usage
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('service_requests')
                  .where(
                    'customerId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                  )
                  .orderBy('createdAt', descending: true)
                  .limit(1)
                  .snapshots(),

              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      lang.noOngoingRequests,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final data =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;

                final requestId = snapshot.data!.docs.first.id;

                final status = data['status'] ?? 'pending';

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.handyman, color: Colors.blue),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.translateService(data['category'] ?? ''),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              status == 'accepted'
                                  ? lang.technicianAssigned
                                  : status == 'completed'
                                  ? lang.complete
                                  : lang.waitingForTechnician,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 6),

                            Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: Colors.grey,
                                ),

                                const SizedBox(width: 6),

                                Text(
                                  data['technicianPhone'] ?? '',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            if (status == 'accepted') ...[
                              const SizedBox(height: 8),
                              ElevatedButton(
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
                                child: Text(lang.trackTechnician),
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
                                child: Text(lang.rateTechnician),
                              ),
                            ],
                          ],
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

      floatingActionButton: FloatingActionButton.small(
        backgroundColor: const Color(0xFF1E88E5),
        child: const Icon(Icons.chat, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF1E88E5),
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

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
              MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(name: "User", phone: "", userType: "Customer"),
              ),
            );
          }
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: lang.home),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: lang.request),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: lang.profile,
          ),
        ],
      ),
    );
  }

  Widget buildCategory(IconData icon, String title) {
    final lang = Provider.of<AppLanguage>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequestServiceScreen(selectedService: title),
          ),
        );
      },
      child: Container(
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
            Text(lang.translateService(title)),
          ],
        ),
      ),
    );
  }
}
