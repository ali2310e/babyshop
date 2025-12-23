import 'package:flutter/material.dart';
import 'package:babyshop/models/order_manager.dart';
import 'package:babyshop/models/auth_manager.dart';
import 'package:babyshop/models/user_profile.dart';
import 'package:intl/intl.dart';
import 'package:babyshop/widgets/product_image.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F7), // Slightly deeper grey for contrast
      appBar: AppBar(
        title: const Text('Order Control Panel', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: StreamBuilder<List<Order>>(
        stream: OrderManager().allOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          }
          if (snapshot.hasError) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                Text('Error loading orders: ${snapshot.error}'),
              ],
            ));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
                const Text('No orders to manage yet.', style: TextStyle(color: Colors.grey)),
              ],
            ));
          }

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Order ID & Status
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ORDER #${order.id.substring(order.id.length - 6).toUpperCase()}', 
                                style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(DateFormat('MMM dd, yyyy • hh:mm a').format(order.date), 
                                style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                            ],
                          ),
                          _statusBadge(order.status),
                        ],
                      ),
                    ),

                    // Customer Info Section (Dynamic Fetch)
                    FutureBuilder<UserProfile?>(
                      future: AuthManager().getUserProfile(order.userId),
                      builder: (context, userSnapshot) {
                        final user = userSnapshot.data;
                        final name = (user?.name != null && user!.name.isNotEmpty) ? user.name : order.customerName;
                        final email = (user?.email != null && user!.email.isNotEmpty) ? user.email : order.email;
                        
                        String phone = 'No phone';
                        if (user != null && user.phone.isNotEmpty) {
                          phone = user.phone;
                        } else if (order.phone.isNotEmpty) {
                          phone = order.phone;
                        }

                        String address = 'No address';
                        if (order.address.isNotEmpty) {
                          address = order.address;
                        } else if (user != null && user.addresses.isNotEmpty) {
                          address = user.addresses.first.street;
                        }

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFEDF2F7)),
                          ),
                          child: userSnapshot.connectionState == ConnectionState.waiting
                            ? const Center(child: LinearProgressIndicator(minHeight: 2))
                            : Column(
                                children: [
                                  _infoRow(Icons.person_rounded, name, isPrimary: true),
                                  const SizedBox(height: 12),
                                  _infoRow(Icons.alternate_email_rounded, email.isEmpty ? 'No email' : email),
                                  const SizedBox(height: 8),
                                  _infoRow(Icons.phone_iphone_rounded, phone),
                                  const SizedBox(height: 8),
                                  _infoRow(Icons.local_shipping_rounded, address),
                                ],
                              ),
                        );
                      },
                    ),

                    // Items Section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ITEMS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey)),
                          const SizedBox(height: 10),
                          ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ProductImage(imagePath: item.productImage),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                      Text('Qty: ${item.quantity}', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                                    ],
                                  ),
                                ),
                                Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          )).toList(),
                        ],
                      ),
                    ),

                    // Footer: Total & Actions
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('TOTAL PAYABLE', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                              Text('\$${order.totalAmount.toStringAsFixed(2)}', 
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.orange)),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _updateStatus(context, order),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[600],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Row(
                              children: [
                                Text('Update Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, {bool isPrimary = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: isPrimary ? Colors.teal : Colors.grey[400]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isPrimary ? 14 : 12,
              fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
              color: isPrimary ? Colors.black87 : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(OrderStatus status) {
    Color color;
    IconData icon;
    switch (status) {
      case OrderStatus.delivered: color = Colors.green; icon = Icons.check_circle_rounded; break;
      case OrderStatus.cancelled: color = Colors.red; icon = Icons.cancel_rounded; break;
      case OrderStatus.processing: color = Colors.blue; icon = Icons.sync_rounded; break;
      case OrderStatus.shipped: color = Colors.purple; icon = Icons.local_shipping_rounded; break;
      case OrderStatus.outForDelivery: color = Colors.orange; icon = Icons.delivery_dining_rounded; break;
      default: color = Colors.grey; icon = Icons.help_outline_rounded;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(status.name.toUpperCase(), 
            style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  void _updateStatus(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Update Order Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...OrderStatus.values.map((status) {
              final isSelected = order.status == status;
              return ListTile(
                leading: Icon(Icons.circle, color: isSelected ? Colors.teal : Colors.grey[200], size: 12),
                title: Text(status.name.toUpperCase(), 
                  style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                onTap: () async {
                  await OrderManager().updateOrderStatus(order.id, status);
                  if (context.mounted) Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
