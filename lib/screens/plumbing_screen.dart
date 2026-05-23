import 'package:flutter/material.dart';

class PlumbingScreen extends StatefulWidget {
  const PlumbingScreen({super.key});

  @override
  State<PlumbingScreen> createState() => _PlumbingScreenState();
}

class _PlumbingScreenState extends State<PlumbingScreen> {
  List<bool> blockedList = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      bottomNavigationBar: Container(
        height: 85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(Icons.home, "Home"),
            navItem(Icons.assessment_outlined, "Report"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xff45B8F2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.handyman, color: Colors.black),
                  SizedBox(height: 3),
                  Text(
                    "Professions",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            navItem(Icons.settings_outlined, "Settings"),
          ],
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: Color(0xff0B5E8E),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Plumbing Technicians",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff0B5E8E),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "MANAGEMENT PORTAL",
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
                color: Color(0xff0B5E8E),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Expert Plumbers",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            const Text(
              "Manage and monitor plumbing service quality.\nReview technician performance and handle feedback.",
            ),

            const SizedBox(height: 24),

            technicianCard(
              index: 0,
              context: context,
              image: "images/plumber1.png",
              name: "Omar Ahmad",
              rating: "4.9",
              jobs: "248 jobs",
              tag: "MASTER PLUMBER",
              note: "Consistently receives praise for punctuality and repairs.",
              alert: false,
            ),

            const SizedBox(height: 30),

            technicianCard(
              index: 1,
              context: context,
              image: "images/plumber2.png",
              name: "Yazan Amar",
              rating: "4.7",
              jobs: "156 jobs",
              tag: "DRAIN SPECIALIST",
              note: "High success rate in complex drainage issues.",
              alert: false,
            ),

            const SizedBox(height: 30),

            technicianCard(
              index: 2,
              context: context,
              image: "images/plumber3.jpg",
              name: "Anas Fares",
              rating: "3.2",
              jobs: "42 jobs",
              tag: "JUNIOR PLUMBER",
              note: "Reports of delayed arrivals and incomplete work.",
              alert: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget technicianCard({
    required int index,
    required BuildContext context,
    required String image,
    required String name,
    required String rating,
    required String jobs,
    required String tag,
    required String note,
    required bool alert,
  }) {
    bool isBlocked = blockedList[index];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  image,
                  width: 85,
                  height: 85,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 5),
                        Text(rating),
                        const SizedBox(width: 10),
                        Text(jobs),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: alert
                            ? const Color(0xffECECEC)
                            : const Color(0xffDDF1FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(tag),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: alert ? const Color(0xffFFF1F1) : const Color(0xffF9F9F9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert ? "PERFORMANCE ALERT" : "LATEST ADMIN NOTE",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: alert ? Colors.red : Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(note),
              ],
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: smallButton(Icons.chat_bubble_outline, "Message", () {
                  TextEditingController controller = TextEditingController();

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Message"),
                        content: TextField(
                          controller: controller,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Type message",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Message Sent")),
                              );
                            },
                            child: const Text("Send"),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: smallButton(Icons.edit_outlined, "Feedback", () {
                  int selected = 0;
                  TextEditingController controller = TextEditingController();

                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setStateDialog) {
                          return AlertDialog(
                            title: const Text("Feedback"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (i) {
                                    return GestureDetector(
                                      onTap: () {
                                        setStateDialog(() {
                                          selected = i + 1;
                                        });
                                      },
                                      child: Icon(
                                        Icons.star,
                                        color: i < selected
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                    );
                                  }),
                                ),
                                Text("Rating: $selected"),
                                TextField(controller: controller, maxLines: 3),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Submitted")),
                                  );
                                },
                                child: const Text("Submit"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),

          const SizedBox(height: 22),

          GestureDetector(
            onTap: () {
              setState(() {
                blockedList[index] = !blockedList[index];
              });
            },
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: isBlocked ? Colors.red : Colors.white,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Center(
                child: Text(
                  isBlocked ? "Unblock Technician" : "Block Technician",
                  style: TextStyle(
                    color: isBlocked ? Colors.white : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget smallButton(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon), const SizedBox(width: 10), Text(text)],
        ),
      ),
    );
  }

  Widget navItem(IconData icon, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(icon), const SizedBox(height: 4), Text(title)],
    );
  }
}
