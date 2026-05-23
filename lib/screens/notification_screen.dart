import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationScreen extends StatelessWidget {
  final String? userId;

  const NotificationScreen({super.key, this.userId});

  static const primary = Color(0xFF1565C0);

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'request_accepted':
        return Icons.check_circle;
      case 'technician_arrived':
        return Icons.directions_walk;
      case 'service_completed':
        return Icons.done_all;
      case 'new_technician':
        return Icons.engineering;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String? type) {
    switch (type) {
      case 'request_accepted':
        return Colors.green;
      case 'technician_arrived':
        return Colors.orange;
      case 'service_completed':
        return Colors.blue;
      case 'new_technician':
        return Colors.purple;
      default:
        return primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final targetUserId = userId ?? currentUser?.uid;

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
        actions: [
          TextButton(
            onPressed: targetUserId == null
                ? null
                : () async {
                    final batch = FirebaseFirestore.instance.batch();

                    final docs = await FirebaseFirestore.instance
                        .collection('notifications')
                        .where('userId', isEqualTo: targetUserId)
                        .where('isRead', isEqualTo: false)
                        .get();

                    for (var doc in docs.docs) {
                      batch.update(doc.reference, {'isRead': true});
                    }

                    await batch.commit();
                  },
            child: const Text(
              'Mark all as read',
              style: TextStyle(color: primary),
            ),
          ),
        ],
      ),
      body: targetUserId == null
          ? const Center(child: Text('User not logged in'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userId', isEqualTo: targetUserId)
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

                final notifications = snapshot.data!.docs.toList();

                notifications.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;

                  final aTime = aData['createdAt'];
                  final bTime = bData['createdAt'];

                  if (aTime is! Timestamp || bTime is! Timestamp) return 0;

                  return bTime.compareTo(aTime);
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final doc = notifications[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final title = data['title']?.toString() ?? '';
                    final body = data['body']?.toString() ?? '';
                    final isRead = data['isRead'] == true;
                    final type = data['type']?.toString();
                    final createdAt = data['createdAt'] is Timestamp
                        ? data['createdAt'] as Timestamp
                        : null;

                    return GestureDetector(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('notifications')
                            .doc(doc.id)
                            .update({'isRead': true});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isRead ? Colors.white : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: _getIconColor(
                              type,
                            ).withOpacity(0.15),
                            child: Icon(
                              _getIcon(type),
                              color: _getIconColor(type),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                body,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(createdAt),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: isRead
                              ? null
                              : const Icon(
                                  Icons.circle,
                                  color: primary,
                                  size: 10,
                                ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
