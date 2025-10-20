import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

class LoginActivityPage extends StatefulWidget {
  const LoginActivityPage({super.key});

  @override
  State<LoginActivityPage> createState() => _LoginActivityPageState();
}

class _LoginActivityPageState extends State<LoginActivityPage> {
  final List<Map<String, dynamic>> _activities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeviceAndLocation();
  }

  Future<void> _loadDeviceAndLocation() async {
    final formatDate = DateFormat('dd MMM yyyy, HH:mm');
    final deviceInfo = DeviceInfoPlugin();

    // Ambil email user dari FirebaseAuth
    final user = FirebaseAuth.instance.currentUser;
    String deviceName = user?.email ?? "Unknown Device";

    // Tambahkan info perangkat (kalau mau digabungkan dengan email)
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        final info = await deviceInfo.androidInfo;
        deviceName = "${user?.email ?? "Unknown"} - ${info.model} (Android)";
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final info = await deviceInfo.iosInfo;
        deviceName =
            "${user?.email ?? "Unknown"} - ${info.utsname.machine} (iOS)";
      } else {
        final info = await deviceInfo.deviceInfo;
        deviceName =
            "${user?.email ?? "Unknown"} - ${info.data["device"] ?? "Desktop/Web"}";
      }
    } catch (e) {
      deviceName = user?.email ?? "Unknown Device";
    }

    // Dapatkan lokasi
    String location = "Tidak diketahui";
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        location = "Layanan lokasi nonaktif";
      } else {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          location = "Izin lokasi ditolak";
        } else {
          Position pos = await Geolocator.getCurrentPosition();

          // Reverse geocoding
          List<Placemark> placemarks = await placemarkFromCoordinates(
            pos.latitude,
            pos.longitude,
          );

          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            // Ambil nama daerah yang jelas
            location =
                "${place.subAdministrativeArea ?? place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
          } else {
            location =
                "Lat: ${pos.latitude.toStringAsFixed(2)}, Lng: ${pos.longitude.toStringAsFixed(2)}";
          }
        }
      }
    } catch (e) {
      location = "Lokasi tidak tersedia";
    }

    setState(() {
      _activities.add({
        "device": deviceName,
        "time": formatDate.format(DateTime.now()),
        "location": location,
      });
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text(
          "Aktivitas Login",
          style: GoogleFonts.youngSerif(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final data = _activities[index];
                final email = data["device"].split(" - ").first;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.devices, color: Color(0xFF0D47A1)),
                            const SizedBox(width: 10),
                            Text(
                              "Lihat Perangkat",
                              style: GoogleFonts.arvo(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: const Color(0xFF0D47A1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          email,
                          style: GoogleFonts.berkshireSwash(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "🕓 ${data["time"]}\n📍 ${data["location"]}",
                          style: GoogleFonts.arvo(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
