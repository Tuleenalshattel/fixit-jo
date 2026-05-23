import 'package:flutter/material.dart';
import 'otp_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { customer, technician }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  UserType _selectedUserType = UserType.customer;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? profileImage;
  bool isLoading = false;

  double experience = 8;

  String selectedSpecialization = '';
  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  Widget buildUserCard({
    required String text,
    required IconData icon,
    required UserType type,
  }) {
    bool selected = _selectedUserType == type;

    Color color = type == UserType.customer ? Colors.blue : Colors.teal;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedUserType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(.15) : Colors.grey[100],
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: selected ? color : Colors.grey),
              const SizedBox(height: 6),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? color : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.grey),
          hintText: hint,
        ),
      ),
    );
  }

  IconData getServiceIcon(String name) {
    if (name == "Plumbing") return Icons.plumbing;
    if (name == "Electrical") return Icons.electrical_services;
    if (name == "Carpentry") return Icons.handyman;
    if (name == "Cleaning") return Icons.cleaning_services;
    if (name == "AC Repair") return Icons.ac_unit;
    if (name == "Painting") return Icons.format_paint;
    if (name == "Blacksmith") return Icons.hardware;
    if (name == "Heating") return Icons.fireplace;
    if (name == "furniture") return Icons.chair;
    return Icons.work;
  }

  Widget buildSpecialization(String text, IconData icon) {
    bool selected = selectedSpecialization == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSpecialization = text;
        });
      },
      child: Container(
        width: 160,
        height: 100,
        decoration: BoxDecoration(
          color: selected ? Colors.blue.withOpacity(.2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),

            const SizedBox(height: 8),

            Text(text),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 10),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    Expanded(
                      child: Center(
                        child: _selectedUserType == UserType.customer
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.build, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    "FixIt Jo",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                "Digital Concierge",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(width: 40),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 120),
                  height: 2,
                  color: Colors.grey.shade300,
                ),

                const SizedBox(height: 20),

                Container(
                  height: 65,
                  width: 65,
                  decoration: const BoxDecoration(
                    color: Color(0xff3fa9f5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.build, color: Colors.white),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Create an Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Join FixIt Jo and start growing your business.",
                  style: TextStyle(color: Colors.black54),
                ),

                if (_selectedUserType == UserType.technician) ...[
                  const SizedBox(height: 25),

                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: profileImage != null
                          ? FileImage(profileImage!)
                          : null,
                      child: profileImage == null
                          ? const Icon(Icons.camera_alt, size: 30)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Profile Picture",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const Text(
                    "Recommended: Clear face photo in daylight.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],

                const SizedBox(height: 25),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "I am a...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    buildUserCard(
                      text: "Customer",
                      icon: Icons.person_outline,
                      type: UserType.customer,
                    ),

                    const SizedBox(width: 12),

                    buildUserCard(
                      text: "Technician",
                      icon: Icons.engineering,
                      type: UserType.technician,
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Full Name"),
                ),

                const SizedBox(height: 8),

                buildTextField(
                  hint: "Omar Hassan",
                  icon: Icons.person,
                  controller: _nameController,
                ),

                const SizedBox(height: 18),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Phone Number"),
                ),

                const SizedBox(height: 8),

                buildTextField(
                  hint: "+962 7X XXX XXXX",
                  icon: Icons.phone,
                  controller: _phoneController,
                ),

                if (_selectedUserType == UserType.technician) ...[
                  const SizedBox(height: 25),

                  Row(
                    children: const [
                      Text(
                        "Specialization",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Spacer(),

                      Text(
                        "SELECT MULTIPLE",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('service')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text("No services available");
                      }

                      final services = snapshot.data!.docs;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: services.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final serviceName = data['name']?.toString() ?? '';

                          return buildSpecialization(
                            serviceName,
                            getServiceIcon(serviceName),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      const Text(
                        "Years of Experience",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff1f8fa8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${experience.round()}+",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  Slider(
                    value: experience,
                    min: 1,
                    max: 30,
                    onChanged: (value) {
                      setState(() {
                        experience = value;
                      });
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("1 YEAR"),
                      Text("15 YEARS"),
                      Text("30 YEARS"),
                    ],
                  ),
                ],

                const SizedBox(height: 30),

                GestureDetector(
                  onTap: isLoading
                      ? null
                      : () async {
                          if (_nameController.text.isEmpty ||
                              _phoneController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all fields"),
                              ),
                            );
                            return;
                          }
                          String rawPhone = _phoneController.text.trim();
                          rawPhone = rawPhone.replaceAll(' ', '');

                          if (rawPhone.startsWith('+962')) {
                            rawPhone = rawPhone.substring(4);
                          } else if (rawPhone.startsWith('0')) {
                            rawPhone = rawPhone.substring(1);
                          }
                          final phone = "+962${_phoneController.text.trim()}";

                          setState(() {
                            isLoading = true;
                          });

                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: phone,
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: ${e.message}")),
                              );
                            },
                            codeSent:
                                (String verificationId, int? resendToken) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                        verificationId: verificationId,
                                        phoneNumber: phone,
                                        name: _nameController.text.trim(),
                                        role:
                                            _selectedUserType ==
                                                UserType.technician
                                            ? 'technician'
                                            : 'customer',
                                        specializations: [
                                          selectedSpecialization,
                                        ],
                                        experience: experience.round(),
                                        profileImage: profileImage,
                                      ),
                                    ),
                                  );
                                },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 255, 255),
                          Color.fromARGB(255, 235, 235, 235),
                        ],
                      ),
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFF2F80ED),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2F80ED),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                if (_selectedUserType == UserType.technician) ...[
                  const SizedBox(height: 25),

                  const Text(
                    "BY CLICKING REGISTER, YOU AGREE TO OUR\n"
                    "PROFESSIONAL TERMS OF SERVICE AND\n"
                    "IDENTITY VERIFICATION POLICIES.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
