import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/category_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/models/cart_item.dart';
import 'chat_page.dart';
import 'cart_page.dart';
import 'checkout_page.dart';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? selectedVariation;
  int quantity = 1;
  Map<String, String> selectedVariations = {};
  Uint8List? _webImageBytes;
  String? _webVideoUrl;
  // Data review
  List<Map<String, dynamic>> reviews = [];

  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 0.0;
  File? _selectedMedia;
  bool _isVideo = false;
  VideoPlayerController? _videoController;

  // Responsive scale helper
  double getResponsiveSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    if (width < 400) return size * 0.85;
    if (width < 800) return size * 1.0;
    if (width < 1200) return size * 1.15;
    return size * 1.3;
  }

  Future<void> _pickMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
    );

    if (result != null) {
      final file = result.files.single;

      if (kIsWeb) {
        if (file.extension == 'mp4') {
          // Buat URL blob untuk video agar bisa diputar
          final blob = html.Blob([file.bytes!]);
          final blobUrl = html.Url.createObjectUrlFromBlob(blob);

          setState(() {
            _isVideo = true;
            _webVideoUrl = blobUrl;
            _webImageBytes = null;

            _videoController =
                VideoPlayerController.networkUrl(Uri.parse(blobUrl))
                  ..initialize().then((_) {
                    setState(() {});
                  });
          });
        } else {
          // Gambar di web
          setState(() {
            _isVideo = false;
            _webImageBytes = file.bytes;
            _webVideoUrl = null;
          });
        }
      } else {
        // Untuk Android/iOS/Desktop
        final pickedFile = File(file.path!);
        setState(() {
          _selectedMedia = pickedFile;
          _isVideo = file.extension == 'mp4';

          if (_isVideo) {
            _videoController = VideoPlayerController.file(pickedFile)
              ..initialize().then((_) {
                setState(() {});
              });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final estimatedDate = DateTime.now().add(
      Duration(days: product.deliveryDays),
    );
    final formattedDate = DateFormat("dd MMM yyyy").format(estimatedDate);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: _buildBottomBar(context, product),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header tetap full biru ke kanan kiri
            _buildHeader(context),

            // Sisanya diberi padding
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(product, context),
                  _buildNamePrice(
                    product,
                    formatCurrency,
                    getResponsiveSize(context, 1),
                  ),
                  _buildRatingSold(product, getResponsiveSize(context, 1)),
                  _buildStockDelivery(product, formattedDate),
                  if (product.description != null &&
                      product.description!.isNotEmpty)
                    _buildSection(
                      title: "Deskripsi Produk",
                      content: product.description!,
                    ),
                  if (product.specification != null &&
                      product.specification!.isNotEmpty)
                    _buildSpecSection(product),
                  if (product.variation != null &&
                      product.variation!.isNotEmpty)
                    _buildVariationSection(product),
                  _buildQuantitySection(),
                  _buildReviewSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection(BuildContext context) {
    // Hitung rata-rata rating dari review
    double averageRating = reviews.isEmpty
        ? widget.product.rating
        : reviews.map((r) => r["rating"] as double).reduce((a, b) => a + b) /
              reviews.length;

    // Update product.rating jika sudah ada ulasan
    widget.product.rating = averageRating;

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ulasan Pembeli",
            style: GoogleFonts.patuaOne(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          // Rating Input
          RatingBar.builder(
            initialRating: _userRating,
            minRating: 0.5,
            allowHalfRating: true,
            itemSize: 28,
            glow: false,
            unratedColor: Colors.grey[300],
            itemPadding: const EdgeInsets.symmetric(horizontal: 2),
            itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              setState(() {
                _userRating = rating;
              });
            },
          ),
          if (_userRating > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Rating kamu: ${_userRating.toStringAsFixed(1)} ⭐",
                style: GoogleFonts.arvo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 183, 110, 0),
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Input Ulasan
          TextField(
            controller: _reviewController,
            decoration: InputDecoration(
              hintText: "Tulis ulasan kamu...",
              hintStyle: GoogleFonts.arvo(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 2,
          ),

          const SizedBox(height: 8),

          // Upload Foto/Video
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _pickMedia,
                icon: const Icon(Icons.upload),
                label: Text(
                  "Upload Foto/Video",
                  style: GoogleFonts.cinzel(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
              const SizedBox(width: 10),
              if (_isVideo &&
                  _videoController != null &&
                  _videoController!.value.isInitialized)
                SizedBox(
                  width: 80,
                  height: 80,
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                )
              else if (_webImageBytes != null)
                Image.memory(
                  _webImageBytes!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
              else if (_selectedMedia != null)
                !_isVideo
                    ? Image.file(
                        _selectedMedia!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.videocam, color: Colors.blue),
            ],
          ),

          const SizedBox(height: 10),

          // Tombol Kirim
          ElevatedButton.icon(
            onPressed: () {
              if (_reviewController.text.isEmpty) return;
              final user = FirebaseAuth.instance.currentUser;
              final username = user?.displayName ?? user?.email ?? "User";

              Uint8List? mediaBytes;
              if (kIsWeb && _isVideo && _webVideoUrl != null) {
                mediaBytes = _webImageBytes ?? Uint8List(0);
              }
              setState(() {
                reviews.insert(0, {
                  "name": username,
                  "rating": _userRating,
                  "comment": _reviewController.text,
                  "media": kIsWeb
                      ? (_isVideo ? mediaBytes : _webImageBytes)
                      : _selectedMedia,
                  "mediaUrl": kIsWeb ? (_isVideo ? _webVideoUrl : null) : null,
                  "isVideo": _isVideo,
                  "isWeb": kIsWeb,
                  "date": DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(DateTime.now()),
                });

                _reviewController.clear();
                _selectedMedia = null;
                _webImageBytes = null;
                _webVideoUrl = null;
                _isVideo = false;
                _videoController?.dispose();
                _videoController = null;
              });
            },
            icon: const Icon(Icons.send, color: Colors.white),
            label: Text(
              "Kirim Ulasan",
              style: GoogleFonts.cinzel(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const Divider(height: 30),

          // List Review
          reviews.isEmpty
              ? Center(
                  child: Text(
                    "Belum ada ulasan.",
                    style: GoogleFonts.arvo(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 25,
                    thickness: 0.8,
                    color: Colors.grey,
                  ),
                  itemBuilder: (_, i) {
                    final r = reviews[i];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            r["name"],
                            style: GoogleFonts.arvo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            r["date"],
                            style: GoogleFonts.arvo(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tampilkan bintang dan nilai rating
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: r["rating"],
                                itemBuilder: (context, _) =>
                                    const Icon(Icons.star, color: Colors.amber),
                                itemSize: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                r["rating"].toStringAsFixed(1),
                                style: GoogleFonts.arvo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            r["comment"],
                            style: const TextStyle(color: Colors.black87),
                          ),
                          if (r["media"] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: r["isVideo"]
                                  ? _buildReviewVideo(r)
                                  : (r["isWeb"]
                                        ? Image.memory(
                                            r["media"],
                                            height: 170,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            r["media"],
                                            height: 170,
                                            fit: BoxFit.cover,
                                          )),
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(getResponsiveSize(context, 16)),
      color: Colors.blue[900],
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              "Detail Produk",
              style: GoogleFonts.cinzel(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: getResponsiveSize(context, 40)),
        ],
      ),
    );
  }

  Widget _buildImageSection(Product product, BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: product.imageBytes != null
            ? Image.memory(
                product.imageBytes!,
                height: getResponsiveSize(context, 240),
                width: double.infinity,
                fit: BoxFit.contain,
              )
            : product.image.isNotEmpty
            ? Image.asset(
                product.image,
                height: getResponsiveSize(context, 240),
                width: double.infinity,
                fit: BoxFit.contain,
              )
            : const Icon(Icons.broken_image, size: 120),
      ),
    );
  }

  Widget _buildNamePrice(
    Product product,
    NumberFormat formatCurrency,
    double scale,
  ) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            product.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.youngSerif(
              fontSize: 26 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatCurrency.format(product.getFinalPrice()),
                style: GoogleFonts.patuaOne(
                  fontSize: 22 * scale,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              if (product.diskon > 0) ...[
                Text(
                  formatCurrency.format(product.price),
                  style: GoogleFonts.arvo(
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
                    style: GoogleFonts.arvo(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSold(Product product, double scale) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // RATING ATAS — TIDAK BISA DIGANTI
          RatingBarIndicator(
            rating: product.rating,
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 26,
            direction: Axis.horizontal,
          ),
          const SizedBox(width: 8),
          Text(
            product.rating.toStringAsFixed(1),
            style: GoogleFonts.arvo(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Container(height: 16, width: 1, color: Colors.grey[300]),
          const SizedBox(width: 13),
          Text(
            "Terjual ${product.sold}",
            style: GoogleFonts.arvo(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildStockDelivery(Product product, String formattedDate) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ketersediaan & Pengiriman",
            style: GoogleFonts.patuaOne(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.inventory_2, color: Colors.blue, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "Stok: ${product.stock} pcs",
                    style: GoogleFonts.arvo(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
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
                    "Tiba ${product.deliveryDays} hari ($formattedDate)",
                    style: GoogleFonts.arvo(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecSection(Product product) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Spesifikasi",
            style: GoogleFonts.patuaOne(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ...product.specification!.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "• $s",
                style: GoogleFonts.arvo(fontSize: 14, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariationSection(Product product) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Varian",
            style: GoogleFonts.patuaOne(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: product.variation!.entries.map((entry) {
              String kategori = entry.key;
              List<String> opsi = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      kategori,
                      style: GoogleFonts.arvo(
                        fontSize: 14,
                        color: Colors.black87,
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
    );
  }

  Widget _buildQuantitySection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Jumlah",
            style: GoogleFonts.patuaOne(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
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
                style: GoogleFonts.arvo(fontSize: 14, color: Colors.black87),
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
    );
  }

  Widget _buildBottomBar(BuildContext context, Product product) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    // --- Ukuran responsif ---
    final double buttonHeight = isMobile
        ? 48
        : isTablet
        ? 55
        : 60;
    final double baseFontSize = isMobile
        ? 14
        : isTablet
        ? 15
        : 16;
    final double iconSize = isMobile ? 20 : 22;
    final double spacing = isMobile ? 6 : 10;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing / 2),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- Tombol Chat ---
          Expanded(
            flex: 1,
            child: SizedBox(
              height: buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  );
                },
                icon: Icon(Icons.chat, color: Colors.blue, size: iconSize),
                label: Text(
                  "Chat",
                  style: GoogleFonts.cinzel(
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
                ),
              ),
            ),
          ),
          SizedBox(width: spacing),

          // Tombol Keranjang
          Expanded(
            flex: 1,
            child: SizedBox(
              height: buttonHeight,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.orange),
                  padding: EdgeInsets.symmetric(horizontal: 6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.orange,
                          size: iconSize,
                        ),
                        if (cartItems.isNotEmpty)
                          Positioned(
                            right: -8,
                            top: -6,
                            child: badges.Badge(
                              badgeContent: Text(
                                cartItems.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        "Keranjang",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cinzel(
                          fontSize: baseFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: spacing),

          // --- Tambah ke Keranjang ---
          Expanded(
            flex: 2,
            child: SizedBox(
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  if (product.variation != null &&
                      product.variation!.isNotEmpty &&
                      selectedVariations.length != product.variation!.length) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Harap pilih semua variasi terlebih dahulu!",
                        ),
                      ),
                    );
                    return;
                  }

                  cartItems.add(
                    CartItem(
                      product: product,
                      quantity: quantity,
                      selectedVariations: selectedVariations,
                    ),
                  );
                  setState(() {});

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "${product.name} ditambahkan ke keranjang ($quantity x)",
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Tambah ke Keranjang",
                  style: GoogleFonts.cinzel(
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: spacing),

          // --- Checkout Sekarang ---
          Expanded(
            flex: 2,
            child: SizedBox(
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  if (product.variation != null &&
                      product.variation!.isNotEmpty &&
                      selectedVariations.length != product.variation!.length) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Harap pilih variasi terlebih dahulu!"),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        items: [
                          CartItem(
                            product: product,
                            quantity: quantity,
                            selectedVariations: selectedVariations,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Checkout Sekarang",
                  style: GoogleFonts.cinzel(
                    fontSize: baseFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
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
            style: GoogleFonts.patuaOne(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GoogleFonts.arvo(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewVideo(Map<String, dynamic> r) {
    late VideoPlayerController controller;

    if (r["isWeb"]) {
      String? videoUrl = r["mediaUrl"];
      if (videoUrl == null || videoUrl.isEmpty) {
        final blob = html.Blob([r["media"]]);
        videoUrl = html.Url.createObjectUrlFromBlob(blob);
        r["mediaUrl"] = videoUrl;
      }
      controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    } else {
      controller = VideoPlayerController.file(r["media"]);
    }

    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // ambil ukuran layar
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          // tentukan tinggi responsif
          double videoHeight;
          if (screenWidth > 1000) {
            // Laptop / Desktop
            videoHeight = screenHeight * 0.45;
          } else if (screenWidth > 600) {
            // Tablet
            videoHeight = screenHeight * 0.35;
          } else {
            // HP
            videoHeight = screenHeight * 0.30;
          }

          // Batasi maksimal & minimal supaya tidak aneh di layar ekstrem
          videoHeight = videoHeight.clamp(150, 400);

          return Container(
            height: videoHeight,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
                IconButton(
                  icon: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
