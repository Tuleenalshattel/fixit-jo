import 'package:fixitjo_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import 'package:fixitjo_app/services/app_language.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool isArabic = false;

  /// LOGOUT FUNCTION
  void logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: [
                    const SizedBox(width: 15),

                    Text(
                      lang.adminSettings,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff156D8A),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// PROFILE CARD
                Container(
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),

                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 42,
                        backgroundImage: AssetImage('images/admin.png'),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "FixIt Jo Admin",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              FirebaseAuth.instance.currentUser?.phoneNumber ??
                                  lang.noPhone,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),

                              decoration: BoxDecoration(
                                color: const Color(0xffCBEAFE),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Text(
                                lang.superAdmin,
                                style: TextStyle(
                                  color: Color(0xff156D8A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                /// ACCOUNT SETTINGS
                sectionTitle(lang.accountSettings),

                const SizedBox(height: 15),

                settingsContainer(
                  children: [
                    settingTile(
                      icon: Icons.person_outline,
                      title: lang.accountInformation,
                    ),

                    settingTile(
                      icon: Icons.lock_outline,
                      title: lang.securityAndPassword,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// PREFERENCES
                sectionTitle(lang.preferences),

                const SizedBox(height: 15),

                settingsContainer(
                  children: [
                    /// NOTIFICATIONS
                    Row(
                      children: [
                        circleIcon(Icons.notifications_none),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Text(
                            lang.notifications,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        Switch(
                          value: notificationsEnabled,
                          activeColor: const Color(0xff156D8A),

                          onChanged: (value) {
                            setState(() {
                              notificationsEnabled = value;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  value
                                      ? lang.notificationsEnabled
                                      : lang.notificationsDisabled,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// LANGUAGE (STATIC - NO ACTION)
                    Row(
                      children: [
                        circleIcon(Icons.language),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Text(
                            lang.language,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        Text(
                          "English",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// SUPPORT
                sectionTitle(lang.supportLegal),

                const SizedBox(height: 15),

                settingsContainer(
                  children: [
                    settingTile(
                      icon: Icons.help_outline,
                      title: lang.helpSupport,
                    ),

                    settingTile(icon: Icons.info_outline, title: lang.aboutApp),
                  ],
                ),

                const SizedBox(height: 35),

                /// LOG OUT BUTTON
                GestureDetector(
                  onTap: logout,

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),

                    decoration: BoxDecoration(
                      color: const Color(0xffFFDCDC),
                      borderRadius: BorderRadius.circular(22),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.red),

                        SizedBox(width: 10),

                        Text(
                          lang.logOut,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Text(
                    " ",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// SECTION TITLE
  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// SETTINGS CONTAINER
  Widget settingsContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(children: children),
    );
  }

  /// SETTING TILE
  Widget settingTile({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),

      child: Row(
        children: [
          circleIcon(icon),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// ICON STYLE
  Widget circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Color(0xffEAF7FC),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Color(0xff156D8A), size: 28),
    );
  }
}
