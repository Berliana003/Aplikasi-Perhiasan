import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/order_history.dart';
import 'package:flutter_application_1/models/user_profile.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, User? user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data user
  UserProfile profile = UserProfile(
    name: "Nama User",
    email: "user@email.com",
    address: "Jakarta, Indonesia",
    phone: "+62 812-3456-7890",
  );

  // Controller
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController phoneController;

  // Foto profil
  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final savedImage = await _saveImagePermanently(picked.path);

      setState(() {
        _profileImage = savedImage;
      });

      // Simpan path permanen ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("imagePath", savedImage.path);

      print("📸 Path gambar disimpan: ${savedImage.path}");
    }
  }

  Future<void> saveProfileToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", profile.name);
    await prefs.setString("email", profile.email);
    await prefs.setString("address", profile.address);
    await prefs.setString("phone", profile.phone);
    if (_profileImage != null) {
      await prefs.setString("imagePath", _profileImage!.path);
    }
  }

  Future<File> _saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".png";
    final image = File(imagePath);
    final savedImage = await image.copy('${directory.path}/$fileName');
    return savedImage;
  }

  // Ambil dari SharedPreferences
  Future<void> loadProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil data profil
    final name = prefs.getString("name");
    final email = prefs.getString("email");
    final address = prefs.getString("address");
    final phone = prefs.getString("phone");
    final imagePath = prefs.getString("imagePath");

    setState(() {
      profile.name = name ?? profile.name;
      profile.email = email ?? profile.email;
      profile.address = address ?? profile.address;
      profile.phone = phone ?? profile.phone;

      // Debugging supaya tahu path gambar
      print("🔍 Path gambar dari prefs: $imagePath");

      if (imagePath != null && File(imagePath).existsSync()) {
        _profileImage = File(imagePath);
        print("✅ Gambar ditemukan dan di-load");
      } else {
        _profileImage = null;
        print("❌ Gambar tidak ada atau path salah");
      }
    });

    // update controller biar isi textfield ikut berubah
    nameController.text = profile.name;
    emailController.text = profile.email;
    addressController.text = profile.address;
    phoneController.text = profile.phone;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    nameController = TextEditingController(text: profile.name);
    emailController = TextEditingController(text: profile.email);
    addressController = TextEditingController(text: profile.address);
    phoneController = TextEditingController(text: profile.phone);

    loadProfileFromPrefs();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void saveProfile() async {
    setState(() {
      profile.name = nameController.text;
      profile.email = emailController.text;
      profile.address = addressController.text;
      profile.phone = phoneController.text;
    });

    await saveProfileToPrefs();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil berhasil diperbarui ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = OrderHistory.orders;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: const Color(0xFF0D47A1),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorWeight: 3,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              dividerColor: Colors.white54,
              tabs: const [
                Tab(icon: Icon(Icons.person), text: "Identitas"),
                Tab(icon: Icon(Icons.history), text: "Riwayat"),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFE6F0FA),
        child: TabBarView(
          controller: _tabController,
          children: [
            // ------------------ TAB IDENTITAS ------------------
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!) as ImageProvider
                            : const AssetImage("assets/image/profile.jpg"),
                      ),
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[300],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Input Fields
                  buildInputField("Nama", nameController),
                  const SizedBox(height: 15),
                  buildInputField("Email", emailController),
                  const SizedBox(height: 15),
                  buildInputField("Alamat", addressController),
                  const SizedBox(height: 15),
                  buildInputField("Nomor HP", phoneController),
                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7FB3E4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "💾 Simpan Perubahan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ------------------ TAB RIWAYAT PESANAN ------------------
            orders.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada pesanan",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              order.product.image,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            order.product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Jumlah: ${order.quantity}"),
                              Text("Metode: ${order.paymentMethod}"),
                              Text(
                                "Total: Rp ${order.total.toStringAsFixed(0)}",
                              ),
                              Text(
                                "Tanggal: ${DateFormat('dd/MM/yyyy HH:mm').format(order.date)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // Widget reusable untuk TextField
  Widget buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.edit, color: Colors.blue),
        labelStyle: const TextStyle(color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}
