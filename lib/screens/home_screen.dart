import 'package:flutter/material.dart';
import 'package:babyshop/models/product.dart';
import 'package:babyshop/screens/product_detail_screen.dart';
import 'package:babyshop/screens/cart_screen.dart';
import 'package:babyshop/models/cart_manager.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest;

  const HomeScreen({super.key, this.isGuest = false});

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
    _pages = [
      HomeContent(isGuest: widget.isGuest),
      const ShopNowContent(),
      const SearchContent(),
      const CartScreen(),
      const AccountContent(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Shop Now',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
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
  final bool isGuest;

  const HomeContent({super.key, required this.isGuest});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();
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

  // Products Data
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Baby Lotion',
      image: 'assets/products/imgi_5_baby_lotion_125ml.jpg',
      price: 45.00,
      rating: 4.8,
      description: 'Gentle hydration for your little one. Keeps skin soft and smooth all day long.',
      brand: 'Bebble',
      category: 'Skincare',
    ),
    Product(
      id: '2',
      name: 'Baby Shampoo',
      image: 'assets/products/imgi_19_baby_shampoo_125ml.jpg',
      price: 35.00,
      rating: 4.7,
      description: 'Tear-free formula shampoo by Bebble. Cleanses gently without drying out the scalp.',
       brand: 'Bebble',
      category: 'Skincare',
    ),
    Product(
      id: '3',
      name: 'Baby Oil Lavender',
      image: 'assets/products/imgi_17_baby_oil_lavender_125ml.jpg',
      price: 45.00,
      rating: 4.9,
      description: 'Rich and nourishing body oil with calming lavender. Ideal for massage and locking in moisture.',
      brand: 'Bebble',
      category: 'Skincare',
    ),
     Product(
      id: '4',
      name: 'Sweet Almond Lotion',
      image: 'assets/products/imgi_14_sweet_almond_lotion_250ml.jpg',
      price: 55.00,
      rating: 4.9,
      description: 'Enriched with sweet almond oil, this lotion provides deep nourishment for delicate skin.',
      brand: 'Bebble',
      category: 'Skincare',
    ),
    Product(
      id: '5',
      name: 'Magic Diapers (S)',
      image: 'assets/products/imgi_29_Bona_Papa_Magic_Diapers_-_S-2_Mini_3-6kg_Mega_Pack_96_Pcs_180x.png',
      price: 25.00,
      rating: 4.6,
      description: 'Bona Papa Magic Diapers, Size S (3-6kg). Mega Pack 96 Pcs for long-lasting dryness.',
      brand: 'Bona Papa',
      category: 'Diapers',
    ),
    Product(
      id: '6',
      name: 'Mild Wipes',
      image: 'assets/products/imgi_35_64_mild_wipes.jpg',
      price: 15.00,
      rating: 4.5,
      description: 'Soft and mild wipes for easy cleaning. Pack of 64.',
      brand: 'Bebble',
      category: 'Diapers',
    ),
    Product(
      id: '7',
      name: 'Bottle Soap',
      image: 'assets/products/imgi_8_feeding_bottle_soap_450ml.jpg',
      price: 12.00,
      rating: 4.8,
      description: 'To gently clean feeding bottles, teats, and utensils. Safe and effective.',
      brand: 'Bebble',
      category: 'Food',
    ),
    Product(
      id: '8',
      name: 'Baby Soap Aloe',
      image: 'assets/products/imgi_15_baby_soap_alo_vera.jpg',
      price: 8.00,
      rating: 4.4,
      description: 'Creamy baby soap with Aloe Vera extract for soothing bath time.',
      brand: 'Bebble',
      category: 'Skincare',
    ),
      Product(
      id: '9',
      name: 'Magic Diapers (M)',
      image: 'assets/products/imgi_31_Bona_Papa_Magic_Diapers_-_M-3_Midi_5-10kg_Mega_Pack_88_Pcs_180x.png',
      price: 28.00,
      rating: 4.7,
      description: 'Bona Papa Magic Diapers, Size M (5-10kg). Mega Pack 88 Pcs.',
      brand: 'Bona Papa',
      category: 'Diapers',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
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
      body: SafeArea(
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
                     const Text(
                      'Hi Mitchal,',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () {},
                      color: Colors.black87,
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

                // Banner
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF53D3D1), // Green banner
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '\$60.00',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Facial Cream',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '20% off',
                                style: TextStyle(
                                  color: Color(0xFFE65100), // Orange
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: -10,
                        bottom: 10,
                        child: Image.asset(
                          'assets/product.png', // Reusing placeholder
                          height: 120,
                          width: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Positioned(
                         bottom: 12,
                         right: 140,
                         child: Row(
                           children: [
                             CircleAvatar(radius: 3, backgroundColor: Colors.white),
                             SizedBox(width: 4),
                             CircleAvatar(radius: 3, backgroundColor: Colors.white54),
                             SizedBox(width: 4),
                             CircleAvatar(radius: 3, backgroundColor: Colors.white54),
                           ],
                         ),
                      )
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
                              child: Icon(
                                Icons.favorite_border,
                                size: 20,
                                color: Colors.grey[400],
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Hero(
                                  tag: product.id,
                                  child: Image.asset(
                                    product.image,
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
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF53D3D1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
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
      ),
    );
  }
}

class AccountContent extends StatelessWidget {
  const AccountContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF53D3D1),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Account Page Placeholder')),
    );
  }
}

class ShopNowContent extends StatelessWidget {
  const ShopNowContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Now', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF53D3D1),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Shop Now Page Placeholder')),
    );
  }
}

class SearchContent extends StatelessWidget {
  const SearchContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF53D3D1),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Search Page Placeholder')),
    );
  }
}

class CartContent extends StatelessWidget {
  const CartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF53D3D1),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text('Cart Page Placeholder')),
    );
  }
}
