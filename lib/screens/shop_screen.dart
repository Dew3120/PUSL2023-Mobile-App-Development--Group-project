import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_jewellery_screen.dart';
import 'auto_sale_screen.dart';
import 'categories_screen.dart';
import 'new_arrivals_screen.dart';
import 'cart_screen.dart';
import 'filtered_grid_screen.dart';
import '../data/catalogue.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  List<Product> _searchCatalogue(String keyword) {
    if (keyword.trim().isEmpty) return [];

    List<Product> matchedProducts = [];
    final searchKeyword = keyword.toLowerCase();

    for (final cat in Catalogue.categories) {
      for (final sub in cat.subCategories) {
        for (final product in sub.products) {

          final searchString = '${product.name} ${product.collection} ${product.description}'.toLowerCase();

          if (searchString.contains(searchKeyword)) {
            matchedProducts.add(product);
          }
        }
      }
    }
    return matchedProducts;
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    final results = _searchCatalogue(query);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilteredGridScreen(
          pageTitle: 'RESULTS FOR "$query"',
          products: results,
        ),
      ),
    );

    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Shop',
          style: GoogleFonts.josefinSans(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            letterSpacing: 6,
            color: Colors.black,
            height: 1.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 24),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: _performSearch,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search collections & pieces',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13, letterSpacing: 0.5),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 24),


            _LuxuryShopBanner(
              title: 'CATEGORIES',
              subtitle: 'Rings, Necklaces, Bracelets & more',
              imageUrl: 'https://images.pexels.com/photos/265906/pexels-photo-265906.jpeg?auto=compress&cs=tinysrgb&w=800',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                );
              },
            ),

            _LuxuryShopBanner(
              title: 'NEW ARRIVALS',
              subtitle: 'Discover our latest creations',
              imageUrl: 'https://images.pexels.com/photos/22475821/pexels-photo-22475821.jpeg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewArrivalsScreen()),
                );
              },
            ),

            _LuxuryShopBanner(
              title: 'SALE',
              subtitle: 'Curated pieces at archive pricing',
              imageUrl: 'https://images.pexels.com/photos/2735970/pexels-photo-2735970.jpeg?auto=compress&cs=tinysrgb&w=800',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AutoSaleScreen()),
                );
              },
            ),

            _LuxuryShopBanner(
              title: 'CUSTOM JEWELLERY',
              subtitle: 'Design your perfect masterpiece',

              imageUrl: 'https://images.pexels.com/photos/6263143/pexels-photo-6263143.jpeg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomJewelleryScreen()),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}



class _LuxuryShopBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  const _LuxuryShopBanner({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: const Color(0xFFF5F5F5),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}