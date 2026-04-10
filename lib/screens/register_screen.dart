import 'package:flutter/material.dart';
import 'otp_screen.dart';

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

  Widget buildUserCard({
    required String text,
    required IconData icon,
    required UserType type,
  }) {

    bool selected = _selectedUserType == type;

    Color color =
        type == UserType.customer ? Colors.blue : Colors.green;

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
              Icon(
                icon,
                size: 30,
                color: selected ? color : Colors.grey,
              ),
              const SizedBox(height: 6),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? color : Colors.black87,
                ),
              )
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                      color: Color(0xff4da3ff),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.build,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    "FixItJo",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 25),

              const Text(
                "Create an Account",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Join the premium home maintenance network",
                style: TextStyle(
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "I AM A...",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [

                  buildUserCard(
                    text: "Customer",
                    icon: Icons.person,
                    type: UserType.customer,
                  ),

                  const SizedBox(width: 12),

                  buildUserCard(
                    text: "Technician",
                    icon: Icons.handyman,
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
                hint: "John Doe",
                icon: Icons.person,
                controller: _nameController,
              ),

              const SizedBox(height: 18),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Phone Number"),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [

                    const SizedBox(width: 6),
                    const Text("+962"),
                    const SizedBox(width: 10),
                    const Icon(Icons.phone, color: Colors.grey),
                    const SizedBox(width: 10),

                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "7X XXXX XXXX",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpScreen(
                        userType: _selectedUserType,
                        name: _nameController.text,
                        phone: _phoneController.text,
                        profileImage: null,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 27, 128, 237),
                        Color(0xff5bc0ff),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Already have an account? "),
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Color.fromARGB(255, 62, 140, 223),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
