import 'product.dart';

class Berlian extends Product {
  double _karatBerlian;
  Berlian({
    required super.id,
    required super.name,
    required super.diskon,
    required super.price,
    required super.image,
    required super.rating,
    required super.sold,
    required super.stock,
    required super.deliveryDays,
    required super.description,
    required super.specification,
    required super.variation,
    double karatBerlian = 0.25,
  }) : _karatBerlian = karatBerlian;

  // Getter
  double get karatBerlian => _karatBerlian;

  // Mengambil harga setelah diskon
  double get finalPrice => price - (price * (diskon / 100));

  // Ambil info singkat produk
  String get shortInfo => "$name - Rp$price (Diskon: $diskon%)";

  // Ambil status stok
  String get stockStatus => stock > 0 ? "Tersedia ($stock)" : "Habis";

  // Setter
  set karatBerlian(double value) {
    if (value > 0) {
      _karatBerlian = value;
    } else {
      throw Exception("❌ Karat berlian harus lebih dari 0");
    }
  }

  set updatePrice(double newPrice) {
    if (newPrice > 0) {
      price = newPrice;
    } else {
      throw Exception("Harga tidak boleh 0 atau negatif!");
    }
  }

  set updateDiskon(double newDiskon) {
    if (newDiskon >= 0 && newDiskon <= 100) {
      diskon = newDiskon;
    } else {
      throw Exception("Diskon harus antara 0–100%");
    }
  }

  set updateStock(int newStock) {
    if (newStock >= 0) {
      stock = newStock;
    } else {
      throw Exception("Stok tidak boleh negatif!");
    }
  }

  set updateName(String newName) {
    if (newName.isNotEmpty) {
      name = newName;
    } else {
      throw Exception("Nama produk tidak boleh kosong!");
    }
  }

  set updateKarat(double newKarat) {
    if (newKarat > 0)
      _karatBerlian = newKarat;
    else
      throw Exception("❌ Karat berlian harus positif!");
  }

  // Method Tambahan Polymorphism
  // Hitung harga berdasarkan karat berlian (misalnya setiap karat punya nilai tambahan)
  double getPriceByKarat() {
    const hargaPerKarat = 50000000; // contoh nilai tambah per karat
    return finalPrice + (_karatBerlian * hargaPerKarat);
  }

  // Cek apakah karat tergolong premium
  bool isPremium() {
    return _karatBerlian >= 1.0; // ≥ 1 karat dianggap premium
  }

  // Cek apakah karat kecil (perhiasan ringan)
  bool isMiniDiamond() {
    return _karatBerlian < 0.25;
  }

  // Override polymorphism untuk ProductDetailPage
  @override
  String getExtraInfo() {
    return "Karat Berlian: ${_karatBerlian.toStringAsFixed(2)} ct";
  }

  // Override method untuk menambahkan ikon khusus Berlian
  @override
  String toString() {
    return "💎 Berlian: ${super.toString()} | Final Price: Rp$finalPrice | Status: $stockStatus";
  }
}

// Contoh daftar produk berlian
List<Berlian> daftarBerlian = [
  Berlian(
    id: "B1",
    name: "💎 Kalung Berlian Brilliant 💎",
    diskon: 10,
    price: 120000000,
    image: "assets/image/kalung_berlian.jpg",
    rating: 5.0,
    sold: 120,
    stock: 20,
    deliveryDays: 3,

    description:
        "Kalung berlian ini menghadirkan simbol keanggunan dan prestise, "
        "dirancang dengan detail sempurna menggunakan berlian asli pilihan serta material emas berkualitas. "
        "Setiap kilau berlian memberikan cahaya yang memikat, menjadikannya perhiasan istimewa untuk momen-momen berharga. "
        "Kalung Berlian Brilliant bukan hanya perhiasan, melainkan warisan kemewahan yang bernilai tinggi "
        "serta simbol cinta yang tak lekang oleh waktu.",

    specification: [
      "Material: Emas Asli + Berlian Murni (sertifikat keaslian disertakan)",
      "Warna: Emas Kuning / Emas Putih",
      "Finishing: Presisi & Premium",
      "Kategori: Fine Jewelry",
    ],

    variation: {
      "Panjang Kalung": ["40 cm", "45 cm", "50 cm"],
      "Desain": [
        "Solitaire Diamond",
        "Halo Pendant",
        "Heart Shape",
        "Modern Classic",
      ],
    },
  ),
  Berlian(
    id: "B2",
    name: "💍 Cincin Berlian Brilliant 💍",
    diskon: 8,
    price: 9600000,
    image: "assets/image/cincin_berlian.jpg",
    rating: 4.5,
    sold: 95,
    stock: 10,
    deliveryDays: 3,

    description:
        "Didesain dengan keindahan yang tak lekang oleh waktu, cincin berlian Brilliant "
        "memadukan kemurnian berlian asli dengan material emas berkualitas tinggi. "
        "Setiap potongan berlian dipasang dengan detail presisi, menghasilkan kilau yang memikat hati. "
        "Sangat cocok untuk momen berharga seperti pertunangan, pernikahan, maupun hadiah istimewa. "
        "Cincin Berlian Brilliant bukan sekadar perhiasan, melainkan simbol cinta sejati "
        "yang akan selalu bersinar sepanjang masa.",

    specification: [
      "Material: Emas Asli + Berlian Murni (sertifikat keaslian disertakan)",
      "Warna: Emas Putih / Emas Kuning",
      "Potongan Berlian: Round Cut | Princess Cut | Oval | Cushion",
      "Kategori: Engagement Ring & Fine Jewelry",
    ],

    variation: {
      "Berat Emas": ["2 gr", "3 gr", "5 gr"],
      "Model": ["Solitaire", "Three-Stone", "Halo", "Eternity"],
    },
  ),
  Berlian(
    id: "B3",
    name: "✨ Gelang Berlian Brilliant ✨",
    diskon: 9,
    price: 83600000,
    image: "assets/image/gelang_berlian.jpg",
    rating: 4.0,
    sold: 77,
    stock: 8,
    deliveryDays: 3,

    description:
        "Gelang berlian ini dirancang untuk menghadirkan kilau istimewa yang memancarkan "
        "pesona elegan. Terbuat dari emas berkualitas tinggi dengan taburan berlian asli pilihan, "
        "gelang ini tidak hanya memperindah penampilan, tetapi juga mencerminkan kemewahan yang berkelas. "
        "Gelang Berlian Brilliant adalah simbol keanggunan dan prestise, pilihan sempurna untuk hadiah berharga "
        "maupun koleksi pribadi yang bernilai tinggi.",

    specification: [
      "Material: Emas Asli + Berlian Murni (dilengkapi sertifikat keaslian)",
      "Warna: Emas Putih / Emas Kuning",
      "Finishing: Presisi, Nyaman Dipakai",
      "Kategori: Fine Jewelry & Luxury Collection",
    ],

    variation: {
      "Panjang Gelang": ["16 cm", "18 cm", "20 cm"],
      "Model": ["Tennis Bracelet", "Charm Diamond", "Classic Chain"],
    },
  ),
  Berlian(
    id: "B4",
    name: "🌟 Anting Berlian Brilliant 🌟",
    diskon: 6,
    price: 7000000,
    image: "assets/image/anting_berlian.jpg",
    rating: 4.0,
    sold: 64,
    stock: 12,
    deliveryDays: 3,

    description:
        "Anting berlian Brilliant dirancang untuk menghadirkan pesona memikat yang "
        "menyempurnakan keanggunan wajah. Dengan taburan berlian asli berkualitas tinggi "
        "dan material emas premium, setiap detailnya memberikan kilau mewah yang elegan "
        "namun tetap nyaman dipakai sepanjang hari. Anting Berlian Brilliant adalah "
        "perhiasan istimewa yang memadukan kenyamanan dengan kemewahan, menjadikannya "
        "pilihan sempurna untuk hadiah berkelas maupun koleksi pribadi.",

    specification: [
      "Material: Emas Asli + Berlian Murni (sertifikat keaslian disertakan)",
      "Warna: Emas Putih / Emas Kuning",
      "Desain: Ringan, Elegan, & Modern",
      "Kategori: Luxury Daily Wear & Fine Jewelry",
    ],

    variation: {
      "Bentuk": ["Stud", "Hoop", "Drop", "Cluster"],
      "Detail": ["Polos", "Solitaire", "Halo Design"],
    },
  ),
];
