import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:fixitjo_app/services/app_language.dart';

class TrackingScreen extends StatefulWidget {
  final String requestId;
  final bool isTechnician;

  const TrackingScreen({
    super.key,
    required this.requestId,
    required this.isTechnician,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final MapController _mapController = MapController();
  LatLng? _myLocation;
  LatLng? _otherLocation;
  String _otherName = '';
  String _status = '';
  Timer? _locationTimer;
  bool _isLoading = true;

  static const Color primary = Color(0xFF0C6A85);

  @override
  void initState() {
    super.initState();
    _getMyLocation();
    _listenToRequest();

    if (widget.isTechnician) {
      _locationTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        _updateMyLocationToFirestore();
      });
    }
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<void> _getMyLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();

    setState(() {
      _myLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });

    if (widget.isTechnician) {
      _updateMyLocationToFirestore();
    }
  }

  Future<void> _updateMyLocationToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final position = await Geolocator.getCurrentPosition();

    setState(() {
      _myLocation = LatLng(position.latitude, position.longitude);
    });

    await FirebaseFirestore.instance
        .collection('technicians')
        .doc(user.uid)
        .update({
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
  }

  //Observe Pattern
  void _listenToRequest() {
    FirebaseFirestore.instance
        .collection('service_requests')
        .doc(widget.requestId)
        .snapshots()
        .listen((doc) async {
          if (!doc.exists) return;

          final data = doc.data()!;

          setState(() {
            _status = data['status'] ?? '';
          });

          if (widget.isTechnician) {
            final double lat = (data['latitude'] as num?)?.toDouble() ?? 0.0;
            final double lng = (data['longitude'] as num?)?.toDouble() ?? 0.0;
            final String customerName = data['customerName'] ?? '';

            setState(() {
              _otherLocation = LatLng(lat, lng);
              _otherName = customerName;
            });
          } else {
            final String techId = data['technicianId'] ?? '';
            if (techId.isEmpty) return;

            final techDoc = await FirebaseFirestore.instance
                .collection('technicians')
                .doc(techId)
                .get();

            if (!techDoc.exists) return;

            final techData = techDoc.data()!;

            final double lat =
                (techData['latitude'] as num?)?.toDouble() ?? 0.0;
            final double lng =
                (techData['longitude'] as num?)?.toDouble() ?? 0.0;

            setState(() {
              _otherLocation = LatLng(lat, lng);
              _otherName = techData['name'] ?? '';
            });
          }
        });
  }

  String _getStatusText(AppLanguage lang) {
    switch (_status) {
      case 'accepted':
        return widget.isTechnician
            ? lang.headToCustomer
            : lang.technicianOnTheWay;
      case 'arrived':
        return widget.isTechnician
            ? lang.youHaveArrived
            : lang.technicianArrived;
      case 'completed':
        return lang.jobCompleted;
      default:
        return lang.tracking;
    }
  }

  Color _getStatusColor() {
    switch (_status) {
      case 'accepted':
        return Colors.blue;
      case 'arrived':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void showReportCustomerDialog({
    required String requestId,
    required String customerId,
    required String customerName,
  }) {
    final lang = Provider.of<AppLanguage>(context, listen: false);

    String selectedType = "Unpaid Service";
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(lang.reportCustomer),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                items: [
                  DropdownMenuItem(
                    value: "Unpaid Service",
                    child: Text(lang.unpaidService),
                  ),
                  DropdownMenuItem(
                    value: "Abusive Behavior",
                    child: Text(lang.abusiveBehavior),
                  ),
                  DropdownMenuItem(
                    value: "Fake Request",
                    child: Text(lang.fakeRequest),
                  ),
                  DropdownMenuItem(value: "Other", child: Text(lang.other)),
                ],
                onChanged: (value) {
                  selectedType = value!;
                },
                decoration: InputDecoration(labelText: lang.reportType),
              ),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(labelText: lang.reason),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(lang.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final techId = FirebaseAuth.instance.currentUser!.uid;

                await FirebaseFirestore.instance
                    .collection('customer_reports')
                    .add({
                      'customerId': customerId,
                      'customerName': customerName,
                      'technicianId': techId,
                      'requestId': requestId,
                      'reportType': selectedType,
                      'reason': reasonController.text.trim(),
                      'status': 'pending',
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                if (!context.mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(lang.reportSubmitted)));
              },
              child: Text(lang.submit),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);

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
              border: Border.all(color: primary, width: 1.5),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 14,
              color: primary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isTechnician ? lang.customerLocation : lang.trackTechnician,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  color: _getStatusColor().withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: _getStatusColor(), size: 12),
                      const SizedBox(width: 8),
                      Text(
                        _getStatusText(lang),
                        style: TextStyle(
                          color: _getStatusColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter:
                          _myLocation ?? const LatLng(31.9554, 35.9454),
                      initialZoom: 14,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.fixit_jo',
                      ),
                      MarkerLayer(
                        markers: [
                          if (_myLocation != null)
                            Marker(
                              point: _myLocation!,
                              width: 50,
                              height: 50,
                              child: const Icon(
                                Icons.my_location,
                                color: primary,
                                size: 36,
                              ),
                            ),
                          if (_otherLocation != null)
                            Marker(
                              point: _otherLocation!,
                              width: 60,
                              height: 60,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      _otherName.isEmpty
                                          ? lang.loading
                                          : _otherName,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    widget.isTechnician
                                        ? Icons.person_pin_circle
                                        : Icons.engineering,
                                    color: Colors.orange,
                                    size: 32,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F0FB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              widget.isTechnician
                                  ? Icons.person
                                  : Icons.engineering,
                              color: primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _otherName.isEmpty
                                      ? lang.loading
                                      : _otherName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  widget.isTechnician
                                      ? lang.customer
                                      : lang.technician,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_otherLocation != null) {
                                _mapController.move(_otherLocation!, 15);
                              }
                            },
                            icon: const Icon(
                              Icons.center_focus_strong,
                              color: primary,
                            ),
                          ),
                        ],
                      ),

                      if (widget.isTechnician) ...[
                        const SizedBox(height: 12),

                        if (_status == 'accepted')
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('service_requests')
                                    .doc(widget.requestId)
                                    .update({'status': 'arrived'});
                              },
                              child: Text(
                                lang.iArrived,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),

                        if (_status == 'arrived') ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                final requestDoc = await FirebaseFirestore
                                    .instance
                                    .collection('service_requests')
                                    .doc(widget.requestId)
                                    .get();

                                final requestData = requestDoc.data();
                                if (requestData == null) return;

                                final techId = requestData['technicianId'];
                                final customerId = requestData['customerId'];

                                await FirebaseFirestore.instance
                                    .collection('service_requests')
                                    .doc(widget.requestId)
                                    .update({
                                      'status': 'completed',
                                      'completedAt':
                                          FieldValue.serverTimestamp(),
                                    });

                                if (techId != null) {
                                  final techRef = FirebaseFirestore.instance
                                      .collection('technicians')
                                      .doc(techId);

                                  final techDoc = await techRef.get();

                                  final currentJobs =
                                      (techDoc.data()?['jobsDone'] as num?)
                                          ?.toInt() ??
                                      0;

                                  await techRef.set({
                                    'jobsDone': currentJobs + 1,
                                  }, SetOptions(merge: true));
                                }

                                if (customerId != null) {
                                  await FirebaseFirestore.instance
                                      .collection('notifications')
                                      .add({
                                        'userId': customerId,
                                        'title': lang.serviceCompleted,
                                        'body': lang.serviceCompletedBody,
                                        'type': 'service_completed',
                                        'requestId': widget.requestId,
                                        'isRead': false,
                                        'createdAt':
                                            FieldValue.serverTimestamp(),
                                      });
                                }

                                if (!context.mounted) return;

                                Navigator.pop(context);
                              },
                              child: Text(
                                lang.finishJob,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () async {
                                final requestDoc = await FirebaseFirestore
                                    .instance
                                    .collection('service_requests')
                                    .doc(widget.requestId)
                                    .get();

                                final data = requestDoc.data();
                                if (data == null) return;

                                showReportCustomerDialog(
                                  requestId: widget.requestId,
                                  customerId: data['customerId'] ?? '',
                                  customerName:
                                      data['customerName'] ?? lang.customer,
                                );
                              },
                              child: Text(lang.reportCustomer),
                            ),
                          ),
                        ],
                      ],

                      if (!widget.isTechnician && _status == 'arrived') ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Center(
                            child: Text(
                              lang.technicianArrived,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (!widget.isTechnician && _status == 'completed') ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green),
                          ),
                          child: Center(
                            child: Text(
                              lang.jobCompleted,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
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
}
