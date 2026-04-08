import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

                const SizedBox(height: 20),

                
                Row(
                  children: const [
                    Icon(Icons.build, color: Color(0xFF2F80ED)),
                    SizedBox(width: 8),
                    Text(
                      "FixItJo",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Color(0xFFEAF2FF),  
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.handyman, 
                    size: 45,
                    color: Color(0xFF2F80ED),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Enter your mobile number to start fixing.",
                  style: TextStyle(
                    color: Color(0xFF4F4F4F), 
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "MOBILE NUMBER",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87, 
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [

                            const Text(
                              "+962",
                              style: TextStyle(
                                color: Colors.black, 
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "7X XXX XXXX",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF9E9E9E),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2F80ED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Send OTP",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "SECURE LOGIN",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Color(0xFF2F80ED),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "By continuing, you agree to FixIt Jo's Terms of Service and Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
