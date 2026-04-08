import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(context, 'Categories'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSimpleTile('Rings'),
          _buildSimpleTile('Necklaces'),
          _buildSimpleTile('Bracelets'),
          _buildSimpleTile('Earrings'),
          _buildSimpleTile('Watches'),
        ],
      ),
    );
  }

  Widget _buildSimpleTile(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(4)),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
    );
  }
}

PreferredSizeWidget _buildHeader(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(72),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_ios, size: 20)),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
              ],
            ),
            IconButton(icon: const Icon(Icons.shopping_bag_outlined, size: 24), onPressed: () {}),
          ],
        ),
      ),
    ),
  );
}