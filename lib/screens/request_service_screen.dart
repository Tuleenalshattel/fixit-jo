import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class RequestServiceScreen extends StatefulWidget {
  const RequestServiceScreen({super.key});

  @override
  State<RequestServiceScreen> createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  String _selectedService = 'Plumbing';
  final TextEditingController _descriptionController = TextEditingController();
  List<String> _images = [];

  final List<Map<String, dynamic>> _services = [
    {'name': 'Plumbing', 'icon': Icons.plumbing},
    {'name': 'Electrical', 'icon': Icons.electrical_services},
    {'name': 'Carpentry', 'icon': Icons.handyman},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services},
    {'name': 'AC Repair', 'icon': Icons.ac_unit},
  ];

  LatLng _location = const LatLng(31.9554, 35.9454);
  final MapController _mapController = MapController();
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) return;
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();

    debugPrint('LAT: ${position.latitude}, LNG: ${position.longitude}');

    final newLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      _location = newLocation;
    });

    _mapController.move(newLocation, 15);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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
          'Request Service',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Service
            const Text(
              'Select Service',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _services.map((service) {
                  final isSelected = service['name'] == _selectedService;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedService = service['name']),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1565C0)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              service['icon'],
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1565C0),
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            service['name'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? const Color(0xFF1565C0)
                                  : Colors.black54,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:
                      'Briefly describe the issue (e.g., leaky kitchen sink faucet)...',
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Edit Location',
                    style: TextStyle(color: Color(0xFF1565C0)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _location,
                    initialZoom: 15,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.fixit_jo',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _location,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lat: ${_location.latitude.toStringAsFixed(4)} , Lng:${_location.longitude.toStringAsFixed(4)}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.grey, size: 16),
                SizedBox(width: 4),
              ],
            ),

            const SizedBox(height: 24),

            // Upload Photos
            const Text(
              'Upload Photos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.blue.shade100,
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F0FB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF1565C0),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Attach images of the issue',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Maximum 5 photos (JPEG, PNG)',
                      style: TextStyle(color: Colors.black45, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not logged in')),
                    );
                    return;
                  }

                  final userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .get();

                  final userData = userDoc.data();
                  final customerName = userData?['name'] ?? 'Customer';

                  if (_descriptionController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter description')),
                    );
                    return;
                  }

                  try {
                    final nearestTechnicianId = await findNearestTechnician();

                    if (nearestTechnicianId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No available technician found'),
                        ),
                      );
                      return;
                    }
                    await FirebaseFirestore.instance
                        .collection('service_requests')
                        .add({
                          'customerId': user.uid,
                          'customerName': customerName,
                          'technicianId': nearestTechnicianId,
                          'category': _selectedService,
                          'description': _descriptionController.text.trim(),
                          'status': 'pending',
                          'latitude': _location.latitude,
                          'longitude': _location.longitude,
                          'createdAt': FieldValue.serverTimestamp(),
                        });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Request submitted successfully'),
                      ),
                    );

                    _descriptionController.clear();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: const Center(
                    child: Text(
                      'Submit Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman),
            label: 'Requests',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Future<String?> findNearestTechnician() async {
    final techniciansSnapshot = await FirebaseFirestore.instance
        .collection('technicians')
        .where('available', isEqualTo: true)
        .get();

    final Distance distance = Distance();

    String? nearestTechnicianId;
    double? nearestDistance;

    for (var doc in techniciansSnapshot.docs) {
      final data = doc.data();

      final List specializations = data['specializations'] ?? [];

      if (!specializations.contains(_selectedService)) continue;

      final double? techLat = (data['latitude'] as num?)?.toDouble();
      final double? techLng = (data['longitude'] as num?)?.toDouble();

      if (techLat == null || techLng == null) continue;

      final double currentDistance = distance.as(
        LengthUnit.Kilometer,
        _location,
        LatLng(techLat, techLng),
      );

      if (nearestDistance == null || currentDistance < nearestDistance) {
        nearestDistance = currentDistance;
        nearestTechnicianId = doc.id;
      }
    }

    return nearestTechnicianId;
  }
}
