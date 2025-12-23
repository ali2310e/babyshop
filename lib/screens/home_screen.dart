import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshop/models/product.dart';
import 'package:babyshop/screens/product_detail_screen.dart';
import 'package:babyshop/screens/account_screen.dart';
import 'package:babyshop/screens/shop_screen.dart';
import 'package:babyshop/screens/search_screen.dart';
import 'package:babyshop/screens/cart_screen.dart';
import 'package:babyshop/screens/wishlist_screen.dart';
import 'package:babyshop/models/cart_manager.dart';
import 'package:babyshop/models/auth_manager.dart';
import 'package:babyshop/models/wishlist_manager.dart';
import 'package:babyshop/widgets/product_image.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of pages for each tab
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pages = [

      HomeContent(onWishlistTap: () => setState(() => _currentIndex = 1)),
      const WishlistScreen(),
      const ShopScreen(),
      const SearchScreen(),
      const CartScreen(),
      const AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF53D3D1), // Teal
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
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

// --- Content Widgets ---

class HomeContent extends StatefulWidget {
  final VoidCallback onWishlistTap;
  const HomeContent({super.key, required this.onWishlistTap});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  final WishlistManager _wishlistManager = WishlistManager();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Skincare',
    'Clothing',
    'Toys',
    'Food',
    'Diapers'
  ];

  // Slider Data
  final List<String> _sliderImages = [
    'assets/slider/imgi_1_8f9159bf-1000-48e3-a7c1-4378a3e34e48.png',
    'assets/slider/imgi_20_baby-shop-horizontal-banner-template-design-2fc1f89a7c07762713632b0c6970ed94_screen.jpg',
  ];

  int _currentSliderPage = 0;
  final PageController _pageController = PageController();
  Timer? _sliderTimer;

  @override
  void initState() {
    super.initState();
    _startSliderTimer();
  }

  void _startSliderTimer() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentSliderPage + 1;
        if (nextPage >= _sliderImages.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Products Data
  final List<Product> _products = Product.sampleProducts;

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    _sliderTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter Products
    final filteredProducts = _products.where((product) {
      final matchQuery = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchCategory = _selectedCategory == 'All' || product.category == _selectedCategory;

      return matchQuery && matchCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          final products = snapshot.data?.docs.map((doc) => Product.fromFirestore(doc)).toList() ?? _products;
          
          final filteredProducts = products.where((product) {
            final matchQuery = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                product.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                product.category.toLowerCase().contains(_searchQuery.toLowerCase());
            
            final matchCategory = _selectedCategory == 'All' || product.category == _selectedCategory;

            return matchQuery && matchCategory;
          }).toList();

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     ListenableBuilder(
                        listenable: AuthManager(),
                        builder: (context, child) {
                          return Text(
                            'Hi ${AuthManager().userName},',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          );
                        },
                      ),
                    Row(
                      children: [
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              onPressed: widget.onWishlistTap,
                              color: Colors.black87,
                            ),
                            ListenableBuilder(
                              listenable: _wishlistManager,
                              builder: (context, child) {
                                if (_wishlistManager.items.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF53D3D1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${_wishlistManager.items.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.shopping_cart_outlined),
                              onPressed: () {
                                // Navigate to cart tab or screen? 
                                // Since we are in HomeContent, maybe we should tell the parent to switch tab
                                // but for now let's just push a screen for simplicity or if the user wants it.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CartScreen()),
                                );
                              },
                              color: Colors.black87,
                            ),
                            ListenableBuilder(
                              listenable: CartManager(),
                              builder: (context, child) {
                                if (CartManager().items.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${CartManager().items.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Search Bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey[400]),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                const SizedBox(height: 24),

                // Banner Slider
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentSliderPage = index;
                          });
                        },
                        itemCount: _sliderImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(_sliderImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _sliderImages.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentSliderPage == index ? 20 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentSliderPage == index
                                    ? const Color(0xFF53D3D1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Categories Screen
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF53D3D1)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Popular Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(color: Color(0xFF53D3D1)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: ListenableBuilder(
                                listenable: _wishlistManager,
                                builder: (context, child) {
                                  final isInWishlist = _wishlistManager.isInWishlist(product);
                                  return GestureDetector(
                                    onTap: () {
                                      _wishlistManager.toggleWishlist(product);
                                    },
                                    child: Icon(
                                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                                      size: 20,
                                      color: isInWishlist ? Colors.red : Colors.grey[400],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Hero(
                                  tag: product.id,
                                  child: ProductImage(
                                    imagePath: product.image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF53D3D1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      CartManager().addToCart(product);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Added ${product.name} to cart'),
                                          backgroundColor:
                                              const Color(0xFF53D3D1), // Teal
                                          duration:
                                              const Duration(milliseconds: 500),
                                        ),
                                      );
                                    },
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
);
}
}

// (Removed placeholder classes)
