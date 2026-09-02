import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/translation_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  LatLng _userLocation = const LatLng(28.6139, 77.2090); // Default Delhi
  bool _loading = true;

  final MapController _mapController = MapController();

  final List<Map<String, dynamic>> _mandis = [
    {"name": "Delhi Azadpur Mandi", "location": const LatLng(28.7161, 77.1722)},
    {"name": "Okhla Mandi", "location": const LatLng(28.5528, 77.2764)},
    {"name": "Noida Sector 88 Mandi", "location": const LatLng(28.5298, 77.3871)},
    {"name": "Gurugram Khandsa Mandi", "location": const LatLng(28.4357, 77.0055)},
    {"name": "Ghaziabad Mandi Samiti", "location": const LatLng(28.6515, 77.4125)},
  ];

  @override
  void initState() {
    super.initState();
    _getUserGPSLocation();
  }

  Future<void> _getUserGPSLocation() async {
    final Position? position = await _locationService.getCurrentLocation();
    if (position != null && mounted) {
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _loading = false;
      });
      // Move map to the user's location
      _mapController.move(_userLocation, 11);
    } else {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate distance to each Mandi and sort
    final List<Map<String, dynamic>> sortedMandis = _mandis.map((mandi) {
      LatLng mLoc = mandi["location"];
      double dist = _locationService.calculateDistanceInKm(
        _userLocation.latitude,
        _userLocation.longitude,
        mLoc.latitude,
        mLoc.longitude,
      );
      return {
        "name": mandi["name"],
        "location": mLoc,
        "distance": dist,
      };
    }).toList();

    // Sort by nearest distance
    sortedMandis.sort((a, b) => (a["distance"] as double).compareTo(b["distance"] as double));

    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationService.translate('nearby_markets')),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              setState(() {
                _loading = true;
              });
              _getUserGPSLocation();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation,
              initialZoom: 10,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.flutter_application_1',
              ),
              MarkerLayer(
                markers: [
                  // User Location Marker (Blue)
                  Marker(
                    point: _userLocation,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 45,
                    ),
                  ),
                  // Mandi Markers (Red)
                  ..._mandis.map((mandi) {
                    return Marker(
                      point: mandi["location"],
                      width: 50,
                      height: 50,
                      child: Tooltip(
                        message: mandi["name"],
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          // Bottom Mandi Distance Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 220,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      TranslationService.translate('nearby_markets'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sortedMandis.length,
                      itemBuilder: (context, index) {
                        final mandi = sortedMandis[index];
                        final dist = mandi["distance"] as double;
                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: Icon(Icons.store, color: Colors.green.shade800, size: 20),
                          ),
                          title: Text(
                            mandi["name"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Distance: ${dist.toStringAsFixed(1)} km"),
                          trailing: const Icon(Icons.directions, color: Colors.blue),
                          onTap: () {
                            _mapController.move(mandi["location"], 13);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}