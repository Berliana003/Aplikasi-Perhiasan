import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keamanan & Login")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Ganti Kata Sandi"),
            onTap: () {
              // TODO: Tambahkan logika ganti password
            },
          ),
          Divider(color: Colors.grey[300]),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text("Autentikasi Dua Langkah"),
            onTap: () {
              // TODO: Tambahkan logika 2FA
            },
          ),
        ],
      ),
    );
  }
}
