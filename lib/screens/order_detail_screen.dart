import 'package:flutter/material.dart';
import 'package:babyshop/models/order_manager.dart';
import 'package:intl/intl.dart';
import 'package:babyshop/widgets/product_image.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Track Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('ID: #${order.id.substring(order.id.length - 6).toUpperCase()}', 
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF53D3D1),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Status Banner
            _buildStatusHeader(),
            const SizedBox(height: 24),
            
            // Tracking Visual Section
            const Text('Order Journey', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTrackingTimeline(),
            const SizedBox(height: 32),
            
            // Order Summary
            const Text('Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  ...order.items.map((item) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      height: 55,
                      width: 55,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F9FA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ProductImage(imagePath: item.productImage),
                    ),
                    title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('Quantity: ${item.quantity}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    trailing: Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )).toList(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _summaryRow('Subtotal', '\$${order.totalAmount.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _summaryRow('Delivery Fee', '\$5.00'),
                        const Divider(height: 32),
                        _summaryRow('Total Paid', '\$${(order.totalAmount + 5.0).toStringAsFixed(2)}', isTotal: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            // Shipping Address
            const Text('Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.teal.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF53D3D1)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(order.address.isEmpty ? 'Home Address' : order.address, 
                      style: TextStyle(color: Colors.grey[700], height: 1.5)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF53D3D1), const Color(0xFF53D3D1).withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: const Color(0xFF53D3D1).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping, color: Colors.white, size: 40),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.status.name.toUpperCase(), 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Expected Arrival: ${DateFormat('MMM dd').format(order.date.add(const Duration(days: 3)))}', 
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _timelineStep('Order Confirmed', 'We have received your order', order.date, true),
          _timelineStep('Processing', 'Your order is being packed', null, order.status.index >= OrderStatus.processing.index),
          _timelineStep('On the Way', 'Our courier is delivering', null, order.status.index >= OrderStatus.shipped.index),
          _timelineStep('Delivered', 'Order reached destination', null, order.status.index >= OrderStatus.delivered.index, isLast: true),
        ],
      ),
    );
  }

  Widget _timelineStep(String title, String desc, DateTime? time, bool isDone, {bool isLast = false}) {
    final color = isDone ? const Color(0xFF53D3D1) : Colors.grey[200]!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: isDone ? const Color(0xFF53D3D1) : Colors.white,
                border: Border.all(color: color, width: 2),
                shape: BoxShape.circle,
              ),
              child: isDone ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(height: 50, width: 2, color: color),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDone ? Colors.black87 : Colors.grey)),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(fontSize: 12, color: isDone ? Colors.grey[600] : Colors.grey[400])),
              const SizedBox(height: 20),
            ],
          ),
        ),
        if (time != null)
          Text(DateFormat('hh:mm a').format(time), style: TextStyle(fontSize: 11, color: Colors.grey[400])),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isTotal ? Colors.black : Colors.grey[600], fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(color: isTotal ? const Color(0xFF53D3D1) : Colors.black, fontWeight: FontWeight.bold, fontSize: isTotal ? 18 : 14)),
      ],
    );
  }
}
