import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshop/models/user_profile.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FA),
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? [];
          
          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final profile = UserProfile.fromFirestore(docs[index]);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: profile.isAdmin ? Colors.orange : const Color(0xFF53D3D1),
                    child: Icon(profile.isAdmin ? Icons.admin_panel_settings : Icons.person, color: Colors.white),
                  ),
                  title: Text(profile.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(profile.email),
                  trailing: profile.isAdmin 
                    ? const Chip(label: Text('Admin', style: TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: Colors.orange)
                    : IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => _showUserOptions(context, profile),
                      ),
                  onTap: () => _viewUserDetail(context, profile),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _viewUserDetail(BuildContext context, UserProfile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('User Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _detailRow('Name', profile.name),
            _detailRow('Email', profile.email),
            _detailRow('UID', profile.uid),
            _detailRow('Role', profile.isAdmin ? 'Administrator' : 'Customer'),
            const SizedBox(height: 20),
            const Text('Saved Addresses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: profile.addresses.isEmpty 
                ? const Text('No addresses saved.')
                : ListView.builder(
                    itemCount: profile.addresses.length,
                    itemBuilder: (context, i) => ListTile(
                      title: Text(profile.addresses[i].label),
                      subtitle: Text('${profile.addresses[i].street}, ${profile.addresses[i].city}'),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showUserOptions(BuildContext context, UserProfile profile) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: Colors.orange),
            title: const Text('Promote to Admin'),
            onTap: () async {
              await FirebaseFirestore.instance.collection('users').doc(profile.uid).update({'role': 'admin'});
              if (context.mounted) Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Disable Account'),
            onTap: () {
               // Placeholder for disable logic
               Navigator.pop(context);
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User disabled (Simulated)')));
            },
          ),
        ],
      ),
    );
  }
}
