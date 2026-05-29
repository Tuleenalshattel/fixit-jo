import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:fixitjo_app/services/app_language.dart';

class TechniciansByProfessionScreen extends StatelessWidget {
  final String professionName;

  const TechniciansByProfessionScreen({
    super.key,
    required this.professionName,
  });

  static const Color primary = Color(0xff45B8F2);

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
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
                Expanded(
                  child: Text(
                    lang.techniciansIn(professionName),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff0B5E8E),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Text(
              lang.managementPortal,
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
                color: Color(0xff0B5E8E),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              lang.expertsIn(professionName),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Text(lang.manageServiceQuality),

            const SizedBox(height: 24),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('technicians')
                  .where('specializations', arrayContains: professionName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      lang.noTechnicianFound,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return technicianCard(
                      context: context,
                      techId: doc.id,
                      imageUrl: data['imageUrl']?.toString() ?? '',
                      name: data['name']?.toString() ?? lang.technician,
                      phone: data['phone']?.toString() ?? '',
                      rating:
                          ((data['ratingAverage'] as num?)?.toDouble() ?? 0.0)
                              .toStringAsFixed(1),
                      jobs:
                          "${(data['jobsDone'] as num?)?.toInt() ?? 0} ${lang.jobs}",
                      isBlocked: data['isBlocked'] == true,
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget technicianCard({
    required BuildContext context,
    required String techId,
    required String imageUrl,
    required String name,
    required String phone,
    required String rating,
    required String jobs,
    required bool isBlocked,
  }) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    final double ratingValue = double.tryParse(rating) ?? 0.0;
    final bool alert = ratingValue > 0 && ratingValue < 3.5;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return placeholderImage();
                        },
                      )
                    : placeholderImage(),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
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

                    const SizedBox(height: 8),

                    Text(phone, style: const TextStyle(color: Colors.grey)),

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
                      child: Text(
                        alert ? lang.lowRatingAlert : lang.activeTechnician,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: alert ? const Color(0xffFFF1F1) : const Color(0xffF9F9F9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              alert ? lang.lowRatingDescription : lang.acceptablePerformance,
              style: TextStyle(color: alert ? Colors.red : Colors.black87),
            ),
          ),

          const SizedBox(height: 22),

          GestureDetector(
            onTap: () async {
              await FirebaseFirestore.instance
                  .collection('technicians')
                  .doc(techId)
                  .update({
                    'isBlocked': !isBlocked,
                    'available': isBlocked ? true : false,
                  });
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: isBlocked ? Colors.red : Colors.white,
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Center(
                child: Text(
                  isBlocked ? lang.unblockTechnician : lang.blockTechnician,
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

  Widget placeholderImage() {
    return Container(
      width: 85,
      height: 85,
      color: const Color(0xffE3F0FB),
      child: const Icon(Icons.person, color: Color(0xff0B5E8E), size: 40),
    );
  }
}
