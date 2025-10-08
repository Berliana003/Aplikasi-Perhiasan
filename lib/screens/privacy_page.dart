import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privasi & Akun")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text("Hapus Akun"),
            onTap: () {
              // TODO: Konfirmasi hapus akun
            },
          ),
          Divider(color: Colors.grey[300]),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Pengaturan Privasi"),
            onTap: () {
              // TODO: Tambahkan pengaturan privasi
            },
          ),
        ],
      ),
    );
  }
}
