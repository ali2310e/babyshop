import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final bool isAdmin;
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.isAdmin = false,
    this.addresses = const [],
    this.paymentMethods = const [],
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      isAdmin: data['role'] == 'admin',
      addresses: (data['addresses'] as List? ?? [])
          .map((item) => Address.fromMap(item))
          .toList(),
      paymentMethods: (data['paymentMethods'] as List? ?? [])
          .map((item) => PaymentMethod.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'addresses': addresses.map((a) => a.toMap()).toList(),
      'paymentMethods': paymentMethods.map((p) => p.toMap()).toList(),
    };
  }
}

class Address {
  final String id;
  final String label; // e.g., Home, Office
  final String street;
  final String city;
  final String state;
  final String zip;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    this.isDefault = false,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'isDefault': isDefault,
    };
  }
}

class PaymentMethod {
  final String id;
  final String cardHolderName;
  final String cardNumber; // Masked e.g. **** **** **** 1234
  final String expiryDate;
  final String cardType; // Visa, Mastercard, etc.
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardType,
    this.isDefault = false,
  });

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] ?? '',
      cardHolderName: map['cardHolderName'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cardType: map['cardType'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardType': cardType,
      'isDefault': isDefault,
    };
  }
}
