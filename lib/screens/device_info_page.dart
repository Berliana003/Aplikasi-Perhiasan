import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  String _deviceModel = "Memuat...";
  String _osVersion = "Memuat...";
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    setState(() {
      _deviceModel = "Memuat...";
      _osVersion = "Memuat...";
      _errorMessage = "";
    });

    try {
      if (kIsWeb) {
        final webInfo = await deviceInfoPlugin.webBrowserInfo;
        String browserName = webInfo.browserName.name;
        String osHost = _extractOsFromUserAgent(webInfo.userAgent ?? "");
        _updateState("Web Browser", "$osHost | Browser: $browserName");
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        _updateState(
          androidInfo.model,
          "Android ${androidInfo.version.release}",
        );
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        _updateState(
          iosInfo.name.isNotEmpty ? iosInfo.name : iosInfo.utsname.machine,
          "${iosInfo.systemName} ${iosInfo.systemVersion}",
        );
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        String osName = windowsInfo.buildNumber >= 22000
            ? "Windows 11"
            : "Windows 10";
        _updateState(
          windowsInfo.computerName.isNotEmpty
              ? windowsInfo.computerName
              : "Perangkat Windows",
          "$osName (Build ${windowsInfo.buildNumber})",
        );
      } else {
        _updateState(Platform.operatingSystem, Platform.operatingSystemVersion);
      }
    } catch (e) {
      _updateError(
        "Gagal Deteksi",
        "Error: $e",
        "Gagal mengambil info perangkat. Jalankan 'flutter clean' dan 'flutter pub get'.",
      );
      debugPrint("Device Info Error: $e");
    }
  }

  String _extractOsFromUserAgent(String userAgent) {
    if (userAgent.contains('Windows NT 10.0')) return 'Windows 10/11';
    if (userAgent.contains('Macintosh')) return 'macOS';
    if (userAgent.contains('iPhone')) return 'iOS';
    if (userAgent.contains('Android')) return 'Android';
    if (userAgent.contains('Linux')) return 'Linux';
    return 'Unknown OS';
  }

  void _updateState(String model, String os) {
    setState(() {
      _deviceModel = model;
      _osVersion = os;
    });
  }

  void _updateError(String model, String os, String message) {
    setState(() {
      _deviceModel = model;
      _osVersion = os;
      _errorMessage = message;
    });
  }

  Widget _buildDeviceField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: value.length > 50 ? 12 : 15,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informasi Perangkat"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.deepOrange, thickness: 1),
                    _buildDeviceField("Model", _deviceModel),
                    _buildDeviceField("OS", _osVersion),
                  ],
                ),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade400),
                  ),
                  child: Text(
                    _errorMessage,
                    style: GoogleFonts.poppins(
                      color: Colors.red.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
