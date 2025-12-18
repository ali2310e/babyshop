import 'package:flutter/material.dart';
import 'package:babyshop/models/product.dart';
import 'package:babyshop/screens/product_detail_screen.dart';
import 'package:babyshop/models/wishlist_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final WishlistManager _wishlistManager = WishlistManager();
  final List<Product> _allProducts = Product.sampleProducts;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _searchQuery.isEmpty
        ? <Product>[]
        : _allProducts.where((product) {
            final query = _searchQuery.toLowerCase();
            return product.name.toLowerCase().contains(query) ||
                product.brand.toLowerCase().contains(query) ||
                product.category.toLowerCase().contains(query);
          }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[400]),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: false,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search products, brands...',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                child: Icon(Icons.close, color: Colors.grey[400])),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button (Visual only for now)
                   Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF53D3D1), // Green filter button
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildEmptyState()
                  : _buildSearchResults(filteredProducts),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildSearchChip('Baby Lotion'),
              _buildSearchChip('Diapers'),
              _buildSearchChip('Wipes'),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Popular Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
           Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildSearchChip('Skincare'),
              _buildSearchChip('Clothing'),
              _buildSearchChip('Toys'),
               _buildSearchChip('Food'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
        setState(() {
          _searchQuery = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(product: product),
                ),
              );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                 BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Hero(
                    tag: 'search_${product.id}',
                    child: Image.asset(product.image, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.brand,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                         '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange, // Matching theme
                        ),
                      ),
                    ],
                  ),
                ),
                ListenableBuilder(
                  listenable: _wishlistManager,
                  builder: (context, child) {
                    final isInWishlist = _wishlistManager.isInWishlist(product);
                    return GestureDetector(
                      onTap: () => _wishlistManager.toggleWishlist(product),
                      child: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        size: 24,
                        color: isInWishlist ? Colors.red : Colors.grey[400],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
