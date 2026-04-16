import 'package:fixitjo_app/screens/chatbot_screen.dart';
import 'package:fixitjo_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'profile_customer_screen.dart';
import 'request_service_screen.dart';
import 'package:fixitjo_app/screens/notification_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              children: const [
                Text(
                  "WELCOME BACK",
                  style: TextStyle(fontSize: 10, color: Color(0xFF1E88E5)),
                ),
                Text(
                  "Hello, Omar",
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
                children: const [
                  Text(
                    "Need a fix?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Find the best pros in seconds.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 20),
                  _SearchBox(),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
                buildCategory(Icons.plumbing, "Plumbing"),
                buildCategory(Icons.electrical_services, "Electrical"),
                buildCategory(Icons.handyman, "Carpentry"),
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

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('images/ac.png.jpg'),
                  ),
                  const SizedBox(width: 10),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AC Maintenance",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Professional: Mike's Cooling",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "IN PROGRESS",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Nearby Technicians",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E88E5),
                  ),
                ),
                Text("Map view", style: TextStyle(color: Color(0xFF1E88E5))),
              ],
            ),

            const SizedBox(height: 15),

            buildTechnician(
              "Mohammad Saleh",
              "Master Electrician • 1.2km",
              "4.9",
              "images/mohammad.png.png",
            ),

            buildTechnician(
              "Yousef Ahmad",
              "Interior Painter • 2.5km",
              "4.8",
              "images/yousef.png.png",
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E88E5),
        child: const Icon(Icons.add),
        onPressed: () {},
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

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
                builder: (context) => ProfilePage(
                  name: "Omar Hassan",
                  phone: "+9627XXXXXXX",
                  userType: "Customer",
                ),
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

  Widget buildTechnician(
    String name,
    String job,
    String rating,
    String imagePath,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundImage: AssetImage(imagePath)),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.verified,
                      color: Color(0xFF1E88E5),
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(job, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 18),
              Text(rating),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Search for electrical, plumbing...",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
