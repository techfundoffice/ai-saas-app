import 'package:flutter/foundation.dart';
import '../services/subscription_service.dart';
import '../models/subscription_model.dart';

class SubscriptionProvider with ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService();
  
  String _currentTier = 'free';
  DateTime? _expiresAt;
  bool _isActive = false;
  int _credits = 0;
  bool _isLoading = false;
  String? _error;
  
  String get currentTier => _currentTier;
  DateTime? get expiresAt => _expiresAt;
  bool get isActive => _isActive;
  int get credits => _credits;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<SubscriptionPlan> get availablePlans => SubscriptionPlan.availablePlans;
  List<CreditPackage> get availablePackages => CreditPackage.availablePackages;
  
  Future<void> loadSubscription(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final subscription = await _subscriptionService.getCurrentSubscription(userId);
      if (subscription != null) {
        _currentTier = subscription['subscription_tier'] ?? 'free';
        _isActive = subscription['is_subscription_active'] ?? false;
        if (subscription['subscription_expires_at'] != null) {
          _expiresAt = DateTime.parse(subscription['subscription_expires_at']);
        }
      }
      
      _credits = await _subscriptionService.getUserCredits(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> subscribe({
    required String userId,
    required String tier,
    required int durationMonths,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final expiresAt = DateTime.now().add(Duration(days: durationMonths * 30));
      
      await _subscriptionService.updateSubscription(
        userId: userId,
        tier: tier,
        expiresAt: expiresAt,
      );
      
      // Add credits based on plan
      final plan = availablePlans.firstWhere((p) => p.id == tier);
      await _subscriptionService.addCredits(
        userId: userId,
        amount: plan.creditsIncluded,
        source: 'subscription_$tier',
      );
      
      await loadSubscription(userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> cancelSubscription(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      await _subscriptionService.cancelSubscription(userId);
      await loadSubscription(userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> purchaseCredits({
    required String userId,
    required String packageId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final package = availablePackages.firstWhere((p) => p.id == packageId);
      
      // In a real app, you would process payment here
      // For now, we'll just add the credits
      await _subscriptionService.addCredits(
        userId: userId,
        amount: package.credits,
        source: 'purchase_$packageId',
      );
      
      await loadSubscription(userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> useCredits({
    required String userId,
    required int amount,
    String? purpose,
  }) async {
    if (_credits < amount) {
      _error = 'Insufficient credits';
      notifyListeners();
      return false;
    }
    
    try {
      final success = await _subscriptionService.deductCredits(
        userId: userId,
        amount: amount,
        purpose: purpose,
      );
      
      if (success) {
        _credits -= amount;
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<List<Map<String, dynamic>>> getCreditHistory(String userId) async {
    return await _subscriptionService.getCreditHistory(userId);
  }
}
