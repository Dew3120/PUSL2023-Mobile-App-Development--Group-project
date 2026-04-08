import 'package:flutter/material.dart';

class NewArrivalsScreen extends StatelessWidget {
  const NewArrivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(context, 'New Arrivals'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Latest collections added this week',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.65,
              children: [
                _buildLightProductCard('Trinity Ring', 'Cartier', '£1,450'),
                _buildLightProductCard('Serpenti Necklace', 'Bulgari', '£4,200'),
                _buildLightProductCard('Alhambra Bracelet', 'Van Cleef', '£3,800'),
                _buildLightProductCard('T1 Hoop Earrings', 'Tiffany & Co', '£1,100'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLightProductCard(String name, String brand, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(4)),
            child: Stack(
              children: [
                Center(child: Icon(Icons.diamond_outlined, size: 50, color: Colors.grey[300])),
                Positioned(top: 8, right: 8, child: Icon(Icons.favorite_border, size: 18, color: Colors.grey[800])),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(brand.toUpperCase(), style: TextStyle(fontSize: 10, color: Colors.grey[500], letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 13, color: Colors.black), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 6),
        Text(price, style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)),
      ],
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