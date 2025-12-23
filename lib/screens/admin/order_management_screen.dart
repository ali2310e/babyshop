import 'package:flutter/material.dart';
import 'package:babyshop/models/order_manager.dart';
import 'package:intl/intl.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FA),
      appBar: AppBar(
        title: const Text('Order Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<List<Order>>(
        stream: OrderManager().allOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order #${order.id.substring(0, 6)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          _statusChip(order.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(DateFormat('MMM dd, yyyy HH:mm').format(order.date), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(),
                      ),
                      
                      const Text('Customer Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 16, color: Colors.teal),
                          const SizedBox(width: 8),
                          Text(order.customerName, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 16, color: Colors.teal),
                          const SizedBox(width: 8),
                          Text(order.email, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.teal),
                          const SizedBox(width: 8),
                          Expanded(child: Text(order.address, style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                      
                      const Divider(height: 32),
                      const Text('Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item.quantity}x ${item.productName}', style: const TextStyle(fontSize: 14)),
                            Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                          ],
                        ),
                      )).toList(),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('\$${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _updateStatus(context, order),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Update Order Status'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _statusChip(OrderStatus status) {
    Color color;
    switch (status) {
      case OrderStatus.delivered: color = Colors.green; break;
      case OrderStatus.cancelled: color = Colors.red; break;
      case OrderStatus.processing: color = Colors.blue; break;
      default: color = Colors.orange;
    }
    return Chip(
      label: Text(status.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10)),
      backgroundColor: color,
    );
  }

  void _updateStatus(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: OrderStatus.values.map((status) => ListTile(
          title: Text(status.name.toUpperCase()),
          onTap: () async {
            await OrderManager().updateOrderStatus(order.id, status);
            if (context.mounted) Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }
}
