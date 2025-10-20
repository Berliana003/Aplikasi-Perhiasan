import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/order.dart';
import 'package:flutter_application_1/models/order_history.dart';
import 'package:flutter_application_1/models/cart_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'address_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> items;

  const CheckoutPage({super.key, required this.items});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? selectedAddress;
  String selectedPayment = "Transfer Bank";

  final List<String> paymentMethods = [
    "Transfer Bank",
    "E-Wallet (OVO, Dana, GoPay)",
    "COD (Bayar di Tempat)",
    "Kartu Kredit/Debit",
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedAddress();
  }

  /// Ambil alamat terakhir yang disimpan di SharedPreferences
  Future<void> _loadSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final address = prefs.getString('selected_address');
    setState(() {
      selectedAddress = address;
    });
  }

  // Navigasi ke halaman pilih alamat
  Future<void> _chooseAddress() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddressPage()),
    );
    _loadSelectedAddress(); // refresh setelah kembali
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    double subtotal = widget.items.fold(
      0,
      (sum, item) => sum + (item.product.getFinalPrice() * item.quantity),
    );
    double shipping = 20000;
    double total = subtotal + shipping;

    // Format alamat
    final addressParts = selectedAddress?.split('|') ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Checkout",
          style: GoogleFonts.cinzel(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daftar Produk
            ...widget.items.map((item) {
              final product = item.product;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      product.image.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                product.image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            )
                          : const Icon(Icons.image, size: 80),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: GoogleFonts.youngSerif(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Jumlah: ${item.quantity}",
                              style: GoogleFonts.arvo(fontSize: 14),
                            ),
                            Text(
                              "Stok tersisa: ${product.stock}",
                              style: GoogleFonts.arvo(fontSize: 14),
                            ),
                            Text(
                              "Estimasi tiba: ${product.deliveryDays} hari",
                              style: GoogleFonts.arvo(fontSize: 14),
                            ),
                            Text(
                              formatCurrency.format(
                                product.getFinalPrice() * item.quantity,
                              ),
                              style: GoogleFonts.arvo(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (item.selectedVariations != null &&
                      item.selectedVariations!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: item.selectedVariations!.entries
                            .map(
                              (e) => Text(
                                "${e.key}: ${e.value}",
                                style: GoogleFonts.arvo(fontSize: 14),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  const Divider(),
                ],
              );
            }).toList(),

            const SizedBox(height: 10),

            // Alamat Pengiriman
            Text(
              "Alamat Pengiriman",
              style: GoogleFonts.patuaOne(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            if (selectedAddress != null && selectedAddress!.isNotEmpty)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    addressParts.isNotEmpty ? addressParts[0] : "",
                    style: GoogleFonts.arvo(fontSize: 14),
                  ),
                  subtitle: Text(
                    addressParts.length > 1
                        ? addressParts.sublist(1).join("\n")
                        : "",
                    style: GoogleFonts.arvo(fontSize: 14),
                  ),
                  trailing: TextButton(
                    onPressed: _chooseAddress,
                    child: Text("Ubah", style: GoogleFonts.arvo(fontSize: 14)),
                  ),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: _chooseAddress,
                icon: const Icon(Icons.add_location_alt),
                label: Text(
                  "Pilih Alamat Pengiriman",
                  style: GoogleFonts.arvo(fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Metode Pembayaran
            Text(
              "Metode Pembayaran",
              style: GoogleFonts.patuaOne(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedPayment,
              items: paymentMethods
                  .map(
                    (method) => DropdownMenuItem(
                      value: method,
                      child: Text(
                        method,
                        style: GoogleFonts.arvo(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => selectedPayment = val);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Divider(height: 32),

            // Rincian Pembayaran
            Text(
              "Rincian Pembayaran",
              style: GoogleFonts.patuaOne(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subtotal", style: GoogleFonts.arvo(fontSize: 14)),
                Text(
                  formatCurrency.format(subtotal),
                  style: GoogleFonts.arvo(fontSize: 14),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ongkos Kirim", style: GoogleFonts.arvo(fontSize: 14)),
                Text(
                  formatCurrency.format(shipping),
                  style: GoogleFonts.arvo(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: GoogleFonts.patuaOne(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatCurrency.format(total),
                  style: GoogleFonts.arvo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Icon(Icons.verified, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Garansi Tiba: Pesanan dijamin sampai atau uang kembali.",
                    style: GoogleFonts.arvo(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Checkout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedAddress == null || selectedAddress!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Harap pilih alamat pengiriman terlebih dahulu!",
                        ),
                      ),
                    );
                    return;
                  }

                  // Validasi variasi produk
                  for (var item in widget.items) {
                    if (item.selectedVariations == null ||
                        item.selectedVariations!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Harap pilih variasi untuk produk ${item.product.name}!",
                          ),
                        ),
                      );
                      return;
                    }
                  }

                  // Simpan pesanan ke riwayat
                  for (var item in widget.items) {
                    final order = Order(
                      product: item.product,
                      quantity: item.quantity,
                      address: selectedAddress!,
                      paymentMethod: selectedPayment,
                      total: item.product.getFinalPrice() * item.quantity,
                      date: DateTime.now(),
                    );
                    OrderHistory.addOrder(order);
                  }

                  // Dialog sukses
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                        "Berhasil Checkout",
                        style: GoogleFonts.youngSerif(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        "Pesanan Anda sudah dibuat.\nTotal: ${formatCurrency.format(total)}",
                        style: GoogleFonts.arvo(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "OK",
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
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
                child: Text(
                  "Bayar Sekarang",
                  style: GoogleFonts.cinzel(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
