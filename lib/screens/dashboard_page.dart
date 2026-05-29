import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/app_language.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final lang = AppLanguage();
    return Scaffold(
      backgroundColor: const Color(0xffF3EFEF),

      appBar: AppBar(
        backgroundColor: const Color(0xffF3EFEF),
        elevation: 0,
        leadingWidth: 230,
        leading: Row(
          children: [
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                setState(() {
                  lang.toggleLanguage();
                });
              },
              icon: const Icon(Icons.language, color: Colors.black87),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text(lang.login, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        titleSpacing: 0,
        title: const Row(
          children: [
            Text(
              'FixIt Jo',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 26,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.handyman, color: Color(0xFF1E88E5), size: 22),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // HERO SECTION
              Container(
                height: 560,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  image: const DecorationImage(
                    image: AssetImage('images/repair_bg.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.65),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Text(
                        lang.heroTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          height: 1.1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 38),

              _infoCard(
                title: lang.whyChooseTitle,
                description: lang.whyChooseDesc,
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        lang.completeServicesTitle,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      lang.completeServicesDesc,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _serviceItem(lang.service1),
                    const SizedBox(height: 18),
                    _serviceItem(lang.service2),
                    const SizedBox(height: 18),
                    _serviceItem(lang.service3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: Color(0xFF1E88E5)),
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 16,
                            color: Color(0xFF1E88E5),
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(child: Text(lang.service4)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  'images/Electrician.jpeg',
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 30),

              _featureCard(
                title: lang.service5,
                description: lang.feature1Desc,
                icon: Icons.engineering,
                cardColor: const Color(0xffDDEAF0),
              ),

              const SizedBox(height: 24),

              _featureCard(
                title: lang.feature2Title,
                description: lang.feature2Desc,
                icon: Icons.manage_accounts,
                cardColor: const Color(0xffE8E4E4),
              ),

              const SizedBox(height: 50),

              Text(
                lang.team,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 18),

              Text(
                "${lang.Amneh} • ${lang.Tuleen} • ${lang.Noor}",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 28, bottom: 50),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Fix It Jo',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.handyman, color: Color(0xFF1E88E5)),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(lang.footerHome),
                        Text(lang.footerServices),
                        Text(lang.footerHowItWorks),
                        Text(lang.footerContact),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      lang.footerRights,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // widgets helpers
  Widget _infoCard({required String title, required String description}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: const Color(0xffF2EFEF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              height: 1.8,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceItem(String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            border: Border.fromBorderSide(BorderSide(color: Color(0xFF1E88E5))),
          ),
          child: const Icon(Icons.check, size: 16, color: Color(0xFF1E88E5)),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _featureCard({
    required String title,
    required String description,
    required IconData icon,
    required Color cardColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white,
            child: Icon(icon, size: 34, color: const Color(0xFF1E88E5)),
          ),
        ],
      ),
    );
  }
}
