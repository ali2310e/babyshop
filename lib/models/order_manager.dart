import 'package:flutter/foundation.dart';
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
  final Product product;
  final int quantity;
  final double price;

  OrderItem({
    required this.product,
    required this.quantity,
    required this.price,
  });
}

class Order {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime date;
  final OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
    required this.status,
  });
}

class OrderManager extends ChangeNotifier {
  static final OrderManager _instance = OrderManager._internal();

  factory OrderManager() {
    return _instance;
  }

  OrderManager._internal();

  final List<Order> _orders = [
    // Dummy initial order for demonstration
    Order(
      id: 'ORD-5521',
      date: DateTime.now().subtract(const Duration(days: 2)),
      totalAmount: 145.00,
      status: OrderStatus.delivered,
      items: [
        OrderItem(
          product: Product.sampleProducts[0],
          quantity: 2,
          price: Product.sampleProducts[0].price,
        ),
      ],
    ),
  ];

  List<Order> get orders => List.unmodifiable(_orders.reversed.toList());

  void addOrder(List<CartItem> cartItems, double total) {
    final newOrder = Order(
      id: 'ORD-${1000 + _orders.length + 1}',
      date: DateTime.now(),
      totalAmount: total,
      status: OrderStatus.processing,
      items: cartItems.map((item) => OrderItem(
        product: item.product,
        quantity: item.quantity,
        price: item.product.price,
      )).toList(),
    );
    _orders.add(newOrder);
    notifyListeners();
  }
}
