import 'package:flutter/material.dart';
import 'package:babyshop/models/order_manager.dart';
import 'package:babyshop/screens/order_detail_screen.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderManager = OrderManager();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FA),
      appBar: AppBar(
        title: const Text('Order History', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF53D3D1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: orderManager,
        builder: (context, child) {
          final orders = orderManager.orders;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(context, order);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final dateStr = DateFormat('MMM dd, yyyy').format(order.date);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: order),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _buildStatusBadge(order.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                dateStr,
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${order.items.length} Items',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF53D3D1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(
                      color: Color(0xFF53D3D1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Color(0xFF53D3D1), size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color color;
    String text;

    switch (status) {
      case OrderStatus.processing:
        color = Colors.orange;
        text = 'Processing';
        break;
      case OrderStatus.shipped:
        color = Colors.blue;
        text = 'Shipped';
        break;
      case OrderStatus.outForDelivery:
        color = Colors.purple;
        text = 'Out for Delivery';
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
