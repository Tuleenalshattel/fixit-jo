import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const primary = Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primary),
        title: const Text(
          'Notifications',
          style: TextStyle(color: primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: user == null
          ? const Center(child: Text('User not logged in'))
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('notifications')
                        .where('userId', isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No notifications yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      final notifications = snapshot.data!.docs;

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final doc = notifications[index];
                          final data = doc.data() as Map<String, dynamic>;

                          final title = data['title']?.toString() ?? '';
                          final body = data['body']?.toString() ?? '';
                          final isRead = data['isRead'] == true;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isRead
                                  ? Colors.white
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFE3F2FD),
                                child: Icon(
                                  Icons.notifications,
                                  color: primary,
                                ),
                              ),
                              title: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(body),
                              trailing: isRead
                                  ? null
                                  : const Icon(
                                      Icons.circle,
                                      color: primary,
                                      size: 10,
                                    ),
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('notifications')
                                    .doc(doc.id)
                                    .update({'isRead': true});
                              },
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
