import 'product.dart';

class Perak extends Product {
  Perak({
    required String id,
    required String name,
    required double diskon,
    required double price,
    required String image,
    required double rating,
    required int sold,
    required int stock,
    required int deliveryDays,
    String? description,
    List<String>? specs,
    Map<String, List<String>>? variations,
  }) : super(
         id: id,
         name: name,
         diskon: diskon,
         price: price,
         image: image,
         rating: rating,
         sold: sold,
         stock: stock,
         deliveryDays: deliveryDays,
         description: description,
         specs: specs,
         variations: variations,
       );

  /// Override untuk memberi label khusus Perak
  @override
  String toString() {
    return "🤍 Perak: ${super.toString()}";
  }
}

// Contoh daftar produk perak
List<Perak> daftarPerak = [
  Perak(
    id: "P1",
    name: "🌙 Kalung Perak Brilliant 🌙",
    diskon: 2,
    price: 600000,
    image: "assets/image/kalung_perak.jpg",
    rating: 4.5,
    sold: 120,
    stock: 40,
    deliveryDays: 3,
    description:
        "Kalung perak Brilliant hadir dengan desain modern yang simpel namun tetap menawan. "
        "Dibuat dari perak murni berkualitas tinggi, kalung ini memiliki kilau alami yang anggun "
        "serta ringan saat dipakai, cocok untuk aktivitas sehari-hari maupun acara kasual.",

    specs: [
      "Material: Perak Murni 925 (Sterling Silver)",
      "Warna: Silver Berkilau",
      "Finishing: Anti Tarnish (tidak mudah kusam)",
      "Kategori: Fashion Jewelry",
    ],

    variations: {
      "Panjang": ["40 cm", "45 cm", "50 cm"],
      "Model": ["Rantai Polos", "Box Chain", "Rope Chain", "Pendant Minimalis"],
      "Berat": ["2 gr", "3 gr", "5 gr"],
    },
  ),
  Perak(
    id: "P2",
    name: "✨ Anting Perak Brilliant ✨",
    diskon: 0,
    price: 525000,
    image: "assets/image/anting_perak.jpg",
    rating: 4.3,
    sold: 85,
    stock: 55,
    deliveryDays: 3,
    description:
        "Anting perak Brilliant dirancang untuk Anda yang mengutamakan gaya praktis namun tetap elegan. "
        "Terbuat dari perak murni berkualitas tinggi dengan lapisan anti tarnish, nyaman dipakai sepanjang hari.",

    specs: [
      "Material: Perak Murni 925 (Sterling Silver)",
      "Warna: Silver Natural Berkilau",
      "Finishing: Halus & Anti Kusam",
      "Kategori: Fashion Jewelry",
    ],

    variations: {
      "Bentuk": ["Stud", "Hoop", "Drop", "Geometris"],
      "Berat": ["1 gr", "2 gr", "3 gr"],
      "Detail": ["Polos", "Bermotif", "Dihiasi Zircon/Permata Sintetis"],
    },
  ),
  Perak(
    id: "P3",
    name: "🌟 Gelang Perak Brilliant 🌟",
    diskon: 3,
    price: 800000,
    image: "assets/image/gelang_perak.jpg",
    rating: 4.6,
    sold: 102,
    stock: 25,
    deliveryDays: 3,
    description:
        "Gelang perak Brilliant hadir dengan desain trendi yang memadukan kesederhanaan dan keanggunan. "
        "Terbuat dari perak murni 925 berkualitas tinggi, gelang ini ringan, nyaman, dan anti tarnish.",

    specs: [
      "Material: Perak Murni 925 (Sterling Silver)",
      "Warna: Silver Mengkilap Natural",
      "Finishing: Presisi & Anti Kusam",
      "Kategori: Fashion Jewelry",
    ],

    variations: {
      "Panjang": ["16 cm", "18 cm", "20 cm"],
      "Berat": ["3 gr", "5 gr", "7 gr"],
      "Model": ["Rantai Polos", "Rope Chain", "Box Chain", "Charm Bracelet"],
    },
  ),
  Perak(
    id: "P4",
    name: "💍 Cincin Perak Brilliant 💍",
    diskon: 5,
    price: 600000,
    image: "assets/image/cincin_perak.jpg",
    rating: 4.7,
    sold: 95,
    stock: 60,
    deliveryDays: 3,
    description:
        "Cincin perak Brilliant dirancang untuk Anda yang menyukai kesederhanaan dengan sentuhan elegan. "
        "Awet, nyaman dipakai, dan cocok untuk berbagai gaya mulai dari kasual hingga semi-formal.",

    specs: [
      "Material: Perak Murni 925 (Sterling Silver)",
      "Warna: Silver Natural Berkilau",
      "Finishing: Halus, Presisi, Anti Kusam",
      "Kategori: Fashion Jewelry & Daily Wear",
    ],

    variations: {
      "Ukuran": ["10", "12", "14", "16", "18"],
      "Berat": ["2 gr", "3 gr", "5 gr"],
      "Model": [
        "Polos",
        "Bermotif",
        "Geometris",
        "Dengan Zircon/Permata Sintetis",
      ],
    },
  ),
];
