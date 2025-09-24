import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/cart_page.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/models/emas.dart';
import 'package:flutter_application_1/models/perak.dart';
import 'package:flutter_application_1/models/berlian.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/screens/notification_page.dart';
import 'package:flutter_application_1/screens/profile_page.dart';
import 'category_page.dart';

class Category {
  final String name;
  final IconData icon;
  final List<Product> products;

  Category({required this.name, required this.icon, required this.products});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();

  late List<Product> _allProducts;
  late List<Product> _filteredProducts;

  int _selectedIndex = 0;
  String _selectedFilter = "All";

  List<Category> categories = [
    Category(name: "Emas", icon: Icons.circle, products: daftarEmas),
    Category(name: "Perak", icon: Icons.circle_outlined, products: daftarPerak),
    Category(name: "Berlian", icon: Icons.diamond, products: daftarBerlian),
  ];

  final List<String> _filters = [
    "All",
    "Diskon Terbesar",
    "Harga Termurah",
    "Trending",
  ];

  @override
  void initState() {
    super.initState();
    _allProducts = [...daftarEmas, ...daftarPerak, ...daftarBerlian];
    _filteredProducts = List.from(_allProducts);
  }

  void _applyFilters() {
    setState(() {
      List<Product> temp = List.from(_allProducts);

      // Filter sorting
      if (_selectedFilter == "Harga Termurah") {
        temp.sort((a, b) => a.price.compareTo(b.price));
      } else if (_selectedFilter == "Diskon Terbesar") {
        temp.sort((a, b) => b.diskon.compareTo(a.diskon));
      } else if (_selectedFilter == "Trending") {
        temp.sort((a, b) => b.sold.compareTo(a.sold));
      }

      // Pencarian
      final query = _searchController.text.toLowerCase();
      if (query.isNotEmpty) {
        temp = temp.where((p) {
          return p.name.toLowerCase().contains(query) ||
              p.price.toString().contains(query) ||
              p.diskon.toString().contains(query);
        }).toList();
      }

      _filteredProducts = temp;
    });
  }

  // Tambah & Edit Kategori
  void _showCategoryDialog({Category? category, int? index}) {
    final nameController = TextEditingController(text: category?.name ?? "");
    IconData selectedIcon = category?.icon ?? Icons.circle;

    // daftar pilihan ikon
    final availableIcons = [
      Icons.circle,
      Icons.circle_outlined,
      Icons.diamond,
      Icons.star,
    ];

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                category == null ? "Tambah Kategori" : "Edit Kategori",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Kategori",
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<IconData>(
                    value: availableIcons.contains(selectedIcon)
                        ? selectedIcon
                        : availableIcons.first,
                    items: availableIcons
                        .map(
                          (ic) => DropdownMenuItem(
                            value: ic,
                            child: Row(
                              children: [
                                Icon(ic),
                                const SizedBox(width: 8),
                                Text(
                                  ic.toString().replaceAll('IconData(U+', ''),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setStateDialog(() => selectedIcon = val);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newCategory = Category(
                      name: nameController.text,
                      icon: selectedIcon,
                      products: category?.products ?? [],
                    );

                    setState(() {
                      if (category == null) {
                        categories.add(newCategory);
                      } else if (index != null) {
                        categories[index] = newCategory;
                      }
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Hapus Kategori
  void _deleteCategory(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Kategori"),
        content: Text('Yakin menghapus kategori "${categories[index].name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                categories.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        title: const Text("Home", style: TextStyle(color: Colors.white)),
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

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  "Selamat Datang 👋",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user?.email ?? "User",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 16),
              ],
            ),

            // Search bar
            TextField(
              controller: _searchController,
              onChanged: (_) => _applyFilters(),
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.blue),
                  onPressed: () => _applyFilters(),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 178, 224, 243),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter kategori
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final bool isSelected = f == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          _selectedFilter = f;
                          _applyFilters();
                        });
                      },
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child:
                  ((_searchController.text.isNotEmpty ||
                      _selectedFilter != "All")
                  ? (_filteredProducts.isEmpty
                        ? const Center(child: Text("Produk tidak ditemukan"))
                        : GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.65,
                                ),
                            padding: const EdgeInsets.all(12),
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final p = _filteredProducts[index];
                              return SizedBox(
                                width: 220,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.asset(
                                              p.image,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return const Icon(
                                                      Icons.broken_image,
                                                      size: 80,
                                                    );
                                                  },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          p.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "Rp ${p.price.toStringAsFixed(0)}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          "Diskon ${p.diskon}%",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              p.rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "Terjual ${p.sold}",
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ))
                  : ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Card(
                                color: const Color.fromARGB(255, 178, 224, 243),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: Icon(cat.icon, color: Colors.blue),
                                  title: Text(
                                    cat.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            CategoryPage(category: cat),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _showCategoryDialog(
                                    category: cat,
                                    index: index,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteCategory(index),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    )),
            ),
          ],
        ),
      ),

      // FloatingActionButton untuk tambah kategori
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.category),
                    title: const Text("Tambah Kategori"),
                    onTap: () {
                      Navigator.pop(context);
                      _showCategoryDialog();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

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
              MaterialPageRoute(builder: (_) => ProfilePage(user: user)),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationPage()),
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
