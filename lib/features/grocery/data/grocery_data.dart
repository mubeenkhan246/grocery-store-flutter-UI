import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroceryCategory {
  const GroceryCategory(this.name, this.icon, this.color);
  final String name;
  final IconData icon;
  final Color color;
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.badge,
    required this.color,
    required this.nutrition,
  });

  final String id;
  final String name;
  final String category;
  final String emoji;
  final double price;
  final double oldPrice;
  final double rating;
  final String badge;
  final Color color;
  final List<String> nutrition;
}

final categoriesProvider = Provider<List<GroceryCategory>>((ref) => const [
      GroceryCategory('Fruits', Icons.eco_rounded, Color(0xFFFFB703)),
      GroceryCategory('Vegetables', Icons.spa_rounded, Color(0xFF16A34A)),
      GroceryCategory('Dairy', Icons.local_drink_rounded, Color(0xFF7DD3FC)),
      GroceryCategory('Bakery', Icons.bakery_dining_rounded, Color(0xFFD97706)),
      GroceryCategory('Meat', Icons.restaurant_rounded, Color(0xFFEF4444)),
      GroceryCategory('Beverages', Icons.local_cafe_rounded, Color(0xFF06B6D4)),
      GroceryCategory('Snacks', Icons.cookie_rounded, Color(0xFFF97316)),
      GroceryCategory('Frozen Foods', Icons.ac_unit_rounded, Color(0xFF60A5FA)),
    ]);

final productsProvider = Provider<List<Product>>((ref) => const [
      Product(
        id: '1',
        name: 'Organic Avocado',
        category: 'Fruits',
        emoji: '🥑',
        price: 4.80,
        oldPrice: 6.20,
        rating: 4.9,
        badge: '22% off',
        color: Color(0xFFB7E4A1),
        nutrition: ['240 kcal', '10g fiber', '3g protein', 'Vitamin K'],
      ),
      Product(
        id: '2',
        name: 'A2 Grass Milk',
        category: 'Dairy',
        emoji: '🥛',
        price: 5.40,
        oldPrice: 6.10,
        rating: 4.8,
        badge: 'Fresh',
        color: Color(0xFFBFDBFE),
        nutrition: ['150 kcal', '8g protein', 'Calcium', 'No additives'],
      ),
      Product(
        id: '3',
        name: 'Sourdough Loaf',
        category: 'Bakery',
        emoji: '🥖',
        price: 7.20,
        oldPrice: 8.00,
        rating: 4.7,
        badge: 'Baked today',
        color: Color(0xFFFDE68A),
        nutrition: ['180 kcal', '6g protein', 'Low sugar', 'Slow fermented'],
      ),
      Product(
        id: '4',
        name: 'Wild Blueberries',
        category: 'Frozen Foods',
        emoji: '🫐',
        price: 8.90,
        oldPrice: 10.40,
        rating: 4.9,
        badge: 'Flash deal',
        color: Color(0xFFC4B5FD),
        nutrition: ['80 kcal', 'Antioxidants', '4g fiber', 'Vitamin C'],
      ),
      Product(
        id: '5',
        name: 'Rainbow Carrots',
        category: 'Vegetables',
        emoji: '🥕',
        price: 3.80,
        oldPrice: 4.50,
        rating: 4.6,
        badge: 'Organic',
        color: Color(0xFFFDBA74),
        nutrition: ['50 kcal', 'Beta carotene', '3g fiber', 'Potassium'],
      ),
      Product(
        id: '6',
        name: 'Cold Pressed Juice',
        category: 'Beverages',
        emoji: '🥤',
        price: 6.60,
        oldPrice: 7.80,
        rating: 4.8,
        badge: 'New',
        color: Color(0xFF99F6E4),
        nutrition: ['120 kcal', 'No sugar added', 'Vitamin C', 'Ginger'],
      ),
    ]);

final wishlistProvider = StateProvider<Set<String>>((ref) => {'1', '4'});
final cartProvider = StateProvider<Map<String, int>>((ref) => {'1': 2, '3': 1});
final selectedTabProvider = StateProvider<int>((ref) => 0);
