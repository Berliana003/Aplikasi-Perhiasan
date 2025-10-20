import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/screens/order_history_page.dart';
import 'package:flutter_application_1/screens/security_page.dart';
import 'package:flutter_application_1/screens/address_page.dart';
import 'package:flutter_application_1/screens/device_info_page.dart';

class SettingsPage {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF5EFFC),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header dengan judul dan tombol close
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      "Pengaturan",
                      style: GoogleFonts.patuaOne(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),

              // List pengaturan
              ListTile(
                leading: const Icon(Icons.info, color: Colors.deepPurple),
                title: Text(
                  "Informasi Perangkat",
                  style: GoogleFonts.youngSerif(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DeviceInfoPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.green),
                title: Text(
                  "Riwayat Checkout",
                  style: GoogleFonts.youngSerif(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.orange),
                title: Text(
                  "Keamanan & Login",
                  style: GoogleFonts.youngSerif(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SecurityPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: Text(
                  "Alamat & Pengiriman",
                  style: GoogleFonts.youngSerif(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddressPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
