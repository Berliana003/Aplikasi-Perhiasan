import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_activity_page.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text(
          "Keamanan & Login",
          style: GoogleFonts.youngSerif(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pengaturan Keamanan",
              style: GoogleFonts.patuaOne(
                fontSize: 28,
                color: const Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 16),

            _buildMenuCard(
              context,
              icon: Icons.history,
              title: "Aktivitas Login",
              subtitle: "Lihat perangkat dan waktu login terakhir Anda.",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginActivityPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membuat kartu menu
  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFEEF3FF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF0D47A1)),
        ),
        title: Text(
          title,
          style: GoogleFonts.patuaOne(fontSize: 20, color: Colors.black87),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.arvo(fontSize: 14, color: Colors.grey[700]),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
