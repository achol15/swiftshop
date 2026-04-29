import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Products
  Stream<List<Product>> streamProducts() {
    return _db.collection('products').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => Product.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  // Orders
  Future<void> placeOrder(OrderModel order) async {
    await _db.collection('orders').add(order.toMap());
  }

  Stream<List<OrderModel>> streamUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Seed data helper (to populate the store if empty)
  Future<void> seedProducts() async {
    final products = _db.collection('products');
    final snapshot = await products.limit(1).get();
    if (snapshot.docs.isEmpty) {
      final dummyData = [
        {
          'name': 'Premium Wireless Headphones',
          'description': 'High-quality sound with noise cancellation.',
          'price': 299.99,
          'imageUrl':
              'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
          'category': 'Electronics'
        },
        {
          'name': 'Minimalist Watch',
          'description': 'Elegant design for every occasion.',
          'price': 149.50,
          'imageUrl':
              'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
          'category': 'Accessories'
        },
        {
          'name': 'Smart Running Shoes',
          'description': 'Comfortable and durable for long runs.',
          'price': 89.99,
          'imageUrl':
              'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
          'category': 'Footwear'
        },
      ];
      for (var p in dummyData) {
        await products.add(p);
      }
    }
  }
}
