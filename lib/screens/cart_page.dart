import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/category_page.dart';
import 'package:flutter_application_1/screens/checkout_page.dart';
import 'package:badges/badges.dart' as badges;
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Set<int> selectedItems = {};

  // Fungsi helper untuk format rupiah
  String _formatRupiah(double value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(value);
  }

  void _increaseQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      } else {
        cartItems.removeAt(index);
        selectedItems.remove(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
      selectedItems.remove(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Produk dihapus dari keranjang"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  double _calculateTotal() {
    double total = 0;
    for (var i in selectedItems) {
      if (i < cartItems.length) {
        total += cartItems[i].product.getFinalPrice() * cartItems[i].quantity;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Keranjang Belanja",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          badges.Badge(
            showBadge: cartItems.isNotEmpty,
            position: badges.BadgePosition.topEnd(top: 0, end: 3),
            badgeAnimation: badges.BadgeAnimation.slide(
              toAnimate: true,
              curve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
            ),
            badgeContent: Text(
              "${cartItems.length}",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                // Aksi kalau ikon keranjang ditekan
              },
            ),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Keranjang kosong"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final product = item.product;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Kotak checkbox di kiri
                            Checkbox(
                              value: selectedItems.contains(index),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedItems.add(index);
                                  } else {
                                    selectedItems.remove(index);
                                  }
                                });
                              },
                            ),
                            Expanded(
                              child: ListTile(
                                leading: product.image.isNotEmpty
                                    ? (product.image.startsWith("assets/")
                                          ? Image.asset(
                                              product.image,
                                              width: 50,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.memory(
                                              product.imageBytes!,
                                              width: 50,
                                              fit: BoxFit.cover,
                                            ))
                                    : const Icon(Icons.shopping_bag),
                                title: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (item.selectedVariations != null &&
                                        item.selectedVariations!.isNotEmpty)
                                      ...item.selectedVariations!.entries.map(
                                        (e) => Text("${e.key}: ${e.value}"),
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatRupiah(product.getFinalPrice()),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),

                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                      onPressed: () => _decreaseQuantity(index),
                                    ),
                                    Text(
                                      "${item.quantity}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      onPressed: () => _increaseQuantity(index),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Tombol delete
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeItem(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bagian total + tombol checkout
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total (${selectedItems.length} item)"),
                          const SizedBox(height: 4),
                          Text(
                            _formatRupiah(_calculateTotal()),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: selectedItems.isEmpty
                            ? null
                            : () {
                                // Kirim produk terpilih ke CheckoutPage
                                final selectedProducts = selectedItems
                                    .map((i) => cartItems[i])
                                    .toList();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutPage(
                                      items:
                                          selectedProducts, // list produk yang dipilih
                                    ),
                                  ),
                                );
                              },
                        child: const Text(
                          "Checkout",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
