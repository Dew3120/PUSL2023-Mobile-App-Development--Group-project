import '../data/catalogue.dart';

class WishlistService {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  final List<Product> _items = [];

  List<Product> get items => _items;

  void toggleWishlist(Product product) {
    if (_items.any((item) => item.id == product.id)) {
      _items.removeWhere((item) => item.id == product.id);
    } else {
      _items.add(product);
    }
  }

  void removeFromWishlist(Product product) {
    _items.removeWhere((item) => item.id == product.id);
  }

  bool isWishlisted(Product product) {
    return _items.any((item) => item.id == product.id);
  }

  void clearWishlist() {
    _items.clear();
  }
}