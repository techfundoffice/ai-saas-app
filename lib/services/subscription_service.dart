import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/subscription_model.dart';

class SubscriptionService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Get user's current subscription
  Future<Map<String, dynamic>?> getCurrentSubscription(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('subscription_tier, subscription_expires_at, is_subscription_active')
          .eq('id', userId)
          .single();
      
      return response;
    } catch (e) {
      print('Error fetching subscription: $e');
      return null;
    }
  }
  
  // Update subscription
  Future<void> updateSubscription({
    required String userId,
    required String tier,
    required DateTime expiresAt,
  }) async {
    await _supabase.from('users').update({
      'subscription_tier': tier,
      'subscription_expires_at': expiresAt.toIso8601String(),
      'is_subscription_active': true,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }
  
  // Cancel subscription
  Future<void> cancelSubscription(String userId) async {
    await _supabase.from('users').update({
      'is_subscription_active': false,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }
  
  // Get user credits
  Future<int> getUserCredits(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('credits')
          .eq('id', userId)
          .single();
      
      return response['credits'] as int? ?? 0;
    } catch (e) {
      print('Error fetching credits: $e');
      return 0;
    }
  }
  
  // Add credits to user
  Future<void> addCredits({
    required String userId,
    required int amount,
    String? source,
  }) async {
    // Get current credits
    final currentCredits = await getUserCredits(userId);
    final newCredits = currentCredits + amount;
    
    // Update credits
    await _supabase.from('users').update({
      'credits': newCredits,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
    
    // Log transaction
    await _logCreditTransaction(
      userId: userId,
      amount: amount,
      type: 'purchase',
      source: source ?? 'manual',
    );
  }
  
  // Deduct credits from user
  Future<bool> deductCredits({
    required String userId,
    required int amount,
    String? purpose,
  }) async {
    try {
      // Get current credits
      final currentCredits = await getUserCredits(userId);
      
      if (currentCredits < amount) {
        return false; // Insufficient credits
      }
      
      final newCredits = currentCredits - amount;
      
      // Get current total used
      final response = await _supabase
          .from('users')
          .select('total_credits_used')
          .eq('id', userId)
          .single();
      
      final currentTotalUsed = response['total_credits_used'] as int? ?? 0;
      
      // Update credits and total used
      await _supabase.from('users').update({
        'credits': newCredits,
        'total_credits_used': currentTotalUsed + amount,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
      
      // Log transaction
      await _logCreditTransaction(
        userId: userId,
        amount: -amount,
        type: 'usage',
        source: purpose ?? 'ai_request',
      );
      
      return true;
    } catch (e) {
      print('Error deducting credits: $e');
      return false;
    }
  }
  
  // Log credit transaction
  Future<void> _logCreditTransaction({
    required String userId,
    required int amount,
    required String type,
    required String source,
  }) async {
    try {
      await _supabase.from('credit_transactions').insert({
        'user_id': userId,
        'amount': amount,
        'type': type,
        'source': source,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error logging transaction: $e');
    }
  }
  
  // Get credit transaction history
  Future<List<Map<String, dynamic>>> getCreditHistory(String userId) async {
    try {
      final response = await _supabase
          .from('credit_transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(50);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching credit history: $e');
      return [];
    }
  }
}
