import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingScreen extends StatefulWidget {
  final String requestId;
  final String technicianId;
  final String technicianName;

  const RatingScreen({
    super.key,
    required this.requestId,
    required this.technicianId,
    required this.technicianName,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int selectedRating = 4;
  final TextEditingController feedbackController = TextEditingController();

  final List<String> tags = [
    "Punctual",
    "Professional",
    "Fair Pricing",
    "Clean Work",
  ];

  final Set<String> selectedTags = {};

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  void toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  Future<void> submitRating() async {
    await FirebaseFirestore.instance
        .collection('service_requests')
        .doc(widget.requestId)
        .update({
          'rating': selectedRating,
          'feedback': feedbackController.text.trim(),
          'ratingTags': selectedTags.toList(),
          'ratedAt': FieldValue.serverTimestamp(),
        });

    await updateTechnicianAverageRating();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Rating submitted successfully")),
    );

    Navigator.pop(context);
  }

  Future<void> updateTechnicianAverageRating() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('service_requests')
        .where('technicianId', isEqualTo: widget.technicianId)
        .get();

    double total = 0;
    int count = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();

      if (data['rating'] != null) {
        total += (data['rating'] as num).toDouble();
        count++;
      }
    }

    if (count == 0) return;

    final average = total / count;

    await FirebaseFirestore.instance
        .collection('technicians')
        .doc(widget.technicianId)
        .update({'ratingAverage': average, 'ratingCount': count});
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0D7EA5);
    const Color lightBlue = Color(0xFFDDF2F8);
    const Color pageBackground = Color(0xFFEAEAEA);
    const Color cardColor = Color(0xFFF4F1F1);
    const Color textGrey = Color(0xFF8D8D8D);

    return Scaffold(
      backgroundColor: const Color(0xFF1F232B),
      body: Center(
        child: Container(
          width: 340,
          height: 690,
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: pageBackground,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFB8C0CC), width: 8),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF7EB8FF),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFF4F9BFF),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              const Text(
                                "Rate Your Experience",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F72B2),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 26),

                          Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 92,
                                    height: 92,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      image: const DecorationImage(
                                        image: AssetImage("images/user.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: -2,
                                    bottom: -2,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.verified,
                                        color: primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              Text(
                                widget.technicianName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 4),

                              const Text(
                                "Service Professional",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textGrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 24,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "How was the service?",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(5, (index) {
                                    final starIndex = index + 1;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedRating = starIndex;
                                        });
                                      },
                                      child: Icon(
                                        Icons.star,
                                        size: 33,
                                        color: starIndex <= selectedRating
                                            ? primaryColor
                                            : const Color(0xFFBCC4CD),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 18),
                                const Text(
                                  "Tap a star to rate",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFACB1B8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 22),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Your Feedback",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3E1E1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: TextField(
                              controller: feedbackController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText:
                                    "Share your experience with ${widget.technicianName}...",
                                hintStyle: const TextStyle(
                                  color: Color(0xFFB0B0B0),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(18),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: tags.map((tag) {
                              final isSelected = selectedTags.contains(tag);

                              return GestureDetector(
                                onTap: () => toggleTag(tag),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? lightBlue
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: isSelected
                                          ? primaryColor
                                          : const Color(0xFFE3E3E3),
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? primaryColor
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 28),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: submitRating,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Submit Rating",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
