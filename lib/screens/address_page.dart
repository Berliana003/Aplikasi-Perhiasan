import 'package:flutter/material.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alamat & Pengiriman")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.add_location),
            title: const Text("Tambah Alamat Baru"),
            onTap: () {
              // TODO: Form tambah alamat
            },
          ),
          Divider(color: Colors.grey[300]),
          ListTile(
            leading: const Icon(Icons.edit_location),
            title: const Text("Kelola Alamat"),
            onTap: () {
              // TODO: Halaman edit / hapus alamat
            },
          ),
        ],
      ),
    );
  }
}
