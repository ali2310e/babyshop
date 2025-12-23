import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshop/models/user_profile.dart';

class AuthManager extends ChangeNotifier {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  UserProfile? _profile;
  bool _isGuest = false;

  AuthManager._internal() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null && !user.isAnonymous) {
        _isGuest = false;
        _listenToProfile(user.uid);
      } else {
        _profile = null;
        notifyListeners();
      }
    });
  }

  void _listenToProfile(String uid) {
    _firestore.collection('users').doc(uid).snapshots().listen((doc) {
      if (doc.exists) {
        _profile = UserProfile.fromFirestore(doc);
      } else {
        _profile = null;
      }
      notifyListeners();
    });
  }

  bool get isLoggedIn => _user != null || _isGuest;
  String get userName => _profile?.name ?? _user?.displayName ?? (_isGuest ? 'Guest' : 'User');
  String get email => _user?.email ?? '';
  bool get isGuest => _isGuest || (_user?.isAnonymous ?? false);
  bool get isAdmin => _profile?.isAdmin ?? false;
  String get uid => _user?.uid ?? '';
  UserProfile? get profile => _profile;

  Future<void> signIn(String email, String password) async {
    try {
      print('Attempting to sign in: $email');
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Sign in successful: ${credential.user?.uid}');
      // Update last login
      await _firestore.collection('users').doc(credential.user?.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
      print('Last login updated in Firestore');
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during sign in: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('Unexpected error during sign in: $e');
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      print('Attempting to sign up: $email');
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print('Auth User created: ${credential.user?.uid}');
      
      // Update Auth Display Name
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      
      // Store in Firestore
      print('Storing user profile in Firestore...');
      await _firestore.collection('users').doc(credential.user?.uid).set({
        'name': name,
        'email': email,
        'role': 'customer',
        'addresses': [],
        'paymentMethods': [],
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
      print('User profile stored successfully');

      _user = _auth.currentUser;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during sign up: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('Unexpected error during sign up: $e');
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> updateProfile({required String name}) async {
    if (_user == null) return;
    try {
      await _firestore.collection('users').doc(_user!.uid).update({'name': name});
      await _user!.updateDisplayName(name);
    } catch (e) {
      throw 'Failed to update profile: $e';
    }
  }

  Future<void> addAddress(Address address) async {
    if (_user == null) return;
    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'addresses': FieldValue.arrayUnion([address.toMap()])
      });
    } catch (e) {
      throw 'Failed to add address: $e';
    }
  }

  Future<void> removeAddress(Address address) async {
    if (_user == null) return;
    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'addresses': FieldValue.arrayRemove([address.toMap()])
      });
    } catch (e) {
      throw 'Failed to remove address: $e';
    }
  }

  Future<void> addPaymentMethod(PaymentMethod paymentMethod) async {
    if (_user == null) return;
    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'paymentMethods': FieldValue.arrayUnion([paymentMethod.toMap()])
      });
    } catch (e) {
      throw 'Failed to add payment method: $e';
    }
  }

  Future<void> removePaymentMethod(PaymentMethod paymentMethod) async {
    if (_user == null) return;
    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'paymentMethods': FieldValue.arrayRemove([paymentMethod.toMap()])
      });
    } catch (e) {
      throw 'Failed to remove payment method: $e';
    }
  }

  Future<void> loginAsGuest() async {
    try {
      await _auth.signInAnonymously();
      _isGuest = true;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _isGuest = false;
    _profile = null;
    notifyListeners();
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
