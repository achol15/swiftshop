import 'package:flutter_ecommerce_firebase/models/product_model.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  double get totalAmount => product.price * quantity;
}
