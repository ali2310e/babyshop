import 'package:flutter/material.dart';
import 'package:babyshop/models/cart_manager.dart';
import 'package:babyshop/models/order_manager.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartManager _cartManager = CartManager();
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF53D3D1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _completeOrder();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            Navigator.pop(context);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF53D3D1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_currentStep == 2 ? 'Place Order' : 'Continue'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Color(0xFF53D3D1)),
                      ),
                      child: const Text('Back', style: TextStyle(color: Color(0xFF53D3D1))),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Shipping'),
            isActive: _currentStep >= 0,
            content: Column(
              children: [
                _buildTextField('Full Name', Icons.person),
                const SizedBox(height: 16),
                _buildTextField('Address', Icons.location_on),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField('City', Icons.location_city)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Zip Code', Icons.pin_drop)),
                  ],
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Payment'),
            isActive: _currentStep >= 1,
            content: Column(
              children: [
                _buildTextField('Card Number', Icons.credit_card),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Expiry Date', Icons.calendar_today)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('CVV', Icons.lock)),
                  ],
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Review'),
            isActive: _currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ..._cartManager.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.quantity}x ${item.product.name}'),
                      Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                )),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text('\$${_cartManager.totalAmount.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping'),
                    Text('\$5.00'),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$${(_cartManager.totalAmount + 5.00).toStringAsFixed(2)}', 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF53D3D1))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF53D3D1)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF53D3D1), width: 2),
        ),
      ),
    );
  }

  void _completeOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading
      
      // Save order before clearing cart
      OrderManager().addOrder(_cartManager.items, _cartManager.totalAmount);
      
      _cartManager.clearCart();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Icon(Icons.check_circle, color: Color(0xFF53D3D1), size: 60),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Success!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text('Your order has been placed successfully.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Back to cart
                Navigator.pop(context); // Back to home (or pop until home)
              },
              child: const Text('Home', style: TextStyle(color: Color(0xFF53D3D1), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    });
  }
}
