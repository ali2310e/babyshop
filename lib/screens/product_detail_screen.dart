import 'package:flutter/material.dart';
import 'package:babyshop/models/product.dart';
import 'package:babyshop/models/cart_manager.dart';
import 'package:babyshop/models/wishlist_manager.dart';
import 'package:babyshop/screens/home_screen.dart'; // Import HomeScreen
import 'package:babyshop/widgets/product_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final WishlistManager _wishlistManager = WishlistManager();
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
          ListenableBuilder(
            listenable: _wishlistManager,
            builder: (context, child) {
              final isInWishlist = _wishlistManager.isInWishlist(widget.product);
              return IconButton(
                onPressed: () => _wishlistManager.toggleWishlist(widget.product),
                icon: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWishlist ? Colors.red : Colors.white,
                ),
              );
            },
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
                    child: ProductImage(
                      imagePath: widget.product.image,
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
                children: [
                  Expanded(
                    child: SingleChildScrollView(
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
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Seller Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFF53D3D1).withOpacity(0.1),
                                  child: Icon(Icons.store, color: const Color(0xFF53D3D1)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.product.seller.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${widget.product.seller.totalSales}+ Sales',
                                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.orange, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          widget.product.seller.rating.toString(),
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'Seller Rating',
                                      style: TextStyle(color: Colors.grey, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Customer Reviews',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (widget.product.reviews.isEmpty)
                            const Text('No reviews yet.', style: TextStyle(color: Colors.grey))
                          else
                            ...widget.product.reviews.map((review) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            review.user,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.orange, size: 14),
                                              const SizedBox(width: 4),
                                              Text(
                                                review.rating.toString(),
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        review.comment,
                                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                      ),
                                    ],
                                  ),
                                )).toList(), // Added .toList() to ensure it's a list of widgets
                          const SizedBox(height: 16),
                          _buildAddReviewForm(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Moved this outside the SingleChildScrollView's Column
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

  Widget _buildAddReviewForm() {
    final nameController = TextEditingController();
    final commentController = TextEditingController();
    double selectedRating = 5.0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF53D3D1).withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF53D3D1).withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Your Review',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () => setState(() => selectedRating = index + 1.0),
                    icon: Icon(
                      Icons.star,
                      color: index < selectedRating ? Colors.orange : Colors.grey[300],
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.only(right: 8),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Your Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && commentController.text.isNotEmpty) {
                      widget.product.addReview(Review(
                        user: nameController.text,
                        rating: selectedRating,
                        comment: commentController.text,
                      ));
                      nameController.clear();
                      commentController.clear();
                      this.setState(() {}); // Refresh main screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Review submitted! Thank you.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF53D3D1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Post Review'),
                ),
              ),
            ],
          ),
        );
      },
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
