import 'package:flutter/material.dart';
import 'package:babyshop/models/product.dart';
import 'package:babyshop/models/cart_manager.dart';
import 'package:babyshop/screens/home_screen.dart'; // Import HomeScreen

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF53D3D1), // Main green background
      appBar: AppBar(
        title: const Text('Details', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Section with Image
          Expanded(
            flex: 4, // Takes up appropriate space
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background curve or circle could be added here
                Positioned(
                  bottom: 20,
                  child: Hero(
                    tag: widget.product.id,
                    child: Image.asset(
                      widget.product.image,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Section with Details
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          widget.product.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) setState(() => quantity--);
                              },
                              icon: const Icon(Icons.remove, color: Colors.white),
                              constraints: const BoxConstraints(),
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() => quantity++);
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${(widget.product.price * quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          CartManager().addToCart(widget.product,
                              quantity: quantity);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Added $quantity ${widget.product.name} to cart'),
                              backgroundColor: const Color(0xFF53D3D1), // Teal
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF53D3D1), // Green button
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Default to Home or none
        onTap: (index) {
          // Navigate to Home and select the tab
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => _HomeScreenWrapper(initialIndex: index)),
            (route) => false,
          );
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.grey, // Not selected
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Shop Now',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: ListenableBuilder(
              listenable: CartManager(),
              builder: (context, child) {
                return Badge(
                  isLabelVisible: CartManager().items.isNotEmpty,
                  label: Text('${CartManager().items.length}'),
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
// Wrapper to allow passing initial index to HomeScreen
class _HomeScreenWrapper extends StatelessWidget {
  final int initialIndex;

  const _HomeScreenWrapper({required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return HomeScreen(initialIndex: initialIndex);
  }
}
