import 'dart:math';
import '../data/catalogue.dart';

class SaleProduct {
  final Product product;
  final String categoryName;
  final String subCategoryName;
  final int discountPercent;
  final double salePrice;

  const SaleProduct({
    required this.product,
    required this.categoryName,
    required this.subCategoryName,
    required this.discountPercent,
    required this.salePrice,
  });
}

class _Metrics {
  final int viewCount;
  final int purchaseCount;
  final int wishlistCount;
  final int daysSinceLastSale;

  const _Metrics({
    required this.viewCount,
    required this.purchaseCount,
    required this.wishlistCount,
    required this.daysSinceLastSale,
  });

  double get conversionRate =>
      viewCount > 0 ? purchaseCount / viewCount : 0.0;

  /// Under-performance score 0–1 (higher = more under-performing)
  double get score {
    final convScore = (1 - (conversionRate / 0.1)).clamp(0.0, 1.0);
    final ageScore = (daysSinceLastSale / 90).clamp(0.0, 1.0);
    final wishlistScore = (1 - (wishlistCount / 50)).clamp(0.0, 1.0);
    return (convScore * 0.5) + (ageScore * 0.3) + (wishlistScore * 0.2);
  }
}

/// Intelligent Auto-Sale Algorithm
/// KPIs: view-to-purchase conversion rate, days since last sale, wishlist activity
/// Two-layer selection: qualify on thresholds → curate a subset (preserves luxury scarcity)
class SaleService {
  SaleService._();

  static List<SaleProduct>? _cached;
  static int? _cacheDay;

  static List<SaleProduct> getSaleProducts() {
    final today = DateTime.now().day;

    // Rebuild once per day
    if (_cached != null && _cacheDay == today) return _cached!;

    final rng = Random(today * 31); // deterministic per day

    // ── Step 1: Generate mock performance metrics per product ─────────────
    // Seed per product = hash so metrics are stable per product ID
    final allQualifying = <SaleProduct>[];

    for (final cat in Catalogue.categories) {
      for (final sub in cat.subCategories) {
        for (final product in sub.products) {
          final seed = product.id.hashCode.abs();
          final pRng = Random(seed);

          final metrics = _Metrics(
            viewCount: pRng.nextInt(400) + 20,
            purchaseCount: pRng.nextInt(30),
            wishlistCount: pRng.nextInt(80),
            daysSinceLastSale: pRng.nextInt(120),
          );

          // ── Step 2: Flag underperforming items ──────────────────────────
          // Thresholds: conversion < 5%, last sale > 45 days, wishlist < 15
          final underperforming = metrics.conversionRate < 0.05 ||
              metrics.daysSinceLastSale > 45 ||
              metrics.wishlistCount < 15;

          if (underperforming) {
            // Discount based on score severity
            final discount = metrics.score > 0.8
                ? 35
                : metrics.score > 0.6
                    ? 25
                    : metrics.score > 0.4
                        ? 20
                        : 15;

            allQualifying.add(SaleProduct(
              product: product,
              categoryName: cat.name,
              subCategoryName: sub.name,
              discountPercent: discount,
              salePrice: (product.price * (1 - discount / 100))
                  .roundToDouble(),
            ));
          }
        }
      }
    }

    // ── Step 3: Curated second layer ────────────────────────────────────
    // Not every qualifying item is shown simultaneously — luxury scarcity.
    // Sort by score descending, shuffle top half, take ~40 for curation.
    allQualifying.sort((a, b) {
      final sa = _scoreFor(a.product.id);
      final sb = _scoreFor(b.product.id);
      return sb.compareTo(sa);
    });

    final topPool = allQualifying.take(allQualifying.length ~/ 2).toList();
    topPool.shuffle(rng);

    _cached = topPool.take(40).toList();
    _cacheDay = today;

    return _cached!;
  }

  static double _scoreFor(String productId) {
    final seed = productId.hashCode.abs();
    final pRng = Random(seed);
    final m = _Metrics(
      viewCount: pRng.nextInt(400) + 20,
      purchaseCount: pRng.nextInt(30),
      wishlistCount: pRng.nextInt(80),
      daysSinceLastSale: pRng.nextInt(120),
    );
    return m.score;
  }
}
