class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final String description;

  final String category;
  final String brand;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.description,
    required this.category,
    required this.brand,
  });

  static List<Product> get sampleProducts => [
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
}
