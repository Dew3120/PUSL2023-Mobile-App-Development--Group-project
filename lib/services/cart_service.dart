import '../data/catalogue.dart';

class CartItem {
  final Product product;
  int quantity;
  bool isSelected;
  final double? salePrice;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
    this.salePrice,
  });

  double get displayPrice => salePrice ?? product.price;
}

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  List<CartItem> get selectedItems => _items.where((i) => i.isSelected).toList();

  void addToCart(Product product, {double? salePrice}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product, salePrice: salePrice));
    }
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  void decreaseQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        removeFromCart(product);
      }
    }
  }

  void toggleSelection(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].isSelected = !_items[index].isSelected;
    }
  }

  void clearSelectedItems() {
    _items.removeWhere((item) => item.isSelected);
  }

  double get cartTotal {
    return _items.where((i) => i.isSelected).fold(0, (total, item) => total + (item.displayPrice * item.quantity));
  }
}