import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  static const Color primary = Color(0xFF1593C9);
  static const Color bg = Color(0xFFF3F3F3);
  static const Color dark = Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topHeader(),
                    const SizedBox(height: 18),

                    const Text(
                      "Overview",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Manage your workforce and monitor real-time service requests.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 22),

                    _statsCard(),

                    const SizedBox(height: 28),

                    _pendingVerificationHeader(),

                    const SizedBox(height: 14),

                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('technicians')
                          .where('isVerified', isEqualTo: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: const Center(
                              child: Text(
                                "No technicians pending verification",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          );
                        }

                        final technicians = snapshot.data!.docs;

                        return Column(
                          children: technicians.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;

                            final name =
                                data['name']?.toString() ?? 'Technician';
                            final phone =
                                data['phone']?.toString() ?? 'No phone';
                            final experience =
                                data['experience']?.toString() ?? '0';

                            String job = 'Technician';

                            if (data['specializations'] is List &&
                                (data['specializations'] as List).isNotEmpty) {
                              job = (data['specializations'] as List).first
                                  .toString();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _technicianCard(
                                context: context,
                                techId: doc.id,
                                name: name,
                                job: job,
                                phone: phone,
                                city: "Experience: $experience years",
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _bottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _topHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF8FC7FF), width: 1.5),
          ),
          child: const Icon(Icons.menu, color: primary, size: 24),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            "Admin\nDashboard",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: dark,
              height: 1.1,
            ),
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primary, width: 2),
          ),
          child: const Icon(Icons.admin_panel_settings, color: primary),
        ),
      ],
    );
  }

  Widget _statsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFFCDE8FA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.insert_chart_outlined_rounded, size: 30, color: dark),
          SizedBox(height: 18),
          Text(
            "94%",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Approval Rate",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: dark,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "High verification quality maintained this month.",
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _pendingVerificationHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            "Technicians Pending\nVerification",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: dark,
              height: 1.2,
            ),
          ),
        ),
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFCDE8FA),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.verified_user, color: Color(0xFF176E9E)),
          ),
        ),
      ],
    );
  }

  Widget _technicianCard({
    required BuildContext context,
    required String techId,
    required String name,
    required String job,
    required String phone,
    required String city,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F0FB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: primary, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.bolt, size: 15, color: primary),
                        const SizedBox(width: 4),
                        Text(
                          job,
                          style: const TextStyle(
                            fontSize: 14,
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Icon(Icons.phone, size: 16, color: Colors.black45),
              const SizedBox(width: 8),
              Text(
                phone,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.work_outline, size: 17, color: Colors.black45),
              const SizedBox(width: 8),
              Text(
                city,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('technicians')
                        .doc(techId)
                        .update({'isVerified': true, 'available': true});

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Technician approved successfully"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF18B676),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    "Verify",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                    elevation: 0,
                    backgroundColor: const Color(0xFFF7D6D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    "Reject",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB63030),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomItem(
            icon: Icons.grid_view_rounded,
            label: "Home",
            selected: true,
          ),
          _BottomItem(
            icon: Icons.verified_user_outlined,
            label: "Verification",
          ),
          _BottomItem(icon: Icons.assignment_outlined, label: "Requests"),
          _BottomItem(icon: Icons.settings_outlined, label: "Settings"),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _BottomItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFDDF2FB) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: selected ? AdminScreen.primary : Colors.blueGrey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: selected ? AdminScreen.primary : Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
