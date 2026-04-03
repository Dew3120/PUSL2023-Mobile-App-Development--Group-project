import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 48,
          color: Colors.black26,
        ),
      ),
    );
  }
}
