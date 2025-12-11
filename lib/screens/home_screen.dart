import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final bool isGuest;

  const HomeScreen({super.key, this.isGuest = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BabyShopHub'),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          if (isGuest)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                label: const Text('Guest'),
                backgroundColor: Colors.white,
              ),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              'Welcome to BabyShopHub!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (isGuest)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'You are browsing as a guest.\nSign in to access more features.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
