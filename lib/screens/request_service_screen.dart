import 'dart:io';
import 'package:fixitjo_app/screens/chatbot_screen.dart';
import 'package:fixitjo_app/screens/profile_customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:fixitjo_app/services/app_language.dart';

class RequestServiceScreen extends StatefulWidget {
  final String? selectedService;

  const RequestServiceScreen({super.key, this.selectedService});

  @override
  State<RequestServiceScreen> createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  int _currentIndex = 1;
  String _selectedService = 'Plumbing';
  bool _isSubmitting = false;

  final TextEditingController _descriptionController = TextEditingController();
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  LatLng _location = const LatLng(31.9554, 35.9454);
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();

    if (widget.selectedService != null) {
      _selectedService = widget.selectedService!;
    }

    _getCurrentLocation();
  }

  IconData getServiceIcon(String name) {
    if (name == "Plumbing") return Icons.plumbing;
    if (name == "Electrical") return Icons.electrical_services;
    if (name == "Carpentry") return Icons.handyman;
    if (name == "Cleaning") return Icons.cleaning_services;
    if (name == "AC Repair") return Icons.ac_unit;
    if (name == "Painting") return Icons.format_paint;
    if (name == "Blacksmith") return Icons.hardware;
    if (name == "Heating") return Icons.fireplace;
    if (name == "Furniture") return Icons.chair;

    return Icons.work;
  }

  String translateService(String service, AppLanguage lang) {
    switch (service) {
      case 'Plumbing':
        return lang.plumbing;

      case 'Electrical':
        return lang.electrical;

      case 'Carpentry':
        return lang.carpentry;

      case 'Cleaning':
        return lang.cleaning;

      case 'AC Repair':
        return lang.acRepair;

      case 'Painting':
        return lang.painting;

      case 'Blacksmith':
        return lang.blacksmith;

      case 'Heating':
        return lang.heating;

      case 'Furniture':
        return lang.furniture;

      default:
        return service;
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) return;
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    final newLocation = LatLng(position.latitude, position.longitude);

    setState(() => _location = newLocation);
    _mapController.move(newLocation, 15);
  }

  Future<String?> findNearestTechnician({
    List<String> excludedIds = const [],
  }) async {
    final techniciansSnapshot = await FirebaseFirestore.instance
        .collection('technicians')
        .where('available', isEqualTo: true)
        .where('isVerified', isEqualTo: true)
        .get();

    final Distance distance = Distance();
    String? nearestTechnicianId;
    double? nearestDistance;

    for (var doc in techniciansSnapshot.docs) {
      if (excludedIds.contains(doc.id)) continue;

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

  Future<List<String>> _uploadImages(String requestId) async {
    List<String> imageUrls = [];

    for (int i = 0; i < _images.length; i++) {
      final file = File(_images[i].path);

      final ref = FirebaseStorage.instance.ref().child(
        'service_requests/$requestId/image_$i.jpg',
      );

      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      imageUrls.add(url);
    }

    return imageUrls;
  }

  Future<void> _pickImage() async {
    final lang = Provider.of<AppLanguage>(context, listen: false);

    if (_images.length >= 5) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(lang.takephoto),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(lang.choosefromgallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() => _images.add(image));

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(lang.imageAdded)));
    }
  }

  Future<void> _submitRequest() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    final lang = Provider.of<AppLanguage>(context, listen: false);

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(lang.userNotLoggedIn)));
      setState(() => _isSubmitting = false);
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(lang.pleaseEnterDescription)));
      setState(() => _isSubmitting = false);
      return;
    }
    final existingRequests = await FirebaseFirestore.instance
        .collection('service_requests')
        .where('customerId', isEqualTo: user.uid)
        .where('status', whereIn: ['pending', 'accepted', 'arrived'])
        .get();

    if (existingRequests.docs.isNotEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(lang.activeRequestExists)));
      setState(() => _isSubmitting = false);
      return;
    }

    final nearestTechnicianId = await findNearestTechnician();

    if (nearestTechnicianId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(lang.noTechnicianFound)));
      setState(() => _isSubmitting = false);
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final customerName = userDoc.data()?['name'] ?? lang.customer;
      final customerPhone = userDoc.data()?['phone'] ?? '';

      final docRef = await FirebaseFirestore.instance
          .collection('service_requests')
          .add({
            'customerId': user.uid,
            'customerName': customerName,
            'customerPhone': customerPhone,
            'technicianId': nearestTechnicianId,
            'category': _selectedService,
            'description': _descriptionController.text.trim(),
            'status': 'pending',
            'latitude': _location.latitude,
            'longitude': _location.longitude,
            'declinedBy': [],
            'imageUrls': [],
            'createdAt': FieldValue.serverTimestamp(),
          });
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': nearestTechnicianId,
        'title': lang.newServiceRequest,
        'body': lang.newServiceRequestBody(customerName, _selectedService),
        'type': 'new_request',
        'requestId': docRef.id,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (_images.isNotEmpty) {
        final imageUrls = await _uploadImages(docRef.id);
        await docRef.update({'imageUrls': imageUrls});
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(lang.requestSubmitted)));

      _descriptionController.clear();
      setState(() => _isSubmitting = false);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(lang.errorMessage(e.toString()))));
      setState(() => _isSubmitting = false);
    }
  }

  Widget servicesFromFirebase() {
    final lang = Provider.of<AppLanguage>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('service').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final services = snapshot.data!.docs;

        if (services.isEmpty) {
          return Text(lang.Noservicesavailable);
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: services.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final serviceName = data['name']?.toString() ?? '';

              final isSelected = serviceName == _selectedService;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedService = serviceName;
                  });
                },
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
                          getServiceIcon(serviceName),
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1565C0),
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        translateService(serviceName, lang),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          lang.requestService,
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
            Text(
              lang.selectService,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            servicesFromFirebase(),

            const SizedBox(height: 24),

            Text(
              lang.description,
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
                decoration: InputDecoration(
                  hintText: lang.describeIssueHint,
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang.location,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _getCurrentLocation,
                  child: Text(
                    lang.editLocation,
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
              'Lat: ${_location.latitude.toStringAsFixed(4)}, Lng: ${_location.longitude.toStringAsFixed(4)}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),

            const SizedBox(height: 24),

            Text(
              lang.uploadPhotos,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (_images.isNotEmpty) ...[
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(File(_images[index].path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 8,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _images.removeAt(index)),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],

            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100, width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE3F0FB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF1565C0),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lang.attachImages,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _images.isEmpty
                          ? lang.cameraOrGallery
                          : lang.photosAdded(_images.length),
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

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
                onPressed: _isSubmitting ? null : _submitRequest,
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Center(
                    child: Text(
                      _isSubmitting ? lang.submitting : lang.submitRequest,

                      style: const TextStyle(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1565C0),
        shape: const CircleBorder(),
        child: const Icon(Icons.chat, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);

          if (index == 0) Navigator.pop(context);

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(
                  name: "User",
                  phone: "",
                  userType: "Customer",
                ),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: lang.home),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: lang.request),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: lang.profile,
          ),
        ],
      ),
    );
  }
}
