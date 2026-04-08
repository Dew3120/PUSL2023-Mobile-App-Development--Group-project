import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_screen.dart';
import 'filtered_grid_screen.dart';
import '../data/catalogue.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  List<Product> _getProductsByCategory(String keyword) {
    List<Product> matchedProducts = [];
    final searchKeyword = keyword.toLowerCase().replaceAll(RegExp(r's$'), '');

    for (final cat in Catalogue.categories) {
      for (final sub in cat.subCategories) {
        for (final product in sub.products) {
          final searchString = '${product.collection} ${product.name}'.toLowerCase();
          if (searchString.contains(searchKeyword)) {
            matchedProducts.add(product);
          }
        }
      }
    }
    return matchedProducts;
  }

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Rings',
        'subtitle': 'Timeless Solitaires & Bands',
        'image': 'https://images.pexels.com/photos/30720972/pexels-photo-30720972.jpeg',
      },
      {
        'title': 'Bracelets',
        'subtitle': 'Iconic Gold & Bangles',
        'image': 'https://images.pexels.com/photos/14509641/pexels-photo-14509641.jpeg',
      },
      {
        'title': 'Necklaces',
        'subtitle': 'Brilliant Diamond Pendants',
        'image': 'https://images.pexels.com/photos/34760894/pexels-photo-34760894.jpeg',
      },
      {
        'title': 'Earrings',
        'subtitle': 'Elegant Studs & Drops',
        'image': 'https://images.pexels.com/photos/35270159/pexels-photo-35270159.jpeg',
      },
      {
        'title': 'Watches',
        'subtitle': 'The Art of Precision',
        'image': 'https://images.pexels.com/photos/34341284/pexels-photo-34341284.jpeg',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(context, 'Categories'),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
              child: Column(
                children: [
                  Text(
                    'DISCOVER THE MAISON',
                    style: GoogleFonts.josefinSans(
                      fontSize: 12,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 1,
                    color: Colors.black26,
                  ),
                ],
              ),
            );
          }

          final category = categories[index - 1];
          return _buildMaisonEditorialTile(
            context,
            category['title']!,
            category['subtitle']!,
            category['image']!,
          );
        },
      ),
    );
  }

  Widget _buildMaisonEditorialTile(
      BuildContext context,
      String title,
      String subtitle,
      String imageUrl,
      ) {
    return GestureDetector(
      onTap: () {
        final products = _getProductsByCategory(title);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilteredGridScreen(
              pageTitle: title,
              products: products,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 240,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF9F8F6),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black12,
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.image_outlined, color: Colors.grey, size: 32),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              title.toUpperCase(),
              style: GoogleFonts.josefinSans(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 4,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                letterSpacing: 1.2,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 8, color: Colors.black87),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

PreferredSizeWidget _buildHeader(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
      onPressed: () => Navigator.pop(context),
    ),
    centerTitle: true,
    title: Text(
      title,
      style: GoogleFonts.josefinSans(
        fontSize: 22,
        fontWeight: FontWeight.w300,
        letterSpacing: 3,
        color: Colors.black,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 22),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),
      ),
    ],
  );
}