import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Technician {
  final String id;
  final String name;
  final String specialty;
  final double lat;
  final double lng;
  final double rating;
  final LatLng location;

  Technician({
    required this.id,
    required this.name,
    required this.specialty,
    required this.lat,
    required this.lng,
    required this.rating,
  }) : location = LatLng(lat, lng);
}

class MapScreen extends StatefulWidget {
  final String? selectedService;
  const MapScreen({super.key, this.selectedService});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  Technician? _nearestTechnician;
  String _selectedService = 'Plumbing';
  bool _isLoading = true;
  bool _requestSent = false;

  final List<String> _services = [
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Cleaning',
    'AC Repair',
  ];

  final List<Technician> _technicians = [
    Technician(
      id: '1',
      name: 'Ahmad Al-Zoubi',
      specialty: 'Plumbing',
      lat: 31.9554,
      lng: 35.9454,
      rating: 4.8,
    ),
    Technician(
      id: '2',
      name: 'Mohammed Haddad',
      specialty: 'Plumbing',
      lat: 31.9620,
      lng: 35.9300,
      rating: 4.5,
    ),
    Technician(
      id: '3',
      name: 'Khalid Mansour',
      specialty: 'Electrical',
      lat: 31.9480,
      lng: 35.9380,
      rating: 4.9,
    ),
    Technician(
      id: '4',
      name: 'Omar Saleh',
      specialty: 'Electrical',
      lat: 31.9700,
      lng: 35.9500,
      rating: 4.3,
    ),
    Technician(
      id: '5',
      name: 'Faris Nasser',
      specialty: 'Carpentry',
      lat: 31.9530,
      lng: 35.9600,
      rating: 4.7,
    ),
    Technician(
      id: '6',
      name: 'Tariq Ibrahim',
      specialty: 'Carpentry',
      lat: 31.9450,
      lng: 35.9250,
      rating: 4.6,
    ),
    Technician(
      id: '7',
      name: 'Samir Qasim',
      specialty: 'Cleaning',
      lat: 31.9580,
      lng: 35.9420,
      rating: 4.4,
    ),
    Technician(
      id: '8',
      name: 'Rami Yousef',
      specialty: 'AC Repair',
      lat: 31.9640,
      lng: 35.9350,
      rating: 4.8,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.selectedService != null) {
      _selectedService = widget.selectedService!;
    }
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // استخدم موقع افتراضي - عمان
        setState(() {
          _userLocation = const LatLng(31.9554, 35.9454);
          _isLoading = false;
        });
        _findNearestTechnician();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _findNearestTechnician();
      _mapController.move(_userLocation!, 14);
    } catch (e) {
      setState(() {
        _userLocation = const LatLng(31.9554, 35.9454);
        _isLoading = false;
      });
      _findNearestTechnician();
    }
  }

  void _findNearestTechnician() {
    if (_userLocation == null) return;

    final filtered = _technicians
        .where((t) => t.specialty == _selectedService)
        .toList();

    if (filtered.isEmpty) return;

    final Distance distance = Distance();
    Technician nearest = filtered.first;
    double minDistance = distance(_userLocation!, nearest.location);

    for (var tech in filtered) {
      double d = distance(_userLocation!, tech.location);
      if (d < minDistance) {
        minDistance = d;
        nearest = tech;
      }
    }

    setState(() {
      _nearestTechnician = nearest;
      _requestSent = false;
    });
  }

  void _sendRequest() {
    setState(() => _requestSent = true);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Request Sent!'),
          ],
        ),
        content: Text(
          'Your request has been sent to ${_nearestTechnician?.name}.\nThey will contact you shortly.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF1565C0))),
          ),
        ],
      ),
    );
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
          'Find Technician',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            )
          : Column(
              children: [
                // Service Filter
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: _services.map((service) {
                        final isSelected = service == _selectedService;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedService = service);
                            _findNearestTechnician();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1565C0)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              service,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black54,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Map
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter:
                          _userLocation ?? const LatLng(31.9554, 35.9454),
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.fixit_jo',
                      ),
                      MarkerLayer(
                        markers: [
                          // موقع الزبون
                          if (_userLocation != null)
                            Marker(
                              point: _userLocation!,
                              width: 50,
                              height: 50,
                              child: const Icon(
                                Icons.my_location,
                                color: Color(0xFF1565C0),
                                size: 36,
                              ),
                            ),
                          // الفنيين
                          ..._technicians
                              .where((t) => t.specialty == _selectedService)
                              .map(
                                (tech) => Marker(
                                  point: tech.location,
                                  width: 50,
                                  height: 50,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => _nearestTechnician = tech);
                                    },
                                    child: Icon(
                                      Icons.build_circle,
                                      color: _nearestTechnician?.id == tech.id
                                          ? Colors.green
                                          : Colors.orange,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Nearest Technician Card
                if (_nearestTechnician != null)
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
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF1565C0),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _nearestTechnician!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    _nearestTechnician!.specialty,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _nearestTechnician!.rating.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _requestSent
                                  ? Colors.green
                                  : const Color(0xFF1565C0),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _requestSent ? null : _sendRequest,
                            child: Text(
                              _requestSent ? '✓ Request Sent' : 'Send Request',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
