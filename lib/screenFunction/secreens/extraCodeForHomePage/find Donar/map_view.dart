import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DonorMapView extends StatefulWidget {
  final List<dynamic> users;

  const DonorMapView({super.key, required this.users});

  @override
  State<DonorMapView> createState() => _DonorMapViewState();
}

class _DonorMapViewState extends State<DonorMapView> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};
  LatLng _initialPosition =
      const LatLng(23.6850, 90.3563); // Default: Bangladesh

  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _getCurrentLocation();
  }

  void _setMarkers() {
    for (var user in widget.users) {
      final data = user.data();
      if (data['latitude'] != null && data['longitude'] != null) {
        final LatLng position = LatLng(data['latitude'], data['longitude']);
        final String name = data['name'] ?? 'Unknown';
        final String bloodGroup = data['bloodGroup'] ?? 'N/A';

        _markers.add(
          Marker(
            markerId: MarkerId(user.id),
            position: position,
            infoWindow: InfoWindow(
              title: name,
              snippet: 'Blood Group: $bloodGroup',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _location.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      await _location.requestPermission();
    }

    final locData = await _location.getLocation();
    setState(() {
      _initialPosition = LatLng(locData.latitude!, locData.longitude!);
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_initialPosition, 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Map View'),
        backgroundColor: const Color.fromARGB(255, 125, 11, 2),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 10,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
