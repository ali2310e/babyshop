import 'package:flutter/material.dart';
import 'package:babyshop/models/order_manager.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FA),
      appBar: AppBar(
        title: Text('Order ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF53D3D1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tracking Section
            _buildTrackingSection(),
            const SizedBox(height: 24),
            
            // Order Items
            const Text(
              'Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F9FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(item.productImage),
                    ),
                    title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Qty: ${item.quantity}'),
                    trailing: Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            
            // Summary Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal', '\$${order.totalAmount.toStringAsFixed(2)}'),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Shipping', '\$5.00'),
                  const Divider(height: 32),
                  _buildSummaryRow(
                    'Total', 
                    '\$${(order.totalAmount + 5.0).toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildStatusStep(
            'Order Placed',
            'Your order has been received',
            order.date,
            true,
          ),
          _buildStatusStep(
            'Processing',
            'We are preparing your order',
            order.date.add(const Duration(minutes: 30)),
            order.status.index >= OrderStatus.processing.index,
          ),
          _buildStatusStep(
            'Shipped',
            'Order is on the way',
            null,
            order.status.index >= OrderStatus.shipped.index,
          ),
          _buildStatusStep(
            'Delivered',
            'Enjoy your purchase!',
            null,
            order.status.index >= OrderStatus.delivered.index,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep(String title, String subtitle, DateTime? time, bool isCompleted, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF53D3D1) : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: isCompleted ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(
                height: 40,
                width: 2,
                color: isCompleted ? const Color(0xFF53D3D1) : Colors.grey[200],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.black87 : Colors.grey,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isCompleted ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
        if (time != null)
          Text(
            DateFormat('HH:mm').format(time),
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
          ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black87 : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.bold,
            color: isTotal ? const Color(0xFF53D3D1) : Colors.black87,
          ),
        ),
      ],
    );
  }
}
