import 'dart:typed_data';

class Product {
  String _id;
  String _name;
  double _diskon;
  double _price;
  String _image;
  double _rating;
  int _sold;
  int _stock;
  int _deliveryDays;
  String? _description;
  List<String>? _specification;
  Map<String, List<String>>? _variation;
  Uint8List? _imageBytes;

  Product({
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
    List<String>? specification,
    Map<String, List<String>>? variation,
    Uint8List? imageBytes,
  }) : _id = id,
       _name = name,
       _diskon = diskon,
       _price = price,
       _image = image,
       _rating = rating,
       _sold = sold,
       _stock = stock,
       _deliveryDays = deliveryDays,
       _description = description,
       _specification = specification,
       _variation = variation,
       _imageBytes = imageBytes;

  // Getter
  String get id => _id;
  String get name => _name;
  double get price => _price;
  double get diskon => _diskon;
  String get image => _image;
  double get rating => _rating;
  int get sold => _sold;
  int get stock => _stock;
  int get deliveryDays => _deliveryDays;
  String? get description => _description;
  List<String>? get specification => _specification;
  Map<String, List<String>>? get variation => _variation;
  Uint8List? get imageBytes => _imageBytes;

  // Setter
  set name(String value) {
    if (value.isEmpty) throw Exception("Nama produk tidak boleh kosong");
    _name = value;
  }

  set price(double value) {
    if (value < 0) throw ArgumentError("Harga tidak boleh negatif!");
    _price = value;
  }

  set diskon(double value) {
    if (value < 0 || value > 100) {
      throw ArgumentError("Diskon harus 0–100%");
    }
    _diskon = value;
  }

  set image(String value) => _image = value;
  set rating(double value) {
    if (value < 0 || value > 5) {
      throw ArgumentError("Rating harus antara 0–5");
    }
    _rating = value;
  }

  set sold(int value) {
    if (value < 0) throw ArgumentError("Jumlah terjual tidak boleh negatif!");
    _sold = value;
  }

  set stock(int value) {
    if (value < 0) throw ArgumentError("Stok tidak boleh negatif!");
    _stock = value;
  }

  set deliveryDays(int value) {
    if (value <= 0) throw ArgumentError("Estimasi hari minimal 1 hari!");
    _deliveryDays = value;
  }

  set description(String? value) => _description = value;
  set specification(List<String>? value) => _specification = value;
  set variation(Map<String, List<String>>? value) => _variation = value;
  set imageBytes(Uint8List? value) => _imageBytes = value;

  /// Hitung harga setelah diskon
  double getFinalPrice() {
    return _price - (_price * _diskon / 100);
  }

  /// Cek apakah produk ini best seller
  bool isBestSeller({int minSold = 100}) {
    return _sold >= minSold;
  }

  /// Cek apakah rating bagus
  bool isRecommended({double minRating = 4.5}) {
    return _rating >= minRating;
  }

  /// Ubah diskon otomatis jika produk tidak laku
  void applyClearanceSale() {
    if (_sold < 10 && _stock > 20) {
      _diskon = 50;
    }
  }

  /// Cek apakah stok tersedia
  bool isInStock() {
    return _stock > 0;
  }

  @override
  String toString() {
    return "$_name | Harga: Rp$_price | Diskon: $_diskon% | Final: Rp${getFinalPrice()} "
        "| Rating: $_rating | Terjual: $_sold | Stok: $_stock | Estimasi: $_deliveryDays hari";
  }
}
