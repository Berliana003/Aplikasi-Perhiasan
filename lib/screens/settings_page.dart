import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/order_history_page.dart';
import 'package:flutter_application_1/screens/security_page.dart';
import 'package:flutter_application_1/screens/address_page.dart';
import 'package:flutter_application_1/screens/policy_webview_page.dart';
import 'package:flutter_application_1/screens/device_info_page.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pengaturan",
                      style: GoogleFonts.youngSerif(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),

                _buildMenuItem(
                  icon: Icons.info,
                  color: Colors.blue,
                  title: "Informasi Perangkat",
                  page: const DeviceInfoPage(),
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  color: Colors.green,
                  title: "Riwayat Checkout",
                  page: const OrderHistoryPage(),
                ),
                _buildMenuItem(
                  icon: Icons.lock,
                  color: Colors.orange,
                  title: "Keamanan & Login",
                  page: const SecurityPage(),
                ),
                _buildMenuItem(
                  icon: Icons.location_on,
                  color: Colors.blue,
                  title: "Alamat & Pengiriman",
                  page: const AddressPage(),
                ),
                _buildMenuItem(
                  icon: Icons.policy,
                  color: Colors.indigo,
                  title: "Kebijakan Toko & Akun",
                  page: const PolicyWebViewPage(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color color,
    required String title,
    required Widget page,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color),
          title: Text(title, style: GoogleFonts.poppins()),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () async {
            Navigator.pop(context);
            await Future.delayed(const Duration(milliseconds: 150));
            if (mounted) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => page));
            }
          },
        ),
        Divider(color: Colors.grey[300]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: GoogleFonts.youngSerif(fontSize: 28)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: const Center(child: Text("Halaman Home")),
    );
  }
}
