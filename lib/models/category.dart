import 'package:flutter/material.dart';
import 'product.dart';

class Category {
  final String name;
  final IconData icon;
  final List<Product> products;

  Category({required this.name, required this.icon, required this.products});

  Map<String, dynamic> toJson() {
    return {'name': name, 'icon': icon.codePoint};
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      products: [],
    );
  }
}
