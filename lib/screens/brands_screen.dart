import 'package:flutter/material.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(context, 'Brands'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSimpleTile('Cartier'),
          _buildSimpleTile('Tiffany & Co.'),
          _buildSimpleTile('Bulgari'),
          _buildSimpleTile('Van Cleef & Arpels'),
          _buildSimpleTile('Harry Winston'),
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                ),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Colors.black)),
              ],
            ),
            IconButton(icon: const Icon(Icons.shopping_bag_outlined, size: 24), onPressed: () {}),
          ],
        ),
      ),
    ),
  );
}