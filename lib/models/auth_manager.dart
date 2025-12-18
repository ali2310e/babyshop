import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthManager extends ChangeNotifier {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  bool _isGuest = false;

  AuthManager._internal() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null && !user.isAnonymous) {
        _isGuest = false;
      }
      notifyListeners();
    });
  }

  bool get isLoggedIn => _user != null || _isGuest;
  String get userName => _user?.displayName ?? (_isGuest ? 'Guest' : '');
  String get email => _user?.email ?? '';
  bool get isGuest => _isGuest || (_user?.isAnonymous ?? false);
  String get uid => _user?.uid ?? '';

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Update Auth Display Name
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      
      // Store in Firestore
      await _firestore.collection('users').doc(credential.user?.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _user = _auth.currentUser;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginAsGuest() async {
    try {
      await _auth.signInAnonymously();
      _isGuest = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _isGuest = false;
    notifyListeners();
  }
}
