import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference _addressRef = FirebaseFirestore.instance.collection(
    'user_addresses',
  );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? selectedAddressId;
  bool setAsDefault = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedAddress();
  }

  Future<void> _loadSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAddressId = prefs.getString('selected_address_id');
    });
  }

  // Simpan alamat yang dipilih ke SharedPreferences
  Future<void> _saveSelectedAddress(
    String id,
    Map<String, dynamic> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_address_id', id);
    await prefs.setString(
      'selected_address',
      "${data['name']}|${data['detail']}|${data['phone']}",
    );
    setState(() {
      selectedAddressId = id;
    });
  }

  // Tambah alamat baru ke Firestore
  Future<void> _addAddress() async {
    _nameController.clear();
    _detailController.clear();
    _phoneController.clear();
    setAsDefault = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        bool isSaved = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul + tombol X
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tambah Alamat Baru",
                          style: GoogleFonts.patuaOne(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Nama alamat
                    TextField(
                      controller: _nameController,
                      style: GoogleFonts.crimsonPro(fontSize: 15),
                      decoration: InputDecoration(
                        labelText: "Nama Alamat (Rumah, Kantor, dll)",
                        labelStyle: GoogleFonts.berkshireSwash(fontSize: 16),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Detail alamat
                    TextField(
                      controller: _detailController,
                      style: GoogleFonts.crimsonPro(fontSize: 15),
                      decoration: InputDecoration(
                        labelText: "Detail Alamat",
                        labelStyle: GoogleFonts.berkshireSwash(fontSize: 16),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),

                    // Nomor telepon
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.crimsonPro(fontSize: 15),
                      decoration: InputDecoration(
                        labelText: "Nomor Telepon",
                        labelStyle: GoogleFonts.berkshireSwash(fontSize: 16),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tombol Simpan
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_nameController.text.isEmpty ||
                            _detailController.text.isEmpty ||
                            _phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Harap isi semua kolom terlebih dahulu",
                              ),
                            ),
                          );
                          return;
                        }

                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Pengguna tidak terautentikasi."),
                            ),
                          );
                          return;
                        }

                        try {
                          await _addressRef.add({
                            'uid': user!.uid,
                            'name': _nameController.text.trim(),
                            'detail': _detailController.text.trim(),
                            'phone': _phoneController.text.trim(),
                            'createdAt': FieldValue.serverTimestamp(),
                          });

                          // Tampilkan pesan sukses
                          setModalState(() => isSaved = true);

                          if (context.mounted) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text("Alamat berhasil ditambahkan."),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal menyimpan: $e")),
                          );
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: Text(
                        "Simpan",
                        style: GoogleFonts.cinzel(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),

                    if (isSaved) ...[
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "✅ Alamat sudah tersimpan",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Hapus alamat
  Future<void> _deleteAddress(String id) async {
    try {
      await _addressRef.doc(id).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Alamat berhasil dihapus")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menghapus: $e")));
      }
    }
  }

  // Edit alamat
  void _editAddress(String id, Map<String, dynamic> address) {
    _nameController.text = address['name'] ?? '';
    _detailController.text = address['detail'] ?? '';
    _phoneController.text = address['phone'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Alamat",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Alamat",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _detailController,
                  decoration: const InputDecoration(
                    labelText: "Detail Alamat",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Nomor Telepon",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    await _addressRef.doc(id).update({
                      'name': _nameController.text.trim(),
                      'detail': _detailController.text.trim(),
                      'phone': _phoneController.text.trim(),
                    });
                    if (mounted) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Simpan Perubahan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  // Pilih alamat untuk checkout
  void _selectAddress(String id, Map<String, dynamic> data) async {
    await _saveSelectedAddress(id, data);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Alamat dipilih untuk pengiriman.")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Anda harus login untuk mengelola alamat.")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text(
          "Alamat & Pengiriman",
          style: GoogleFonts.cinzel(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAddress,
        icon: const Icon(Icons.add_location_alt, color: Colors.red),
        label: Text(
          "Tambah Alamat",
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _addressRef
            .where('uid', isEqualTo: user!.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(
                "Belum ada alamat tersimpan.",
                style: GoogleFonts.arvo(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final isSelected = selectedAddressId == doc.id;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: isSelected ? 5 : 2,
                color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    isSelected ? Icons.check_circle : Icons.location_on,
                    color: const Color(0xFF0D47A1),
                  ),
                  title: Text(
                    data['name'] ?? '',
                    style: GoogleFonts.patuaOne(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D47A1),
                    ),
                  ),
                  subtitle: Text(
                    "${data['detail'] ?? ''}\nTelp: ${data['phone'] ?? '-'}",
                    style: GoogleFonts.arvo(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') _editAddress(doc.id, data);
                      if (value == 'delete') _deleteAddress(doc.id);
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Hapus')),
                    ],
                  ),
                  onTap: () => _selectAddress(doc.id, data),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
