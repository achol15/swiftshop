import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    /// 🔥 DEMO RELATED PRODUCTS (4 items)
    final List<Product> relatedProducts = [
      Product(
        id: "1",
        name: "Smart Watch",
        description: "Premium smartwatch with health tracking",
        price: 99.99,
        imageUrl:
            "https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b",
        category: "Electronics",
      ),
      Product(
        id: "2",
        name: "Headphones",
        description: "Noise cancelling wireless headphones",
        price: 149.99,
        imageUrl:
            "https://images.unsplash.com/photo-1518444028785-8c8b5f02c5b9",
        category: "Electronics",
      ),
      Product(
        id: "3",
        name: "Shoes",
        description: "Comfortable running shoes",
        price: 79.99,
        imageUrl:
            "https://images.unsplash.com/photo-1528701800489-20be3c6a1c2b",
        category: "Fashion",
      ),
      Product(
        id: "4",
        name: "Backpack",
        description: "Stylish everyday backpack",
        price: 59.99,
        imageUrl:
            "https://images.unsplash.com/photo-1585386959984-a41552262d63",
        category: "Accessories",
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔥 HERO IMAGE
            Stack(
              children: [
                Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                    height: 320,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                /// BACK BUTTON
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                )
              ],
            ),

            /// 🔥 PRODUCT INFO
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 6),

                  Text("\$${product.price}",
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  Text(product.description),

                  const SizedBox(height: 20),

                  /// ADD TO CART
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartProvider>().addItem(product);
                      },
                      child: const Text("Add to Cart"),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🔥 RELATED PRODUCTS TITLE
                  const Text(
                    "Related Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),

            /// 🔥 4 PRODUCT HORIZONTAL LIST
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: relatedProducts.length,
                itemBuilder: (context, index) {
                  final item = relatedProducts[index];

                  return GestureDetector(
                    onTap: () {
                      context.push('/product', extra: item);
                    },
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.only(left: 12, bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black12,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// IMAGE
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.network(
                              item.imageUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          /// INFO
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text("\$${item.price}",
                                    style: const TextStyle(
                                        color: Colors.deepPurple)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
