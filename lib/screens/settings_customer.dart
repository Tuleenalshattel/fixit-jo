import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import 'package:fixitjo_app/services/app_language.dart';

//this pag is for technican
class SettingsScreen extends StatelessWidget {
  final String name;
  final String phone;

  const SettingsScreen({super.key, required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F7),

      body: SafeArea(
        child: Column(
          children: [
            ///  HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Text(
                      lang.settings,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// PROFILE
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 3),
                  ),
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage("images/user.png"),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// الاسم من Firebase
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            /// الرقم من Firebase
            Text(phone, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 25),

            /// SETTINGS LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  buildItem(Icons.person, lang.accountInformation),
                  buildItem(Icons.lock, lang.changePassword),

                  ///  Notifications
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFFE6F2F8),
                          child: Icon(
                            Icons.notifications,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(child: Text(lang.notifications)),
                        Switch(value: true, onChanged: (value) {}),
                      ],
                    ),
                  ),

                  buildItem(
                    Icons.language,
                    lang.languageSelection,
                    trailing: "English",
                  ),
                  buildItem(Icons.help, lang.helpSupport),
                  buildItem(Icons.info, lang.aboutApp),

                  const SizedBox(height: 20),

                  ///  LOGOUT (مهم جدًا)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut(); // 🔥 هذا المهم

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      lang.logout,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      "${lang.version} 2.4.1",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(IconData icon, String title, {String? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 15),

          Expanded(child: Text(title)),

          if (trailing != null)
            Text(trailing, style: const TextStyle(color: Colors.blue)),

          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
