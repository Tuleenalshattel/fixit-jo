import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'request_service_screen.dart';
import 'package:provider/provider.dart';
import 'package:fixitjo_app/services/app_language.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  String searchQuery = "";
  String selectedService = "";

  IconData getServiceIcon(String name) {
    if (name == "Plumbing") return Icons.plumbing;
    if (name == "Electrical") return Icons.electrical_services;
    if (name == "Carpentry") return Icons.handyman;
    if (name == "AC Repair") return Icons.ac_unit;
    if (name == "Painting") return Icons.format_paint;
    if (name == "Blacksmith") return Icons.hardware;
    if (name == "Furniture") return Icons.chair;
    if (name == "Cleaning") return Icons.cleaning_services;
    if (name == "Heating") return Icons.fireplace;
    return Icons.work;
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);
    return Scaffold(
      appBar: AppBar(title: Text(lang.allServices)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: lang.searchServices,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('service')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final services = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = data['name']?.toString() ?? '';
                  return name.toLowerCase().contains(searchQuery);
                }).toList();

                if (services.isEmpty) {
                  return Center(child: Text(lang.noServicesFound));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final data = services[index].data() as Map<String, dynamic>;
                    final title = data['name']?.toString() ?? '';
                    final isSelected = selectedService == title;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedService = title;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RequestServiceScreen(selectedService: title),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1E88E5)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 5),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: isSelected
                                  ? Colors.white
                                  : Colors.blue.shade100,
                              child: Icon(
                                getServiceIcon(title),
                                color: isSelected
                                    ? const Color(0xFF1E88E5)
                                    : Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              lang.translateService(title),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
