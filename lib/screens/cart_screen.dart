import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/cart_service.dart';
import 'cart_payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  void _refreshCart() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = _cartService.items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Shopping Bag',

          style: GoogleFonts.josefinSans(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            letterSpacing: 6,
            color: Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: items.isEmpty ? _buildEmptyCart() : _buildCartList(items),
      bottomNavigationBar: items.isEmpty ? null : _buildCheckoutBar(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 24),
          const Text(
            'YOUR BAG IS EMPTY',
            style: TextStyle(fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Text(
            'Explore our collections to find your perfect piece.',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            ),
            child: const Text('CONTINUE SHOPPING', style: TextStyle(color: Colors.white, letterSpacing: 1, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildCartList(List<CartItem> items) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 40, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, index) {
        final item = items[index];
        final product = item.product;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.diamond_outlined, color: Colors.grey[300]),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.3),
                  ),
                  const SizedBox(height: 8),

                  if (item.salePrice != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '£${item.displayPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD50032),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '£${product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      '£${item.displayPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                _cartService.decreaseQuantity(product);
                                _refreshCart();
                              },
                              child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.remove, size: 16)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text('${item.quantity}', style: const TextStyle(fontSize: 14)),
                            ),
                            InkWell(
                              onTap: () {
                                _cartService.addToCart(product, salePrice: item.salePrice);
                                _refreshCart();
                              },
                              child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.add, size: 16)),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _cartService.removeFromCart(product);
                          _refreshCart();
                        },
                        child: Text(
                          'REMOVE',
                          style: TextStyle(color: Colors.grey[600], fontSize: 11, letterSpacing: 1, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SUBTOTAL', style: TextStyle(fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w500)),
                Text('£${_cartService.cartTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Taxes and shipping calculated at checkout', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPaymentScreen()),
                  ).then((_) {

                    _refreshCart();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                ),
                child: const Text('PROCEED TO CHECKOUT', style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}