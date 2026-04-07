import 'package:flutter/material.dart';
import '../data/catalogue.dart';
import 'payment_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _wishlisted = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Hero image ─────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _wishlisted ? Icons.favorite : Icons.favorite_outline,
                  color: _wishlisted ? const Color(0xFFD50032) : Colors.white,
                ),
                onPressed: () => setState(() => _wishlisted = !_wishlisted),
              ),
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                p.imageUrl.replaceAll('w=600', 'w=900'),
                fit: BoxFit.cover,
                loadingBuilder: (ctx, child, progress) =>
                    progress == null ? child : Container(color: const Color(0xFFF0EDEA)),
                errorBuilder: (_, __, ___) =>
                    Container(color: const Color(0xFFF0EDEA)),
              ),
            ),
          ),

          // ── Product info ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Price
                  Text(
                    p.formattedPrice,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Price includes applicable taxes',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 28),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 28),

                  // Description heading
                  const Text(
                    'DESCRIPTION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    p.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      height: 1.8,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 28),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 28),

                  // Details
                  const Text(
                    'DETAILS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _DetailRow(label: 'Reference', value: p.id.toUpperCase().replaceAll('_', ' ')),
                  _DetailRow(label: 'Material', value: 'Gold, Diamond'),
                  _DetailRow(label: 'Collection', value: p.collection.toUpperCase().replaceAll('_', ' ')),
                  _DetailRow(label: 'Availability', value: 'In Boutique & Online'),

                  const SizedBox(height: 40),

                  // ── CTA buttons ────────────────────────────────────────

                  // Buy now — goes straight to payment
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(product: p),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD50032),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: const Text(
                        'BUY NOW',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Add to bag
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${p.name} added to bag'),
                            backgroundColor: Colors.black87,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: const Text(
                        'ADD TO BAG',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Contact boutique
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => _showBoutiqueDialog(context, p),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: const Text(
                        'CONTACT A BOUTIQUE',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Add to wishlist
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: TextButton.icon(
                      onPressed: () =>
                          setState(() => _wishlisted = !_wishlisted),
                      icon: Icon(
                        _wishlisted ? Icons.favorite : Icons.favorite_outline,
                        size: 18,
                        color: _wishlisted
                            ? const Color(0xFFD50032)
                            : Colors.black,
                      ),
                      label: Text(
                        _wishlisted
                            ? 'SAVED TO WISHLIST'
                            : 'ADD TO WISHLIST',
                        style: TextStyle(
                          color: _wishlisted
                              ? const Color(0xFFD50032)
                              : Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Contact boutique dialog ──────────────────────────────────────────────────

void _showBoutiqueDialog(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'CONTACT A BOUTIQUE',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Our client advisors are available to assist you with '
            '"${product.name}".',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              height: 1.6,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 22),

          _boutiqueTile(
            icon: Icons.phone_outlined,
            title: 'Call us',
            subtitle: '+1 800 CARTIER (227 8437)',
            hint: 'Mon – Sat · 9am – 9pm EST',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _boutiqueTile(
            icon: Icons.mail_outline,
            title: 'Email',
            subtitle: 'clientrelations@cartier.com',
            hint: 'Replies within 24 hours',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _boutiqueTile(
            icon: Icons.event_outlined,
            title: 'Book an appointment',
            subtitle: 'Schedule a private viewing',
            hint: 'At your nearest boutique',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _boutiqueTile(
            icon: Icons.location_on_outlined,
            title: 'Nearest boutique',
            subtitle: '653 Fifth Avenue, New York',
            hint: '0.8 mi away · Open now',
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              child: const Text(
                'CLOSE',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _boutiqueTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required String hint,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Icon(icon, size: 16, color: Colors.black87),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hint,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFFAAAAAA),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios,
            size: 12, color: Color(0xFFBBBBBB)),
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.grey[500],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
