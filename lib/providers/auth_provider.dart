import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  
  AuthProvider() {
    _init();
  }
  
  void _init() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((AuthState state) {
      if (state.event == AuthChangeEvent.signedIn) {
        _loadUserProfile();
      } else if (state.event == AuthChangeEvent.signedOut) {
        _user = null;
        notifyListeners();
      }
    });
    
    // Load current user if exists
    if (_authService.currentUser != null) {
      _loadUserProfile();
    }
  }
  
  Future<void> _loadUserProfile() async {
    final userId = _authService.currentUser?.id;
    if (userId != null) {
      _user = await _authService.getUserProfile(userId);
      notifyListeners();
    }
  }
  
  Future<bool> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );
      
      if (response.user != null) {
        await _loadUserProfile();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = 'Sign up failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await _loadUserProfile();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _error = 'Sign in failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final success = await _authService.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
  
  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _authService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> updateProfile({String? name, String? profilePicture}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.updateProfile(
        name: name,
        profilePicture: profilePicture,
      );
      await _loadUserProfile();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
