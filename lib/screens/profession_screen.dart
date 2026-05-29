import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'technicians_by_profession_screen.dart';
import 'package:provider/provider.dart';
import 'package:fixitjo_app/services/app_language.dart';

class ProfessionScreen extends StatefulWidget {
  const ProfessionScreen({super.key});

  @override
  State<ProfessionScreen> createState() => _ProfessionScreenState();
}

class _ProfessionScreenState extends State<ProfessionScreen> {
  String searchQuery = "";

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  IconData getIcon(String title) {
    if (title == "Plumbing") return Icons.plumbing;
    if (title == "Electrical") return Icons.electrical_services;
    if (title == "AC Repair" || title == "AC Repair") return Icons.ac_unit;
    if (title == "Carpentry") return Icons.handyman_outlined;
    if (title == "Painting") return Icons.format_paint;
    if (title == "Blacksmith") return Icons.hardware;
    if (title == "Heating") return Icons.fireplace;
    if (title == "Furniture") return Icons.chair;

    return Icons.work;
  }

  Future<int> getActiveProsCount(String title) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('technicians')
        .where('specializations', arrayContains: title)
        // .where('isVerified', isEqualTo: true)
        .get();

    return snapshot.docs.length;
  }

  void addProfessionDialog() {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    titleController.clear();
    descriptionController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(lang.addProfession),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: lang.ProfessioName),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: lang.description),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(lang.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty) return;

                await FirebaseFirestore.instance.collection('service').add({
                  'name': titleController.text.trim(),
                  'description': descriptionController.text.trim(),
                  'createdAt': FieldValue.serverTimestamp(),
                });

                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: Text(lang.add),
            ),
          ],
        );
      },
    );
  }

  void editProfession(String docId, String oldTitle, String oldDescription) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    titleController.text = oldTitle;
    descriptionController.text = oldDescription;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(lang.editProfession),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController),
              const SizedBox(height: 12),
              TextField(controller: descriptionController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(lang.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('service')
                    .doc(docId)
                    .update({
                      'name': titleController.text.trim(),
                      'description': descriptionController.text.trim(),
                    });

                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: Text(lang.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteProfession(String docId) async {
    await FirebaseFirestore.instance.collection('service').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          children: [
            const SizedBox(height: 10),
            Text(
              lang.manageProfessions,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 35),
            Text(
              lang.professionalCategories,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),

            GestureDetector(
              onTap: addProfessionDialog,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff48B9F4), Color(0xff2AA9E9)],
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        lang.addNewProfession,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xffECECEC),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: lang.searchProfessions,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('service')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      lang.noProfessionFound,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title = data['name']?.toString() ?? '';

                  return title.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
                }).toList();

                return Column(
                  children: docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['name']?.toString() ?? '';
                    final description = data['description']?.toString() ?? '';

                    return FutureBuilder<int>(
                      future: getActiveProsCount(title),
                      builder: (context, countSnapshot) {
                        final count = countSnapshot.data ?? 0;

                        return professionCard(
                          docId: doc.id,
                          title: title,
                          description: description,
                          count: "$count ${lang.activePros}",
                          icon: getIcon(title),
                          color: const Color(0xffBFE5FF),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget professionCard({
    required String docId,
    required String title,
    required String description,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    final lang = Provider.of<AppLanguage>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TechniciansByProfessionScreen(professionName: title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xffFAF6F7),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, size: 32, color: Colors.black87),
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          editProfession(docId, title, description),
                      icon: const Icon(Icons.edit_outlined, size: 22),
                    ),
                    IconButton(
                      onPressed: () => deleteProfession(docId),
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              lang.translateService(title),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xffEAEAEA),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                count,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
