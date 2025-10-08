import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_profile.dart';
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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: profile.name);
    emailController = TextEditingController(text: profile.email);
    addressController = TextEditingController(text: profile.address);
    phoneController = TextEditingController(text: profile.phone);

    loadProfileFromPrefs();
  }

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildProfileHeader(),
            const SizedBox(height: 25),
            _buildProfileForm(),
            const SizedBox(height: 25),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : const AssetImage("assets/image/profile.jpg")
                        as ImageProvider,
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: InkWell(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0D47A1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          profile.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          profile.email,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildProfileForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          buildInputField("Nama", Icons.person, nameController),
          const SizedBox(height: 15),
          buildInputField("Email", Icons.email, emailController),
          const SizedBox(height: 15),
          buildInputField("Alamat", Icons.home, addressController),
          const SizedBox(height: 15),
          buildInputField("Nomor HP", Icons.phone, phoneController),
        ],
      ),
    );
  }

  Widget buildInputField(
    String label,
    IconData icon,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0D47A1)),
        filled: true,
        fillColor: const Color(0xFFF8FAFF),
        labelStyle: const TextStyle(color: Colors.black87),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 1.8),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: saveProfile,
      icon: const Icon(Icons.save, color: Colors.white),
      label: const Text(
        "Simpan Perubahan",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1565C0),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 3,
      ),
    );
  }
}
