import 'package:flutter/material.dart';
import 'package:babyshop/screens/admin/product_management_screen.dart';
import 'package:babyshop/screens/admin/user_management_screen.dart';
import 'package:babyshop/screens/admin/order_management_screen.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FA),
      appBar: AppBar(
        title: const Text('Admin Panel', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildAdminCard(
              context,
              icon: Icons.inventory_2_outlined,
              title: 'Products',
              subtitle: 'Manage Listings',
              color: Colors.blue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductManagementScreen())),
            ),
            _buildAdminCard(
              context,
              icon: Icons.people_outline,
              title: 'Users',
              subtitle: 'Manage Accounts',
              color: Colors.green,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UserManagementScreen())),
            ),
            _buildAdminCard(
              context,
              icon: Icons.shopping_cart_outlined,
              title: 'Orders',
              subtitle: 'Monitor Status',
              color: Colors.orange,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderManagementScreen())),
            ),
            _buildAdminCard(
              context,
              icon: Icons.analytics_outlined,
              title: 'Analytics',
              subtitle: 'View Reports',
              color: Colors.purple,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Analytics coming soon!')));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
