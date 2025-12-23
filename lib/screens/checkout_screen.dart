import 'package:flutter/material.dart';
import 'package:babyshop/models/cart_manager.dart';
import 'package:babyshop/models/order_manager.dart';
import 'package:babyshop/models/auth_manager.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartManager _cartManager = CartManager();
  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = AuthManager().profile;
    if (profile != null) {
      _nameController.text = profile.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
                _buildTextField('Full Name', Icons.person, _nameController),
                const SizedBox(height: 16),
                _buildTextField('Phone Number', Icons.phone, _phoneController),
                const SizedBox(height: 16),
                _buildTextField('Address', Icons.location_on, _addressController),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField('City', Icons.location_city, _cityController)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Zip Code', Icons.pin_drop, _zipController)),
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
                _buildTextField('Card Number', Icons.credit_card, null),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Expiry Date', Icons.calendar_today, null)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('CVV', Icons.lock, null)),
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

  Widget _buildTextField(String label, IconData icon, TextEditingController? controller) {
    return TextFormField(
      controller: controller,
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

  void _completeOrder() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final auth = AuthManager();
      final fullAddress = '${_addressController.text}, ${_cityController.text} - ${_zipController.text}';
      
      // Save order before clearing cart
      await OrderManager().addOrder(
        userId: auth.uid,
        customerName: _nameController.text.trim().isEmpty ? auth.userName : _nameController.text.trim(),
        email: auth.email,
        phone: _phoneController.text.trim(),
        address: fullAddress,
        cartItems: _cartManager.items,
        total: _cartManager.totalAmount + 5.0,
      );
      
      _cartManager.clearCart();
      if (mounted) Navigator.pop(context); // Close loading

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
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Home', style: TextStyle(color: Color(0xFF53D3D1), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
      }
    }
  }
}
