import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart_item.dart';
import 'package:flutter_application_1/models/product.dart';
import 'chat_page.dart';
import 'cart_page.dart';
import 'checkout_page.dart';
import 'package:flutter_application_1/screens/category_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? selectedVariation;

  int quantity = 1;

  // simpan pilihan user per kategori variasi
  Map<String, String> selectedVariations = {};

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    // hitung estimasi tanggal tiba
    final estimatedDate = DateTime.now().add(
      Duration(days: product.deliveryDays),
    );
    final formattedDate = DateFormat("dd MMM yyyy").format(estimatedDate);

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // Tombol bawah
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.red),
              label: const Text(
                "Chat",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartPage()),
                );
              },
              icon: badges.Badge(
                showBadge: cartItems.isNotEmpty,
                position: badges.BadgePosition.topStart(top: -10, start: -12),
                badgeAnimation: badges.BadgeAnimation.slide(
                  toAnimate: true,
                  curve: Curves.easeInOut,
                  animationDuration: const Duration(milliseconds: 300),
                ),
                badgeContent: Text(
                  "${cartItems.length}", // jumlah produk unik
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.orange,
                ),
              ),
              label: const Text(
                "Keranjang",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Cek apakah produk punya variasi
                  if (product.variations != null &&
                      product.variations!.isNotEmpty) {
                    // Cek apakah semua kategori sudah dipilih
                    bool semuaDipilih = product.variations!.keys.every(
                      (kategori) => selectedVariations.containsKey(kategori),
                    );

                    if (!semuaDipilih) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Silakan pilih semua variasi terlebih dahulu",
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return; // Stop, jangan tambah ke keranjang
                    }
                  }

                  // Kalau sudah valid → tambah ke keranjang
                  cartItems.add(
                    CartItem(
                      product: product,
                      selectedVariations: Map.from(selectedVariations),
                      quantity: quantity,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Produk ditambahkan ke keranjang"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[800],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Tambah ke Keranjang",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        items: [
                          CartItem(
                            product: product,
                            quantity: quantity,
                            selectedVariations: Map.from(selectedVariations),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Checkout Sekarang",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue[900],
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "Detail Produk",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Gambar Produk
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: product.imageBytes != null
                    ? Image.memory(
                        product.imageBytes!,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      )
                    : product.image.isNotEmpty
                    ? Image.asset(
                        product.image,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      )
                    : const Icon(Icons.broken_image, size: 120),
              ),
            ),

            const SizedBox(height: 8),

            // Nama + Harga
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rp ${(product.getFinalPrice()).toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (product.diskon > 0) ...[
                        Text(
                          "Rp ${product.price.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "-${product.diskon.toStringAsFixed(0)}%",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Rating & Terjual
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  RatingBar.builder(
                    initialRating: product.rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 22,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() {
                        // update rating produk (sementara)
                        widget.product.rating = rating;
                      });
                      print("Rating baru: $rating");
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(height: 16, width: 1, color: Colors.grey[300]),
                  const SizedBox(width: 13),
                  Text(
                    "Terjual ${product.sold}",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Stok + Estimasi Tiba
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ketersediaan & Pengiriman",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.inventory_2,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Stok: ${product.stock} pcs",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_shipping,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Tiba ${product.deliveryDays} hari (${formattedDate})",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Deskripsi Produk
            if (product.description != null && product.description!.isNotEmpty)
              _buildSection(
                title: "Deskripsi Produk",
                content: product.description!,
              ),

            // Spesifikasi
            if (product.specs != null && product.specs!.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Spesifikasi",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...product.specs!.map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          "• $s",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Variasi
            if (product.variations != null && product.variations!.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Varian",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: product.variations!.entries.map((entry) {
                        String kategori = entry.key;
                        List<String> opsi = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                kategori,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              children: opsi.map((v) {
                                return ChoiceChip(
                                  label: Text(v),
                                  selected: selectedVariations[kategori] == v,
                                  backgroundColor: Colors.grey[200],
                                  selectedColor: Colors.green[200],
                                  labelStyle: const TextStyle(fontSize: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedVariations[kategori] = v;
                                      } else {
                                        selectedVariations.remove(kategori);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            // Jumlah Produk
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Jumlah",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                      ),
                      Text(
                        "$quantity",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper
  Widget _buildSection({required String title, required String content}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
