import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            final String customerName = data['customerName'] ?? 'Customer';

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
              _otherName = techData['name'] ?? 'Technician';
            });
          }
        });
  }

  String _getStatusText() {
    switch (_status) {
      case 'accepted':
        return widget.isTechnician
            ? 'Head to customer'
            : 'Technician on the way';
      case 'arrived':
        return widget.isTechnician ? 'You have arrived' : 'Technician arrived';
      case 'completed':
        return 'Job Completed ✓';
      default:
        return 'Tracking...';
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
          widget.isTechnician ? 'Customer Location' : 'Track Technician',
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
                // Status Bar
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
                        _getStatusText(),
                        style: TextStyle(
                          color: _getStatusColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Map
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
                                      _otherName,
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

                // Bottom Card
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
                                      ? 'Loading...'
                                      : _otherName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  widget.isTechnician
                                      ? 'Customer'
                                      : 'Technician',
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

                      // أزرار الفني
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
                              child: const Text(
                                'I Arrived',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),

                        if (_status == 'arrived')
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
                                await FirebaseFirestore.instance
                                    .collection('service_requests')
                                    .doc(widget.requestId)
                                    .update({'status': 'completed'});
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Finish Job',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                      ],

                      // للزبون
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
                          child: const Center(
                            child: Text(
                              '🔧 Technician has arrived!',
                              style: TextStyle(
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
                          child: const Center(
                            child: Text(
                              '✅ Job Completed!',
                              style: TextStyle(
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
