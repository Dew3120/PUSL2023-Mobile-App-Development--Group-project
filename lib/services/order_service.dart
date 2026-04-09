import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Handles writing and reading customer orders to Cloud Firestore.
///
/// Data model:
/// users/{uid}/orders/{orderId}
/// productId, productName, productRef, productImage, collection,
/// unitPrice, size, cardLastFour, cardHolder,
/// shippingName, shippingLine1, shippingCity, shippingZip,
/// status, createdAt
class OrderService {
  static final _db = FirebaseFirestore.instance;

  /// Returns the current signed-in user's uid, or a fallback demo id
  /// so the demo still works when auth is bypassed.
  static String _uid() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? 'demo_user';
  }

  static CollectionReference<Map<String, dynamic>> _ordersRef() =>
      _db.collection('users').doc(_uid()).collection('orders');

  /// Saves a new order and returns the generated order ID.
  static Future<String> placeOrder({
    required String productId,
    required String productName,
    required String? productRef,
    required String productImage,
    required String collection,
    required double unitPrice,
    String? size,
    required String cardHolder,
    required String cardLastFour,
    required String shippingName,
    required String shippingLine1,
    required String shippingCity,
    required String shippingZip,
  }) async {
    final doc = await _ordersRef().add({
      'productId': productId,
      'productName': productName,
      'productRef': productRef,
      'productImage': productImage,
      'collection': collection,
      'unitPrice': unitPrice,
      'size': size,
      'cardHolder': cardHolder,
      'cardLastFour': cardLastFour,
      'shippingName': shippingName,
      'shippingLine1': shippingLine1,
      'shippingCity': shippingCity,
      'shippingZip': shippingZip,
      'status': 'Confirmed',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  /// Live stream of all orders for the current user, newest first.
  static Stream<List<OrderRecord>> watchOrders() {
    return _ordersRef()
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => OrderRecord.fromDoc(d.id, d.data())).toList());
  }
}

/// Plain data object used by the UI.
class OrderRecord {
  final String id;
  final String productId;
  final String productName;
  final String? productRef;
  final String productImage;
  final String collection;
  final double unitPrice;
  final String? size;
  final String cardLastFour;
  final String shippingLine1;
  final String shippingCity;
  final String status;
  final DateTime? createdAt;

  OrderRecord({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productRef,
    required this.productImage,
    required this.collection,
    required this.unitPrice,
    required this.size,
    required this.cardLastFour,
    required this.shippingLine1,
    required this.shippingCity,
    required this.status,
    required this.createdAt,
  });

  factory OrderRecord.fromDoc(String id, Map<String, dynamic> data) {
    final ts = data['createdAt'];
    return OrderRecord(
      id: id,
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      productRef: data['productRef'],
      productImage: data['productImage'] ?? '',
      collection: data['collection'] ?? '',
      unitPrice: (data['unitPrice'] ?? 0).toDouble(),
      size: data['size'],
      cardLastFour: data['cardLastFour'] ?? '',
      shippingLine1: data['shippingLine1'] ?? '',
      shippingCity: data['shippingCity'] ?? '',
      status: data['status'] ?? 'Confirmed',
      createdAt: ts is Timestamp ? ts.toDate() : null,
    );
  }

  /// Short order reference shown in the UI ("CT-ABC123").
  String get shortRef => 'CT-${id.substring(0, id.length < 6 ? id.length : 6).toUpperCase()}';

  /// Formatted date like "Apr 08, 2026".
  String get formattedDate {
    if (createdAt == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final d = createdAt!;
    final day = d.day.toString().padLeft(2, '0');
    return '${months[d.month - 1]} $day, ${d.year}';
  }
}
