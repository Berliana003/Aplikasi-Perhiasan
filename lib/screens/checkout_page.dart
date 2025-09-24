import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/order.dart';
import 'package:flutter_application_1/models/order_history.dart';
import 'package:flutter_application_1/models/cart_item.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> items;

  const CheckoutPage({super.key, required this.items});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String address = "";
  String selectedPayment = "Transfer Bank";

  final List<String> paymentMethods = [
    "Transfer Bank",
    "E-Wallet (OVO, Dana, GoPay)",
    "COD (Bayar di Tempat)",
    "Kartu Kredit/Debit",
  ];

  @override
  Widget build(BuildContext context) {
    // hitung subtotal semua produk terpilih
    double subtotal = widget.items.fold(
      0,
      (sum, item) => sum + (item.product.getFinalPrice() * item.quantity),
    );
    double shipping = 20000;
    double total = subtotal + shipping;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi Produk (bisa 1 atau banyak)
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
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Jumlah: ${item.quantity}"),
                            Text("Stok tersisa: ${product.stock}"),
                            Text("Estimasi tiba: ${product.deliveryDays} hari"),
                            Text(
                              "Rp ${(product.getFinalPrice() * item.quantity).toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
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
                            .map((e) => Text("${e.key}: ${e.value}"))
                            .toList(),
                      ),
                    ),
                  const Divider(),
                ],
              );
            }).toList(),

            const SizedBox(height: 10),

            // Alamat
            const Text(
              "Alamat Pengiriman",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (val) => setState(() => address = val),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Masukkan alamat lengkap...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Metode Pembayaran
            const Text(
              "Metode Pembayaran",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedPayment,
              items: paymentMethods
                  .map(
                    (method) =>
                        DropdownMenuItem(value: method, child: Text(method)),
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

            // Rincian
            const Text(
              "Rincian Pembayaran",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal"),
                Text("Rp ${subtotal.toStringAsFixed(0)}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ongkos Kirim"),
                Text("Rp ${shipping.toStringAsFixed(0)}"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Rp ${total.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Garansi
            Row(
              children: const [
                Icon(Icons.verified, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Garansi Tiba: Pesanan dijamin sampai atau uang kembali.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
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
                  if (address.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Harap isi alamat pengiriman!"),
                      ),
                    );
                    return;
                  }

                  // Cek apakah ada produk yang belum pilih variasi
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
                      return; // stop checkout
                    }
                  }

                  // Kalau semua variasi sudah dipilih → simpan order
                  for (var item in widget.items) {
                    final order = Order(
                      product: item.product,
                      quantity: item.quantity,
                      address: address,
                      paymentMethod: selectedPayment,
                      total: item.product.getFinalPrice() * item.quantity,
                      date: DateTime.now(),
                    );
                    OrderHistory.addOrder(order);
                  }

                  // Munculkan dialog sukses
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Berhasil Checkout"),
                      content: Text(
                        "Pesanan Anda sudah dibuat.\nTotal: Rp ${total.toStringAsFixed(0)}",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
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
                child: const Text(
                  "Bayar Sekarang",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
