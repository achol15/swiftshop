import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../services/database_service.dart';
import '../../providers/cart_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentBanner = 0;
  String searchText = "";
  bool isSearchFocused = false;

  final FocusNode _focusNode = FocusNode();

  final List<String> banners = [
    "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da",
    "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d",
    "https://images.unsplash.com/photo-1607083206968-13611e3d76db",
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isSearchFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();

    return DefaultTabController(
        length: 1,
        child: Scaffold(
          backgroundColor: Colors.grey[100],

          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "SwiftShop",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              /// CART WITH BADGE
              Consumer<CartProvider>(
                builder: (_, cart, __) {
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () => context.push('/cart'),
                      ),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '${cart.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(width: 8),
            ],
          ),

          /// BODY
          body: StreamBuilder<List<Product>>(
            stream: db.streamProducts(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = snapshot.data!
                  .where((p) =>
                      p.name.toLowerCase().contains(searchText.toLowerCase()))
                  .toList();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    /// ANIMATED SEARCH BAR
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isSearchFocused
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.25)
                                  : Colors.black12,
                              blurRadius: isSearchFocused ? 18 : 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          focusNode: _focusNode,
                          onChanged: (value) {
                            setState(() => searchText = value);
                          },
                          decoration: const InputDecoration(
                            hintText: "Search products...",
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// BANNER
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 180,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        onPageChanged: (index, reason) {
                          setState(() => _currentBanner = index);
                        },
                      ),
                      items: banners.map((url) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 10),

                    /// INDICATOR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        banners.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentBanner == index ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentBanner == index
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    /// IMPROVED PRODUCT GRID
                    GridView.builder(
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 250 + (index * 80)),
                          tween: Tween(begin: 0.9, end: 1.0),
                          builder: (_, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: child,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(18),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: product.imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            shape: BoxShape.circle,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 6,
                                              )
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.favorite_border,
                                              size: 18,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 32,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<CartProvider>()
                                                .addItem(product);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 2,
                                          ),
                                          child: const Text(
                                            "Add",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
