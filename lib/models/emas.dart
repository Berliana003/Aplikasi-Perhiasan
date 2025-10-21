import 'product.dart';

class Emas extends Product {
  double _kadarEmas;
  Emas({
    required super.id,
    required super.name,
    required super.diskon,
    required super.price,
    required super.image,
    required super.rating,
    required super.sold,
    required super.stock,
    required super.deliveryDays,
    double kadarEmas = 99.99,
    super.description,
    super.specification,
    super.variation,
  }) : _kadarEmas = kadarEmas;

  // Getter
  double get kadarEmas => _kadarEmas;

  // Hitung harga setelah diskon
  double get finalPrice => price - (price * (diskon / 100));

  // Informasi singkat produk
  String get shortInfo => "$name - Rp$price (Diskon: $diskon%)";

  // Status stok
  String get stockStatus => stock > 0 ? "Tersedia ($stock)" : "Habis";

  // Setter
  set kadarEmas(double value) {
    if (value < 0 || value > 100) {
      throw ArgumentError("❌ Kadar emas harus antara 0–100%");
    }
    _kadarEmas = value;
  }

  set updatePrice(double newPrice) {
    if (newPrice > 0) {
      price = newPrice;
    } else {
      throw Exception("❌ Harga emas tidak boleh 0 atau negatif!");
    }
  }

  set updateDiskon(double newDiskon) {
    if (newDiskon >= 0 && newDiskon <= 100) {
      diskon = newDiskon;
    } else {
      throw Exception("❌ Diskon harus antara 0–100%");
    }
  }

  set updateStock(int newStock) {
    if (newStock >= 0) {
      stock = newStock;
    } else {
      throw Exception("❌ Stok tidak boleh negatif!");
    }
  }

  set updateName(String newName) {
    if (newName.isNotEmpty) {
      name = newName;
    } else {
      throw Exception("❌ Nama produk tidak boleh kosong!");
    }
  }

  set updateKadar(double newKadar) {
    if (newKadar >= 0 && newKadar <= 100) {
      _kadarEmas = newKadar;
    } else {
      throw Exception("❌ Kadar emas harus antara 0–100%");
    }
  }

  // Hitung harga sebenarnya berdasarkan kadar emas
  double getPriceByKadar() {
    return finalPrice * (_kadarEmas / 100);
  }

  /// Cek apakah kadar emas tinggi (misalnya > 90%)
  bool isKadarPremium() {
    return _kadarEmas >= 90;
  }

  /// Cek apakah kadar emas murni (>= 99.99%)
  bool isMurni() {
    return _kadarEmas >= 99.9;
  }

  // Override untuk memberi label khusus emas
  @override
  String toString() {
    return "💛 Emas: ${super.toString()}";
  }
}

// Contoh daftar produk emas
List<Emas> daftarEmas = [
  Emas(
    id: "E1",
    name: "✨ Kalung Emas Brilliant ✨",
    diskon: 5,
    price: 3900000,
    image: "assets/image/kalung_emas.jpg",
    rating: 5.0,
    sold: 150,
    stock: 20,
    deliveryDays: 3,

    description:
        "Kalung emas elegan dengan desain modern dan timeless, terbuat dari emas asli berkualitas tinggi. "
        "Kilau mewahnya tahan lama dan cocok digunakan untuk acara formal maupun sehari-hari. "
        "Dibuat dengan detail presisi dan finishing yang halus, kalung emas Brilliant memberikan sentuhan kemewahan pada setiap penampilan Anda.",

    specification: [
      "Material: Emas Asli (dengan sertifikat keaslian)",
      "Warna: Emas Kuning Berkilau",
      "Desain: Simple & Elegan",
      "Cocok untuk: Hadiah, koleksi pribadi, maupun investasi",
    ],

    variation: {
      "Panjang": ["40 cm", "45 cm", "50 cm"],
      "Berat": ["2 gram", "3 gram", "5 gram"],
      "Model": ["Rantai Polos", "Rantai Box", "Rantai Tali (Rope)"],
    },
  ),
  Emas(
    id: "E2",
    name: "💍 Cincin Emas Brilliant 💍",
    diskon: 0,
    price: 1600000,
    image: "assets/image/cincin_emas.jpg",
    rating: 4.5,
    sold: 98,
    stock: 35,
    deliveryDays: 3,

    description:
        "Cincin emas elegan dengan desain modern yang memancarkan kilau mewah. "
        "Dibuat dari emas asli berkualitas tinggi, cincin ini nyaman dipakai dan cocok untuk berbagai momen spesial, "
        "mulai dari pertunangan, pernikahan, hingga hadiah istimewa. Dengan detail presisi dan finishing halus, "
        "cincin emas Brilliant menjadi simbol keindahan, cinta, dan nilai investasi jangka panjang.",

    specification: [
      "Material: Emas Asli (dengan sertifikat keaslian)",
      "Warna: Emas Kuning Berkilau",
      "Desain: Minimalis & Elegan",
      "Cocok untuk: Pernikahan, pertunangan, hadiah, maupun koleksi pribadi",
    ],

    variation: {
      "Berat": ["2 gram", "3 gram", "5 gram"],
      "Ukuran": ["10", "12", "14", "16", "18"],
      "Model": ["Polos", "Bermotif", "Berhias Zircon/Permata"],
    },
  ),
  Emas(
    id: "E3",
    name: "✨ Gelang Emas Brilliant ✨",
    diskon: 3,
    price: 5000000,
    image: "assets/image/gelang_emas.jpg",
    rating: 4.0,
    sold: 87,
    stock: 15,
    deliveryDays: 3,

    description:
        "Tampilkan pesona yang anggun dengan Gelang Emas Brilliant. "
        "Dibuat dari emas asli berkualitas tinggi, gelang ini memiliki kilau alami yang mewah serta desain yang trendi. "
        "Ringan, nyaman, dan tahan lama, cocok dipakai sehari-hari maupun melengkapi gaya di acara spesial. "
        "Gelang Emas Brilliant tidak hanya mempercantik penampilan, tetapi juga menghadirkan kesan elegan yang bertahan sepanjang waktu.",

    specification: [
      "Material: Emas Asli (sertifikat keaslian disertakan)",
      "Warna: Emas Kuning Berkilau",
      "Finishing: Halus & Presisi",
      "Kategori: Fashion Jewelry sekaligus Investasi",
    ],

    variation: {
      "Panjang": ["16 cm", "18 cm", "20 cm"],
      "Berat": ["3 gr", "5 gr", "7 gr"],
      "Model": ["Rantai Klasik", "Box Chain", "Rope Chain", "Gelang Charm"],
    },
  ),
  Emas(
    id: "E4",
    name: "🌸 Anting Emas Brilliant 🌸",
    diskon: 0,
    price: 1200000,
    image: "assets/image/anting_emas.jpg",
    rating: 4.0,
    sold: 72,
    stock: 25,
    deliveryDays: 3,

    description:
        "Anting emas ini dirancang khusus untuk memberikan sentuhan manis sekaligus mewah pada penampilan Anda. "
        "Terbuat dari emas asli berkualitas tinggi, anting emas Brilliant menghadirkan kilau elegan yang tidak berlebihan, "
        "sehingga nyaman dipakai sehari-hari maupun pada acara spesial. "
        "Dengan desain menawan yang menyesuaikan gaya modern maupun klasik, "
        "Anting Emas Brilliant menjadi pilihan sempurna untuk melengkapi koleksi perhiasan Anda.",

    specification: [
      "Material: Emas Asli (dilengkapi sertifikat keaslian)",
      "Warna: Emas Kuning Mengkilap",
      "Desain: Ringan, Nyaman, & Stylish",
      "Kategori: Daily Wear & Special Occasion",
    ],

    variation: {
      "Bentuk": ["Stud", "Hoop", "Drop", "Twist"],
      "Berat": ["1 gr", "2 gr", "3 gr"],
      "Detail": ["Polos", "Bermotif", "Berhias Zircon/Permata"],
    },
  ),
];
