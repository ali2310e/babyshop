import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshop/models/product.dart';
import 'package:babyshop/models/cart_manager.dart';

enum OrderStatus {
  processing,
  shipped,
  outForDelivery,
  delivered,
  cancelled
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'price': price,
    };
  }
}

class Order {
  final String id;
  final String userId;
  final String customerName;
  final String email;
  final String phone;
  final String address;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime date;
  final OrderStatus status;

  Order({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.address,
    required this.items,
    required this.totalAmount,
    required this.date,
    required this.status,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      userId: data['userId'] ?? '',
      customerName: data['customerName'] ?? 'Unknown',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      date: (data['date'] as Timestamp? ?? Timestamp.now()).toDate(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == data['status'], 
        orElse: () => OrderStatus.processing
      ),
      items: (data['items'] as List? ?? []).map((i) => OrderItem.fromMap(i)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'customerName': customerName,
      'email': email,
      'phone': phone,
      'address': address,
      'totalAmount': totalAmount,
      'date': Timestamp.fromDate(date),
      'status': status.toString(),
      'items': items.map((i) => i.toMap()).toList(),
    };
  }
}

class OrderManager extends ChangeNotifier {
  static final OrderManager _instance = OrderManager._internal();

  factory OrderManager() {
    return _instance;
  }

  OrderManager._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Order>> userOrders(String userId) {
    return _firestore.collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList());
  }

  Stream<List<Order>> get allOrders {
    return _firestore.collection('orders')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList());
  }

  Future<void> addOrder({
    required String userId,
    required List<CartItem> cartItems,
    required double total,
    required String customerName,
    required String email,
    required String phone,
    required String address,
  }) async {
    final newOrderData = {
      'userId': userId,
      'customerName': customerName,
      'email': email,
      'phone': phone,
      'address': address,
      'date': Timestamp.now(),
      'totalAmount': total,
      'status': OrderStatus.processing.toString(),
      'items': cartItems.map((item) => {
        'productId': item.product.id,
        'productName': item.product.name,
        'productImage': item.product.image,
        'quantity': item.quantity,
        'price': item.product.price,
      }).toList(),
    };
    await _firestore.collection('orders').add(newOrderData);
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status.toString(),
    });
  }
}
