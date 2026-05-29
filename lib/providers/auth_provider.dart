import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DbService _dbService = DbService();

  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  StreamSubscription<UserModel?>? _userSubscription;

  AuthProvider() {
    // Listen to Auth State changes
    _authService.userStream.listen((User? user) {
      _firebaseUser = user;
      if (user != null) {
        // Stream Firestore user document
        _userSubscription?.cancel();
        _userSubscription = _dbService.streamUserProfile(user.uid).listen((UserModel? profile) {
          _userModel = profile;
          notifyListeners();
        });
      } else {
        _userModel = null;
        _userSubscription?.cancel();
        _userSubscription = null;
        notifyListeners();
      }
      notifyListeners();
    });
  }

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  // Login
  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      await _authService.loginWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Register
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    setLoading(true);
    try {
      await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    setLoading(true);
    try {
      _userSubscription?.cancel();
      _userSubscription = null;
      _userModel = null;
      _firebaseUser = null;
      await _authService.logout();
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // --- PROFILE MANAGEMENT ---

  // Update personal information
  Future<void> updatePersonalInfo({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    if (_userModel == null) return;
    setLoading(true);
    try {
      final updatedUser = _userModel!.copyWith(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        phone: phone.trim(),
      );
      await _dbService.updateUserProfile(updatedUser);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Add a shipping address
  Future<void> addAddress(AddressModel newAddress) async {
    if (_userModel == null) return;
    setLoading(true);
    try {
      final List<AddressModel> updatedAddresses = List.from(_userModel!.addresses);
      
      // If setting as default, set all others to false
      if (newAddress.isDefault) {
        for (int i = 0; i < updatedAddresses.length; i++) {
          updatedAddresses[i] = updatedAddresses[i].copyWith(isDefault: false);
        }
      }
      
      updatedAddresses.add(newAddress);
      final updatedUser = _userModel!.copyWith(addresses: updatedAddresses);
      await _dbService.updateUserProfile(updatedUser);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Set default address
  Future<void> setDefaultAddress(String addressId) async {
    if (_userModel == null) return;
    setLoading(true);
    try {
      final List<AddressModel> updatedAddresses = _userModel!.addresses.map((addr) {
        return addr.copyWith(isDefault: addr.id == addressId);
      }).toList();

      final updatedUser = _userModel!.copyWith(addresses: updatedAddresses);
      await _dbService.updateUserProfile(updatedUser);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Delete address
  Future<void> deleteAddress(String addressId) async {
    if (_userModel == null) return;
    setLoading(true);
    try {
      final List<AddressModel> updatedAddresses = _userModel!.addresses
          .where((addr) => addr.id != addressId)
          .toList();

      // If we deleted the default, set first remaining as default if list is not empty
      if (updatedAddresses.isNotEmpty && !_userModel!.addresses.firstWhere((a) => a.id == addressId).isDefault) {
        // didn't delete default
      } else if (updatedAddresses.isNotEmpty) {
        updatedAddresses[0] = updatedAddresses[0].copyWith(isDefault: true);
      }

      final updatedUser = _userModel!.copyWith(addresses: updatedAddresses);
      await _dbService.updateUserProfile(updatedUser);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Add card details
  Future<void> addPaymentCard(PaymentCardModel newCard) async {
    if (_userModel == null) return;
    setLoading(true);
    try {
      final List<PaymentCardModel> updatedCards = List.from(_userModel!.paymentCards);
      
      // If setting as default, set all others to false
      if (newCard.isDefault) {
        for (int i = 0; i < updatedCards.length; i++) {
          updatedCards[i] = updatedCards[i].copyWith(isDefault: false);
        }
      }
      
      updatedCards.add(newCard);
      final updatedUser = _userModel!.copyWith(paymentCards: updatedCards);
      await _dbService.updateUserProfile(updatedUser);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Set default payment card
  Future<void> setDefaultCard(String cardId) async {
    if (_userModel == null) return;
    setLoading(true);
    try {
      final List<PaymentCardModel> updatedCards = _userModel!.paymentCards.map((card) {
        return card.copyWith(isDefault: card.id == cardId);
      }).toList();

      final updatedUser = _userModel!.copyWith(paymentCards: updatedCards);
      await _dbService.updateUserProfile(updatedUser);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Delete payment card
  Future<void> deleteCard(String cardId) async {
    if (_userModel == null) return;
    setLoading(true);
    try {
      final List<PaymentCardModel> updatedCards = _userModel!.paymentCards
          .where((card) => card.id != cardId)
          .toList();

      // Set first remaining as default if we deleted default
      if (updatedCards.isNotEmpty && _userModel!.paymentCards.firstWhere((c) => c.id == cardId).isDefault) {
        updatedCards[0] = updatedCards[0].copyWith(isDefault: true);
      }

      final updatedUser = _userModel!.copyWith(paymentCards: updatedCards);
      await _dbService.updateUserProfile(updatedUser);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // --- WISHLIST MANAGEMENT ---

  // Toggle wishlist item
  Future<void> toggleWishlist(String productId) async {
    if (_userModel == null) return;
    setLoading(true);
    try {
      final List<String> updatedWishlist = List.from(_userModel!.wishlist);
      if (updatedWishlist.contains(productId)) {
        updatedWishlist.remove(productId);
      } else {
        updatedWishlist.add(productId);
      }
      final updatedUser = _userModel!.copyWith(wishlist: updatedWishlist);
      await _dbService.updateUserProfile(updatedUser);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Check if product is in wishlist
  bool isProductInWishlist(String productId) {
    if (_userModel == null) return false;
    return _userModel!.wishlist.contains(productId);
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
