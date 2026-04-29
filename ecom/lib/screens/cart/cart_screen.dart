import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/database_service.dart';
import '../../models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "🛒 Your cart is empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                /// 🛍️ CART ITEMS
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 300 + index * 100),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (_, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 50 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.black12,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              /// 🖼 IMAGE
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item.product.imageUrl,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(width: 12),

                              /// 📦 INFO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(
                                        "\$${item.product.price.toStringAsFixed(2)}"),
                                    const SizedBox(height: 6),

                                    /// 🔢 QUANTITY CONTROL
                                    Row(
                                      children: [
                                        _qtyButton(
                                          icon: Icons.remove,
                                          onTap: () => cart.removeSingleItem(
                                              item.product.id),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            '${item.quantity}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        _qtyButton(
                                          icon: Icons.add,
                                          onTap: () =>
                                              cart.addItem(item.product),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              /// 💰 TOTAL
                              Text(
                                "\$${item.totalAmount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// 💳 CHECKOUT CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                        offset: Offset(0, -2),
                      )
                    ],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      /// TOTAL
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total",
                              style: TextStyle(color: Colors.grey)),
                          Text(
                            "\$${cart.totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const Spacer(),

                      /// CHECKOUT BUTTON
                      GestureDetector(
                        onTap: cart.totalAmount <= 0
                            ? null
                            : () async {
                                final userId =
                                    FirebaseAuth.instance.currentUser?.uid;
                                if (userId == null) return;

                                final order = OrderModel(
                                  id: '',
                                  userId: userId,
                                  items: cart.items.values
                                      .map((i) => {
                                            'productId': i.product.id,
                                            'name': i.product.name,
                                            'quantity': i.quantity,
                                            'price': i.product.price,
                                          })
                                      .toList(),
                                  totalAmount: cart.totalAmount,
                                  timestamp: DateTime.now(),
                                  status: 'Processing',
                                );

                                await DatabaseService().placeOrder(order);
                                cart.clear();

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Order Placed Successfully!')),
                                  );
                                }
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            color: cart.totalAmount <= 0
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            "Checkout",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  /// 🔘 QUANTITY BUTTON
  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
