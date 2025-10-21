import 'product.dart';

class Perak extends Product {
  double _kemurnianPerak;

  Perak({
    required super.id,
    required super.name,
    required super.diskon,
    required super.price,
    required super.image,
    required super.rating,
    required super.sold,
    required super.stock,
    required super.deliveryDays,
    double kemurnianPerak = 92.5,
    super.description,
    super.specification,
    super.variation,
  }) : _kemurnianPerak = kemurnianPerak;

  // Getter
  double get kemurnianPerak => _kemurnianPerak;
  String get productName => name;
  double get productPrice => price;
  double get productDiskon => diskon;
  double get finalPrice => price - (price * (diskon / 100));
  int get stockTersisa => stock;
  String get ringkasan =>
      "$name | Rp${finalPrice.toStringAsFixed(0)} (${diskon.toStringAsFixed(0)}% OFF)";

  // Setter
  set kemurnianPerak(double value) {
    if (value < 0 || value > 100) {
      throw ArgumentError("❌ Kemurnian perak harus 0–100%");
    }
    _kemurnianPerak = value;
  }

  set updateName(String newName) {
    if (newName.isNotEmpty) {
      name = newName;
    }
  }

  set updatePrice(double newPrice) {
    if (newPrice > 0) {
      price = newPrice;
    }
  }

  set updateDiskon(double newDiskon) {
    if (newDiskon >= 0 && newDiskon <= 100) {
      diskon = newDiskon;
    }
  }

  set updateStock(int newStock) {
    if (newStock >= 0) {
      stock = newStock;
    }
  }

  set updateKemurnian(double newKemurnian) {
    if (newKemurnian >= 0 && newKemurnian <= 100) {
      _kemurnianPerak = newKemurnian;
    } else {
      throw Exception("❌ Kemurnian perak harus antara 0–100%");
    }
  }

  // Method tambahan (Polymorphism)
  // Hitung harga berdasarkan kemurnian perak
  double getPriceByKemurnian() {
    return finalPrice * (_kemurnianPerak / 100);
  }

  // Cek apakah perak ini premium (misal: >= 90%)
  bool isPremium() {
    return _kemurnianPerak >= 90;
  }

  // Cek apakah kemurnian standar Sterling Silver 925
  bool isSterlingSilver() {
    return _kemurnianPerak >= 92.5 && _kemurnianPerak <= 93;
  }

  // Override polymorphism
  @override
  String getExtraInfo() {
    return "Kemurnian Perak: ${_kemurnianPerak.toStringAsFixed(2)}%";
  }

  // Override untuk memberi label khusus Perak
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
    rating: 5.0,
    sold: 120,
    stock: 40,
    deliveryDays: 3,
    description:
        "Kalung perak Brilliant hadir dengan desain modern yang simpel namun tetap menawan. "
        "Dibuat dari perak murni berkualitas tinggi, kalung ini memiliki kilau alami yang anggun "
        "serta ringan saat dipakai, cocok untuk aktivitas sehari-hari maupun acara kasual.",

    specification: [
      "Material: Perak Murni 925 (Sterling Silver)",
      "Warna: Silver Berkilau",
      "Finishing: Anti Tarnish (tidak mudah kusam)",
      "Kategori: Fashion Jewelry",
    ],

    variation: {
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
    rating: 4.0,
    sold: 85,
    stock: 55,
    deliveryDays: 3,
    description:
        "Anting perak Brilliant dirancang untuk Anda yang mengutamakan gaya praktis namun tetap elegan. "
        "Terbuat dari perak murni berkualitas tinggi dengan lapisan anti tarnish, nyaman dipakai sepanjang hari.",

    specification: [
      "Material: Perak Murni 925 (Sterling Silver)",
      "Warna: Silver Natural Berkilau",
      "Finishing: Halus & Anti Kusam",
      "Kategori: Fashion Jewelry",
    ],

    variation: {
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
    rating: 4.5,
    sold: 102,
    stock: 25,
    deliveryDays: 3,
    description:
        "Gelang perak Brilliant hadir dengan desain trendi yang memadukan kesederhanaan dan keanggunan. "
        "Terbuat dari perak murni 925 berkualitas tinggi, gelang ini ringan, nyaman, dan anti tarnish.",

    specification: [
      "Material: Perak Murni 925 (Sterling Silver)",
      "Warna: Silver Mengkilap Natural",
      "Finishing: Presisi & Anti Kusam",
      "Kategori: Fashion Jewelry",
    ],

    variation: {
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
    rating: 4.0,
    sold: 95,
    stock: 60,
    deliveryDays: 3,
    description:
        "Cincin perak Brilliant dirancang untuk Anda yang menyukai kesederhanaan dengan sentuhan elegan. "
        "Awet, nyaman dipakai, dan cocok untuk berbagai gaya mulai dari kasual hingga semi-formal.",

    specification: [
      "Material: Perak Murni 925 (Sterling Silver)",
      "Warna: Silver Natural Berkilau",
      "Finishing: Halus, Presisi, Anti Kusam",
      "Kategori: Fashion Jewelry & Daily Wear",
    ],

    variation: {
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
