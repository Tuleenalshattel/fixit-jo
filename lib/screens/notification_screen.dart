import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> _recentNotifications = [
    {
      'title': 'New Request',
      'body': 'A customer near you needs plumbing help',
      'time': '2 min ago',
      'type': 'request',
      'isNew': true,
    },
    {
      'title': 'New Request',
      'body': 'Sarah Mitchell needs AC repair — 1.2 miles away',
      'time': '15 min ago',
      'type': 'request',
      'isNew': true,
    },
  ];

  final List<Map<String, dynamic>> _earlierNotifications = [
    {
      'title': 'New Rating',
      'body': 'You received a 5 star rating from John',
      'time': '2h ago',
      'type': 'rating',
      'isNew': false,
    },
    {
      'title': 'Payment Received',
      'body': 'You received payment for your last service',
      'time': '5h ago',
      'type': 'payment',
      'isNew': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _listenToForegroundNotifications();
  }

  void _listenToForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          _recentNotifications.insert(0, {
            'title': message.notification!.title ?? 'Notification',
            'body': message.notification!.body ?? '',
            'time': 'Just now',
            'type': message.data['type'] ?? 'request',
            'isNew': true,
          });
        });
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _recentNotifications) {
        n['isNew'] = false;
      }
    });
  }

  int get _newCount =>
      _recentNotifications.where((n) => n['isNew'] == true).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1565C0), width: 1.5),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 14,
              color: Color(0xFF1565C0),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              'Mark all as read',
              style: TextStyle(color: Color(0xFF1565C0), fontSize: 13),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Recent Activity Section
          _buildSectionHeader('Recent Activity', _newCount),
          const SizedBox(height: 12),
          ..._recentNotifications
              .map((n) => _buildNotificationCard(n))
              .toList(),

          const SizedBox(height: 24),

          // Earlier Today Section
          _buildSectionHeader('Earlier Today', 0),
          const SizedBox(height: 12),
          ..._earlierNotifications
              .map((n) => _buildNotificationCard(n))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int newCount) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        if (newCount > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$newCount NEW',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(notification['type']),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      notification['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      notification['time'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification['body'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                if (notification['type'] == 'request' &&
                    notification['isNew'] == true) ...[
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 7,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {},
                    child: const Text(
                      'View Job',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData icon;
    Color bgColor;
    Color iconColor;

    switch (type) {
      case 'request':
        icon = Icons.build;
        bgColor = const Color(0xFFE3F0FB);
        iconColor = const Color(0xFF1565C0);
        break;
      case 'rating':
        icon = Icons.star;
        bgColor = const Color(0xFFFFF8E1);
        iconColor = const Color(0xFFFFA000);
        break;
      case 'payment':
        icon = Icons.check_circle;
        bgColor = const Color(0xFFE8F0FE);
        iconColor = const Color(0xFF3949AB);
        break;
      default:
        icon = Icons.notifications;
        bgColor = Colors.grey.shade100;
        iconColor = Colors.grey;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}
