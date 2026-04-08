import 'package:flutter/material.dart';
import 'custom_jewellery_screen.dart';
import 'auto_sale_screen.dart';
import 'brands_screen.dart';
import 'categories_screen.dart';
import 'new_arrivals_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Shop',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    height: 1.0,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, size: 24),
                  onPressed: () {
                    // TODO: Navigate to Cart Screen
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[500], size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Search brands, categories',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Interactive Navigation List
            InteractiveShopTile(
              title: 'Brands',
              subtitle: 'Cartier, Tiffany, Bulgari & more',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BrandsScreen()),
                );
              },
            ),
            InteractiveShopTile(
              title: 'Categories',
              subtitle: 'Rings, Necklaces, Bracelets & more',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                );
              },
            ),
            InteractiveShopTile(
              title: 'Sale',
              subtitle: 'Exclusive deals — updated daily',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AutoSaleScreen()),
                );
              },
            ),
            InteractiveShopTile(
              title: 'New Arrivals',
              subtitle: 'Latest collections added',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewArrivalsScreen()),
                );
              },
            ),
            InteractiveShopTile(
              title: 'Custom Jewellery',
              subtitle: 'Design your perfect piece',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomJewelleryScreen()),
                );
              },
            ),

            const SizedBox(height: 30),

            // Trending Now Section
            const Text(
              'TRENDING NOW',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildTrendingPill('Diamond Rings', true),
                _buildTrendingPill('Gold Chains', false),
                _buildTrendingPill('Studs', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingPill(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.black : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black87,
          fontSize: 13,
        ),
      ),
    );
  }
}


class InteractiveShopTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const InteractiveShopTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  @override
  State<InteractiveShopTile> createState() => _InteractiveShopTileState();
}

class _InteractiveShopTileState extends State<InteractiveShopTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isPressed ? Colors.black : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: _isPressed ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: _isPressed ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    color: _isPressed ? Colors.white.withOpacity(0.9) : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: _isPressed ? Colors.white : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}