import 'package:flutter/material.dart';
import '../data/catalogue.dart';
import 'category_screen.dart';
import 'sale_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cats = Catalogue.categories;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ── Top bar ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, size: 24),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'CARTIER',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 6,
                              fontFamily: 'Basis',
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, size: 24),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const Divider(
                    height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),
              ],
            ),
          ),

          // ── La Sélection promo banner (top priority) ─────────────────────
          const SliverToBoxAdapter(child: _SelectionBanner()),

          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 0.5, color: Color(0xFFE8E8E8)),
          ),

          // ── Hero: HIGH JEWELLERY (index 0) ───────────────────────────────
          SliverToBoxAdapter(
            child: _HeroCategoryCard(category: cats[0]),
          ),

          // ── Row: JEWELLERY (1) + WATCHES (2) ─────────────────────────────
          SliverToBoxAdapter(
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _SmallCategoryCard(category: cats[1])),
                  const VerticalDivider(width: 1, color: Color(0xFFE8E8E8)),
                  Expanded(child: _SmallCategoryCard(category: cats[2])),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 0.5, color: Color(0xFFE8E8E8)),
          ),

          // ── Full-width: BAGS & ACCESSORIES (3) ───────────────────────────
          SliverToBoxAdapter(
            child: _WideCategoryCard(category: cats[3]),
          ),

          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 0.5, color: Color(0xFFE8E8E8)),
          ),

          // ── Row: FRAGRANCES (4) + HOME & STATIONERY (5) ──────────────────
          SliverToBoxAdapter(
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _SmallCategoryCard(category: cats[4])),
                  const VerticalDivider(width: 1, color: Color(0xFFE8E8E8)),
                  Expanded(child: _SmallCategoryCard(category: cats[5])),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

// ── Shared image widget ──────────────────────────────────────────────────────

class _CategoryImage extends StatelessWidget {
  final String url;
  final double height;
  const _CategoryImage({required this.url, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        frameBuilder: (ctx, child, frame, sync) {
          if (sync) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            child: child,
          );
        },
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFFF0EDEA),
          child: const Center(
            child: Icon(Icons.image_outlined,
                size: 40, color: Color(0xFFCBC2B8)),
          ),
        ),
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : Container(color: const Color(0xFFF0EDEA)),
      ),
    );
  }
}

// ── Hero banner ──────────────────────────────────────────────────────────────

class _HeroCategoryCard extends StatelessWidget {
  final MainCategory category;
  const _HeroCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigate(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryImage(url: category.imageUrl, height: 440),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 3)),
                const SizedBox(height: 10),
                Text(category.description,
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w300, height: 1.7, color: Colors.grey[700])),
                const SizedBox(height: 16),
                const _DiscoverLink(),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE8E8E8)),
        ],
      ),
    );
  }

  void _navigate(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => CategoryScreen(category: category)));
  }
}

// ── Wide banner ──────────────────────────────────────────────────────────────

class _WideCategoryCard extends StatelessWidget {
  final MainCategory category;
  const _WideCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => CategoryScreen(category: category))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryImage(url: category.imageUrl, height: 300),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 3)),
                const SizedBox(height: 10),
                Text(category.description,
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w300, height: 1.7, color: Colors.grey[700])),
                const SizedBox(height: 16),
                const _DiscoverLink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small card ───────────────────────────────────────────────────────────────

class _SmallCategoryCard extends StatelessWidget {
  final MainCategory category;
  const _SmallCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => CategoryScreen(category: category))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryImage(url: category.imageUrl, height: 220),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 2.5)),
                const SizedBox(height: 8),
                Text(category.description,
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w300, height: 1.65, color: Colors.grey[600]),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                const _DiscoverLink(fontSize: 11),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── La Sélection banner ──────────────────────────────────────────────────────

class _SelectionBanner extends StatelessWidget {
  const _SelectionBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SaleScreen()),
      ),
      child: Container(
        width: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.fromLTRB(24, 46, 24, 46),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD50032), width: 0.8),
              ),
              child: const Text(
                'TODAY ONLY',
                style: TextStyle(
                  color: Color(0xFFD50032),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.5,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'LA SÉLECTION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w400,
                letterSpacing: 6,
                fontFamily: 'Basis',
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'A curated window of our finest pieces —\nopen for six hours, every day.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFBBBBBB),
                fontSize: 12,
                fontWeight: FontWeight.w300,
                height: 1.8,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ENTER LA SÉLECTION',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 22,
                  height: 0.8,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward,
                    size: 13, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Discover link ─────────────────────────────────────────────────────────────

class _DiscoverLink extends StatelessWidget {
  final double fontSize;
  const _DiscoverLink({super.key, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('DISCOVER',
            style: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.w500, letterSpacing: 2)),
        const SizedBox(width: 6),
        Icon(Icons.arrow_forward, size: fontSize + 2),
      ],
    );
  }
}
