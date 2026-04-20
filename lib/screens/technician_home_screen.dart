import 'package:flutter/material.dart';

class TechnicianHomeScreen extends StatelessWidget {
  const TechnicianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0C6A85);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "WELCOME BACK",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "Hello, Marcus",
                        style: TextStyle(
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

              /// SERVICE STATUS
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
                          child: Icon(Icons.bolt, color: primary),
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

                    /// SWITCH
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECECEC),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
                                child: Text(
                                  "Available",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Expanded(child: Center(child: Text("Busy"))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// STATS
              Row(
                children: [
                  statCard("EARNINGS", "\$1,240", "+12% from last week", true),
                  const SizedBox(width: 10),
                  statCard("JOBS DONE", "42", "This month", false),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  statCard("RATING", "4.9 ⭐", "128 reviews", false),
                  const SizedBox(width: 10),
                  statCard("EFFICIENCY", "94%", "On-time rate", false),
                ],
              ),

              const SizedBox(height: 20),

              /// INCOMING REQUESTS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Incoming Requests",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("View map view", style: TextStyle(color: primary)),
                ],
              ),

              const SizedBox(height: 10),

              requestCard(
                name: "Sarah Mitchell",
                service: "Kitchen Faucet Repair",
                location: "124 Maple Ave, Brooklyn (1.2 miles)",
                time: "Today, 2:00 PM - 4:00 PM",
                primary: primary,
              ),

              requestCard(
                name: "David Chen",
                service: "AC Maintenance",
                location: "45th Floor, Skyline Towers (3.5 miles)",
                time: "Today, ASAP",
                primary: primary,
              ),

              requestCard(
                name: "Elena Rodriguez",
                service: "Electrical Inspection",
                location: "88 West End, Manhattan (4.1 miles)",
                time: "Tomorrow, 9:00 AM",
                primary: primary,
              ),

              const SizedBox(height: 20),

              /// QUICK LINKS
              const Text(
                "Quick Links",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  quickBtn("View Certifications"),
                  quickBtn("Service Logs"),
                  quickBtn("Help Center"),
                ],
              ),
            ],
          ),
        ),
      ),

      /// BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Requests"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// STAT CARD
  Widget statCard(String title, String value, String subtitle, bool highlight) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: highlight
              ? Border.all(color: const Color(0xFF0C6A85), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  /// REQUEST CARD
  Widget requestCard({
    required String name,
    required String service,
    required String location,
    required String time,
    required Color primary,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1502920917128-1aa500764cbd",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(service, style: const TextStyle(color: Colors.blue)),

                const SizedBox(height: 8),
                Text(location, style: const TextStyle(color: Colors.grey)),
                Text(
                  "Expected: $time",
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text("Accept"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Decline",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// QUICK BUTTON
  Widget quickBtn(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(text),
    );
  }
}
