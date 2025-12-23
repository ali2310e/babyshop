import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final String description;

  final String category;
  final String brand;
  final List<Review> reviews;
  final Seller seller;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.description,
    required this.category,
    required this.brand,
    required this.reviews,
    required this.seller,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      rating: (data['rating'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      brand: data['brand'] ?? '',
      reviews: (data['reviews'] as List? ?? []).map((r) => Review.fromMap(r)).toList(),
      seller: Seller.fromMap(data['seller'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'rating': rating,
      'description': description,
      'category': category,
      'brand': brand,
      'reviews': reviews.map((r) => r.toMap()).toList(),
      'seller': seller.toMap(),
    };
  }

  void addReview(Review review) {
    reviews.insert(0, review);
  }

  static final List<Seller> sampleSellers = [
    Seller(name: 'BabyCare Official', rating: 4.8, totalSales: 1200, image: 'assets/logo.png'),
    Seller(name: 'Toddler Joy', rating: 4.5, totalSales: 850, image: 'assets/logo.png'),
    Seller(name: 'EcoBaby Store', rating: 4.9, totalSales: 3400, image: 'assets/logo.png'),
  ];

  static final List<Product> sampleProducts = [
    Product(
      id: '1',
      name: 'Organic Baby Food',
      image: 'assets/products/imgi_8_feeding_bottle_soap_450ml.jpg',
      price: 15.0,
      rating: 4.5,
      description: 'Healthy organic baby food made from fresh fruits and vegetables. Perfect for your baby\'s nutritional needs.',
      category: 'Food',
      brand: 'BabyFirst',
      seller: sampleSellers[0],
      reviews: [
        Review(user: 'Sarah M.', rating: 5.0, comment: 'Great quality, my baby loves it!'),
        Review(user: 'John D.', rating: 4.0, comment: 'Good variety but a bit pricey.'),
      ],
    ),
    Product(
      id: '2',
      name: 'Soft Cotton Diapers',
      image: 'assets/products/imgi_29_Bona_Papa_Magic_Diapers_-_S-2_Mini_3-6kg_Mega_Pack_96_Pcs_180x.png',
      price: 25.0,
      rating: 4.2,
      description: 'Premium soft cotton diapers providing comfort and leakage protection all day long.',
      category: 'Diapers',
      brand: 'SoftTouch',
      seller: sampleSellers[1],
      reviews: [
        Review(user: 'Emily R.', rating: 4.5, comment: 'Very soft and absorbent.'),
      ],
    ),
    Product(
      id: '3',
      name: 'Baby Sunscreen',
      image: 'assets/products/imgi_14_sweet_almond_lotion_250ml.jpg',
      price: 12.0,
      rating: 4.8,
      description: 'Gentle SPF 50 sunscreen formulated specifically for sensitive baby skin.',
      category: 'Skincare',
      brand: 'BabySafe',
      seller: sampleSellers[2],
      reviews: [
        Review(user: 'Jessica K.', rating: 5.0, comment: 'Perfect for summer! No rashes.'),
      ],
    ),
    Product(
      id: '4',
      name: 'Organic Cotton Onesie',
      image: 'assets/products/imgi_124_8961008217116_70b47519-ab6e-43d5-af00-69b2cb7cb9c6_245x.jpg',
      price: 20.0,
      rating: 4.7,
      description: 'Ultra-soft onesie made from 100% organic cotton. Hypoallergenic and breathable.',
      category: 'Clothing',
      brand: 'TinyThreads',
      seller: sampleSellers[0],
      reviews: [],
    ),
    Product(
      id: '5',
      name: 'Wooden Stacking Rings',
      image: 'assets/products/imgi_24_sweet_love.jpg',
      price: 18.0,
      rating: 4.9,
      description: 'Eco-friendly wooden toy that helps develop fine motor skills and color recognition.',
      category: 'Toys',
      brand: 'GreenPlay',
      seller: sampleSellers[2],
      reviews: [
        Review(user: 'Michael B.', rating: 5.0, comment: 'Excellent build quality, very safe.'),
      ],
    ),
  ];
}

class Review {
  final String user;
  final double rating;
  final String comment;

  Review({required this.user, required this.rating, required this.comment});

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      user: map['user'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'rating': rating,
      'comment': comment,
    };
  }
}

class Seller {
  final String name;
  final double rating;
  final int totalSales;
  final String image;

  Seller({
    required this.name,
    required this.rating,
    required this.totalSales,
    required this.image,
  });

  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      name: map['name'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalSales: map['totalSales'] ?? 0,
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rating': rating,
      'totalSales': totalSales,
      'image': image,
    };
  }
}
