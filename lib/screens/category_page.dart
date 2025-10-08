import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/cart_item.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/screens/cart_page.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/screens/notification_page.dart';
import 'package:flutter_application_1/screens/profile_page.dart';
import 'home_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_application_1/screens/product_detail_page.dart';
import 'package:intl/intl.dart';

List<CartItem> cartItems = [];

class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final stockController = TextEditingController();
  final deliveryDaysController = TextEditingController();

  String _searchQuery = "";
  String _selectedFilter = "All";
  int _selectedIndex = 0;

  String formatRupiah(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  void _applyFilters() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Product> _getFilteredProducts() {
    List<Product> filtered = widget.category.products.where((p) {
      return p.name.toLowerCase().contains(_searchQuery);
    }).toList();

    switch (_selectedFilter) {
      case "Diskon Terbesar":
        filtered.sort((a, b) => b.diskon.compareTo(a.diskon));
        break;
      case "Harga Termurah":
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case "Trending":
        filtered.sort((a, b) => b.sold.compareTo(a.sold));
        break;
      case "All":
      default:
        break;
    }
    return filtered;
  }

  // Hapus produk
  void _deleteProduct(Product product) {
    setState(() {
      widget.category.products.remove(product);
    });
  }

  // Form tambah produk
  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final diskonController = TextEditingController();
    final ratingController = TextEditingController();
    final soldController = TextEditingController();
    final descriptionController = TextEditingController();
    final specificationController = TextEditingController();
    final variationController = TextEditingController();

    String? imagePath;
    Uint8List? imageBytes;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Tambah Produk"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Nama Produk",
                      ),
                    ),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Harga"),
                    ),
                    TextField(
                      controller: diskonController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Diskon (%)",
                      ),
                    ),
                    TextField(
                      controller: ratingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Rating"),
                    ),
                    TextField(
                      controller: soldController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Terjual"),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Deskripsi Produk",
                      ),
                      maxLines: 3,
                    ),
                    TextField(
                      controller: specificationController,
                      decoration: const InputDecoration(
                        labelText: "Spesifikasi Produk (pisahkan dengan koma)",
                      ),
                      maxLines: 2,
                    ),
                    TextField(
                      controller: variationController,
                      decoration: const InputDecoration(
                        labelText:
                            "Variasi (contoh: Warna: Merah, Biru; Ukuran: S, M, L)",
                      ),
                      maxLines: 2,
                    ),
                    TextField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Stok"),
                    ),
                    TextField(
                      controller: deliveryDaysController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Estimasi Pengiriman (hari)",
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Preview Gambar
                    if (imageBytes != null)
                      SizedBox(
                        height: 100,
                        child: Image.memory(imageBytes!, fit: BoxFit.cover),
                      )
                    else if (imagePath != null)
                      SizedBox(
                        height: 100,
                        child: Image.file(File(imagePath!), fit: BoxFit.cover),
                      ),

                    const SizedBox(height: 8),

                    // Tombol pilih file
                    ElevatedButton.icon(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.image);
                        if (result != null) {
                          setStateDialog(() {
                            if (kIsWeb) {
                              imageBytes = result.files.first.bytes;
                              imagePath = null;
                            } else {
                              imagePath = result.files.single.path;
                              imageBytes = null;
                            }
                          });
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("Pilih Gambar"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Batal"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text("Simpan"),
                  onPressed: () {
                    List<String> specification = specificationController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    Map<String, List<String>> variation = {};
                    for (var section in variationController.text.split(';')) {
                      if (section.contains(':')) {
                        var parts = section.split(':');
                        String key = parts[0].trim();
                        List<String> values = parts[1]
                            .split(',')
                            .map((v) => v.trim())
                            .where((v) => v.isNotEmpty)
                            .toList();
                        variation[key] = values;
                      }
                    }

                    final newProduct = Product(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      price: double.tryParse(priceController.text) ?? 0,
                      diskon: double.tryParse(diskonController.text) ?? 0,
                      rating: double.tryParse(ratingController.text) ?? 0,
                      sold: int.tryParse(soldController.text) ?? 0,
                      stock: int.tryParse(stockController.text) ?? 0,
                      deliveryDays:
                          int.tryParse(deliveryDaysController.text) ?? 0,
                      image: imagePath ?? "",
                      imageBytes: imageBytes,
                      description: descriptionController.text,
                      specification: specification,
                      variation: variation,
                    );

                    setState(() {
                      widget.category.products.add(newProduct);
                    });

                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Form edit produk
  void _showEditProductDialog(Product product) {
    final nameController = TextEditingController(text: product.name);
    final priceController = TextEditingController(
      text: product.price.toString(),
    );
    final diskonController = TextEditingController(
      text: product.diskon.toString(),
    );
    final ratingController = TextEditingController(
      text: product.rating.toString(),
    );
    final soldController = TextEditingController(text: product.sold.toString());
    final descriptionController = TextEditingController(
      text: product.description,
    );
    final specificationController = TextEditingController(
      text: product.specification?.join(', ') ?? '',
    );
    final variationController = TextEditingController(
      text: product.variation != null
          ? product.variation!.entries
                .map((e) => "${e.key}: ${e.value.join(', ')}")
                .join('; ')
          : '',
    );

    String? imagePath = product.image.isNotEmpty ? product.image : null;
    Uint8List? imageBytes = product.imageBytes;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Edit Produk"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Nama Produk",
                      ),
                    ),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Harga"),
                    ),
                    TextField(
                      controller: diskonController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Diskon (%)",
                      ),
                    ),
                    TextField(
                      controller: ratingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Rating"),
                    ),
                    TextField(
                      controller: soldController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Terjual"),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Deskripsi Produk",
                      ),
                      maxLines: 3,
                    ),
                    TextField(
                      controller: specificationController,
                      decoration: const InputDecoration(
                        labelText: "Spesifikasi (pisahkan dengan koma)",
                      ),
                      maxLines: 2,
                    ),
                    TextField(
                      controller: variationController,
                      decoration: const InputDecoration(
                        labelText:
                            "Variasi (contoh: Warna: Merah, Biru; Ukuran: S, M, L)",
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),

                    // Preview gambar
                    if (imageBytes != null)
                      SizedBox(
                        height: 100,
                        child: Image.memory(imageBytes!, fit: BoxFit.cover),
                      )
                    else if (imagePath != null && imagePath!.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: kIsWeb
                            ? Image.network(imagePath!, fit: BoxFit.cover)
                            : Image.file(File(imagePath!), fit: BoxFit.cover),
                      ),

                    const SizedBox(height: 8),

                    // Tombol pilih file
                    ElevatedButton.icon(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.image);
                        if (result != null) {
                          setStateDialog(() {
                            if (kIsWeb) {
                              imageBytes = result.files.first.bytes;
                              imagePath = null;
                            } else {
                              imagePath = result.files.single.path;
                              imageBytes = null;
                            }
                          });
                        }
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("Pilih Gambar Baru"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Batal"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text("Update"),
                  onPressed: () {
                    setState(() {
                      product.name = nameController.text;
                      product.price =
                          double.tryParse(priceController.text) ?? 0;
                      product.diskon =
                          double.tryParse(diskonController.text) ?? 0;
                      product.rating =
                          double.tryParse(ratingController.text) ?? 0;
                      product.sold = int.tryParse(soldController.text) ?? 0;
                      product.image = imagePath ?? "";
                      product.imageBytes = imageBytes;
                      product.description = descriptionController.text;
                      product.specification = specificationController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();

                      Map<String, List<String>> variations = {};
                      for (var section in variationController.text.split(';')) {
                        if (section.contains(':')) {
                          var parts = section.split(':');
                          String key = parts[0].trim();
                          List<String> values = parts[1]
                              .split(',')
                              .map((v) => v.trim())
                              .where((v) => v.isNotEmpty)
                              .toList();
                          variations[key] = values;
                        }
                      }
                      product.variation = variations;
                    });

                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _applyFilters(),
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.blue),
                  onPressed: () => _applyFilters(),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 178, 224, 243),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(
                      "All",
                      style: TextStyle(
                        color: _selectedFilter == "All"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: _selectedFilter == "All",
                    selectedColor: Colors.blue,
                    backgroundColor: const Color(0xFFF5F2F7),
                    onSelected: (_) {
                      setState(() => _selectedFilter = "All");
                    },
                  ),
                  ChoiceChip(
                    label: Text(
                      "Diskon Terbesar",
                      style: TextStyle(
                        color: _selectedFilter == "Diskon Terbesar"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: _selectedFilter == "Diskon Terbesar",
                    selectedColor: Colors.blue,
                    backgroundColor: const Color(0xFFF5F2F7),
                    onSelected: (_) {
                      setState(() => _selectedFilter = "Diskon Terbesar");
                    },
                  ),
                  ChoiceChip(
                    label: Text(
                      "Harga Termurah",
                      style: TextStyle(
                        color: _selectedFilter == "Harga Termurah"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: _selectedFilter == "Harga Termurah",
                    selectedColor: Colors.blue,
                    backgroundColor: const Color(0xFFF5F2F7),
                    onSelected: (_) {
                      setState(() => _selectedFilter = "Harga Termurah");
                    },
                  ),
                  ChoiceChip(
                    label: Text(
                      "Trending",
                      style: TextStyle(
                        color: _selectedFilter == "Trending"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: _selectedFilter == "Trending",
                    selectedColor: Colors.blue,
                    backgroundColor: const Color(0xFFF5F2F7),
                    onSelected: (_) {
                      setState(() => _selectedFilter = "Trending");
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // GridView Produk
          SizedBox(
            height: 330,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 12,
                childAspectRatio: 0.70,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final p = filteredProducts[index];

                return SizedBox(
                  width: 220,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(product: p),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Gambar
                            Expanded(
                              flex: 13,
                              child: () {
                                if (p.imageBytes != null && kIsWeb) {
                                  return Image.memory(
                                    p.imageBytes!,
                                    fit: BoxFit.contain,
                                  );
                                } else if (p.image.startsWith("assets/")) {
                                  return Image.asset(
                                    p.image,
                                    fit: BoxFit.contain,
                                  );
                                } else if (p.image.isNotEmpty && !kIsWeb) {
                                  return Image.file(
                                    File(p.image),
                                    fit: BoxFit.contain,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.broken_image,
                                    size: 120,
                                  );
                                }
                              }(),
                            ),

                            const SizedBox(height: 4),

                            // Nama produk
                            Expanded(
                              flex: 2,
                              child: Text(
                                p.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),

                            const SizedBox(height: 3),

                            // Harga
                            Text(
                              formatRupiah(p.price),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),

                            // Diskon
                            Text(
                              "Diskon ${p.diskon.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),

                            const SizedBox(height: 3),

                            // Rating + Terjual
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  p.rating.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  "Terjual ${p.sold}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 0),

                            // Tombol Edit & Hapus
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () => _showEditProductDialog(p),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () => _deleteProduct(p),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          if (index == 0) {
            // Ganti halaman ke Home tanpa menumpuk stack
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationPage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartPage()),
            );
          }
        },
        selectedItemColor: Colors.lightBlue[400],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifikasi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Keranjang",
          ),
        ],
      ),
    );
  }
}
