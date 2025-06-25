import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorMapView extends StatefulWidget {
  final List<QueryDocumentSnapshot> users;

  const DonorMapView({super.key, required this.users});

  @override
  State<DonorMapView> createState() => _DonorMapViewState();
}

class _DonorMapViewState extends State<DonorMapView> {
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  LatLng _initialPosition =
      const LatLng(23.6850, 90.3563); // Default to Bangladesh

  @override
  void initState() {
    super.initState();
    _setMarkersFromFirestore();
  }

  void _showDonorDialog(Map<String, dynamic> data) {
    final bool isAvailable = data['available'] == true;
    final String phone = data['phone'] ?? '';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ZoomIn(
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data['name'] ?? 'Unknown Donor',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // color: const Color.fromARGB(255, 125, 11, 2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "🩸 Blood Group: ${data['bloodGroup'] ?? 'N/A'}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "📞 Phone: ${data['phone'] ?? 'N/A'}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Status: ${isAvailable ? 'Available' : 'Not Available'}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isAvailable ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SMS Button
                      GestureDetector(
                        onTap: () async {
                          if (isAvailable) {
                            final smsUri = Uri.parse("sms:$phone");
                            if (await canLaunchUrl(smsUri)) {
                              await launchUrl(smsUri,
                                  mode: LaunchMode.externalApplication);
                            }
                          } else {
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Unavailable',
                                message:
                                    'This donor is not available right now.',
                                contentType: ContentType.failure,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.message,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Call Button
                      GestureDetector(
                        onTap: () async {
                          if (isAvailable) {
                            final uri = Uri.parse("tel:$phone");
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          } else {
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Unavailable',
                                message:
                                    'This donor is not available right now.',
                                contentType: ContentType.failure,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.call,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _setMarkersFromFirestore() {
    final Set<Marker> newMarkers = {};
    print("📌 Total users: ${widget.users.length}");

    for (var doc in widget.users) {
      final data = doc.data() as Map<String, dynamic>;
      print("➡️ Donor: ${data['name']}");

      if (data['location'] != null && data['location'] is Map) {
        final locMap = data['location'] as Map<String, dynamic>;
        final double? lat = locMap['latitude']?.toDouble();
        final double? lng = locMap['longitude']?.toDouble();

        if (lat != null && lng != null) {
          final LatLng position = LatLng(lat, lng);

          final marker = Marker(
            markerId: MarkerId(doc.id),
            position: position,
            infoWindow: InfoWindow(
              title: data['name'] ?? 'Unknown',
              snippet:
                  'Blood Group: ${data['bloodGroup'] ?? 'N/A'}\nPhone: ${data['phone'] ?? 'N/A'}',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            onTap: () {
              _showDonorDialog(data);
            },
          );

          newMarkers.add(marker);
          if (newMarkers.length == 1) {
            _initialPosition = position;
          }

          print("✅ Adding marker at $position");
        } else {
          print("❌ Latitude or longitude is null");
        }
      } else {
        print("❌ Location is not a Map");
      }
    }

    print("✅ Total markers added: ${newMarkers.length}");

    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _markers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 7,
              ),
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
    );
  }
}
