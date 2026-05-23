import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerReportsScreen extends StatelessWidget {
  const CustomerReportsScreen({super.key});

  static const Color primary = Color(0xff46B7F1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            /// TITLE
            const Text(
              "Customer Reports",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            const Text(
              "Review customer complaints submitted by technicians.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            /// REPORTS
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('customer_reports')
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),

                    child: const Center(
                      child: Text(
                        "No customer reports",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                final reports = snapshot.data!.docs;

                return Column(
                  children: reports.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return reportCard(
                      context: context,
                      reportId: doc.id,

                      customerId: data['customerId'] ?? '',

                      customerName: data['customerName'] ?? 'Customer',

                      customerPhone: data['customerPhone'] ?? 'No phone',

                      technicianName: data['technicianName'] ?? 'Technician',

                      reason: data['reason'] ?? 'No reason provided',

                      reportType: data['reportType'] ?? 'General Report',

                      requestId: data['requestId'] ?? '',
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ================= REPORT CARD =================
  Widget reportCard({
    required BuildContext context,
    required String reportId,
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String technicianName,
    required String reason,
    required String reportType,
    required String requestId,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// REPORT TYPE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),

            decoration: BoxDecoration(
              color: const Color(0xffFFD7D7),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              reportType.toUpperCase(),

              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// CUSTOMER NAME
          Text(
            customerName,

            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          /// PHONE
          Row(
            children: [
              const Icon(Icons.phone_outlined, color: primary, size: 20),

              const SizedBox(width: 8),

              Text(customerPhone),
            ],
          ),

          const SizedBox(height: 12),

          /// TECHNICIAN
          Row(
            children: [
              const Icon(Icons.engineering, color: primary, size: 20),

              const SizedBox(width: 8),

              Expanded(child: Text("Reported by: $technicianName")),
            ],
          ),

          const SizedBox(height: 12),

          /// REQUEST ID
          if (requestId.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.receipt_long, color: primary, size: 20),

                const SizedBox(width: 8),

                Expanded(child: Text("Request ID: $requestId")),
              ],
            ),

          const SizedBox(height: 18),

          /// REASON BOX
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Text(
              reason,

              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 22),

          /// BUTTONS
          Row(
            children: [
              /// BLOCK
              Expanded(
                child: ElevatedButton(
                  onPressed: customerId.isEmpty
                      ? null
                      : () async {
                          /// BLOCK CUSTOMER
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(customerId)
                              .set({
                                'isBlocked': true,
                              }, SetOptions(merge: true));

                          /// UPDATE REPORT STATUS
                          await FirebaseFirestore.instance
                              .collection('customer_reports')
                              .doc(reportId)
                              .update({'status': 'blocked'});

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Customer blocked successfully"),
                            ),
                          );
                        },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffD81616),

                    padding: const EdgeInsets.symmetric(vertical: 14),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(
                    "Block Customer",

                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// IGNORE
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('customer_reports')
                        .doc(reportId)
                        .update({'status': 'ignored'});

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Report ignored")),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffD7EEFF),

                    padding: const EdgeInsets.symmetric(vertical: 14),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(
                    "Ignore",

                    style: TextStyle(color: Color(0xff0A6C8E)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
