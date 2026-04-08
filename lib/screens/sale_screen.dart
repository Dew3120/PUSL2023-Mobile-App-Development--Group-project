import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/sale_service.dart';
import '../screens/product_detail_screen.dart';

/// La Sélection — a curated 6-hour daily window.
/// Once the window closes, the user sees an empty state until the next day.
class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  static const Duration _windowLength = Duration(hours: 6);

  late List<SaleProduct> _allProducts;
  String _activeFilter = 'All';

  bool _checking = true;
  Duration _remaining = Duration.zero;
  Timer? _ticker;

  static const _filters = ['All', 'Rings', 'Necklaces', 'Watches', 'Bags'];

  @override
  void initState() {
    super.initState();
    _allProducts = SaleService.getSaleProducts();
    _initWindow();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _initWindow() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dayKey = '${now.year}-${now.month}-${now.day}';
    final savedDay = prefs.getString('selection_day');

    int startMs;
    if (savedDay != dayKey) {
      // Brand new day → start a fresh 6-hour window now.
      startMs = now.millisecondsSinceEpoch;
      await prefs.setString('selection_day', dayKey);
      await prefs.setInt('selection_start_ms', startMs);
    } else {
      startMs = prefs.getInt('selection_start_ms') ?? now.millisecondsSinceEpoch;
    }

    final elapsed = Duration(milliseconds: now.millisecondsSinceEpoch - startMs);
    final remaining = _windowLength - elapsed;

    if (!mounted) return;
    setState(() {
      _remaining = remaining.isNegative ? Duration.zero : remaining;
      _checking = false;
    });

    if (_remaining > Duration.zero) _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining = _remaining - const Duration(seconds: 1);
        if (_remaining <= Duration.zero) {
          _remaining = Duration.zero;
          _ticker?.cancel();
        }
      });
    });
  }

  List<SaleProduct> get _filtered {
    if (_activeFilter == 'All') return _allProducts;
    return _allProducts.where((p) {
      final name = p.subCategoryName.toLowerCase();
      return name.contains(_activeFilter.toLowerCase()) ||
          p.categoryName.toLowerCase().contains(_activeFilter.toLowerCase());
    }).toList();
  }

  String _fmtCountdown(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h : $m : $s';
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFD50032),
            strokeWidth: 2,
          ),
        ),
      );
    }

    final isOpen = _remaining > Duration.zero;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isOpen ? _buildOpenWindow() : _buildClosedWindow(),
      ),
    );
  }

  // ── Window OPEN — products + countdown ─────────────────────────────────
  Widget _buildOpenWindow() {
    final products = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LA SÉLECTION',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 3,
                      ),
                    ),
                    Text(
                      'A curated window — today only',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Countdown banner ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CLOSING IN',
                      style: TextStyle(
                        color: Color(0xFFD50032),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Hours — Minutes — Seconds',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  _fmtCountdown(_remaining),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ── Filter chips ──
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final f = _filters[i];
              final active = f == _activeFilter;
              return GestureDetector(
                onTap: () => setState(() => _activeFilter = f),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFFD50032)
                        : Colors.transparent,
                    border: Border.all(
                      color: active
                          ? const Color(0xFFD50032)
                          : const Color(0xFFDDDDDD),
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    f,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: active ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 14),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
        ),
        const SizedBox(height: 4),

        // ── Grid ──
        Expanded(
          child: products.isEmpty
              ? Center(
                  child: Text(
                    'No pieces in this category',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, i) =>
                      _SaleCard(saleProduct: products[i]),
                ),
        ),

        // ── Footer ──
        Container(
          width: double.infinity,
          color: const Color(0xFFF8F8F8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'A new Sélection returns tomorrow',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  // ── Window CLOSED — empty state ─────────────────────────────────────────
  Widget _buildClosedWindow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              const Text(
                'LA SÉLECTION',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFFE5E5E5), width: 1),
                    ),
                    child: const Icon(
                      Icons.hourglass_empty,
                      size: 28,
                      color: Color(0xFFC0C0C0),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "TODAY'S WINDOW HAS CLOSED",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'La Sélection opens for only six hours each day. '
                    'A new curated window will appear tomorrow.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      height: 1.6,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Sale product card ────────────────────────────────────────────────────────

class _SaleCard extends StatelessWidget {
  final SaleProduct saleProduct;
  const _SaleCard({required this.saleProduct});

  @override
  Widget build(BuildContext context) {
    final p = saleProduct.product;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: p)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: SizedBox.expand(
                    child: Image.network(
                      p.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, progress) =>
                          progress == null
                              ? child
                              : Container(color: const Color(0xFFF4F1EE)),
                      errorBuilder: (ctx, err, st) => Container(
                        color: const Color(0xFFF4F1EE),
                        child: const Center(
                          child: Icon(Icons.image_outlined,
                              color: Color(0xFFCBC2B8), size: 28),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    color: const Color(0xFFD50032),
                    child: Text(
                      '-${saleProduct.discountPercent}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xDFFFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_outline,
                        size: 15, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            p.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            saleProduct.categoryName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _fmt(saleProduct.salePrice),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD50032),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                p.formattedPrice,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[400],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double price) {
    final p = price.toInt();
    final s = p.toString();
    final buf = StringBuffer('\$');
    final offset = s.length % 3;
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (i - offset) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
