import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Get current user
  User? get currentUser => _supabase.auth.currentUser;
  
  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
  
  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
      },
    );
    
    return response;
  }
  
  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.saasapp.ai_saas_app://login-callback',
      );
      return true;
    } catch (e) {
      print('Google sign in error: $e');
      return false;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
  
  // Reset password
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }
  
  // Update user profile
  Future<UserResponse> updateProfile({
    String? name,
    String? profilePicture,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (profilePicture != null) updates['profile_picture'] = profilePicture;
    
    return await _supabase.auth.updateUser(
      UserAttributes(
        data: updates,
      ),
    );
  }
  
  // Get user profile from database
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
  
  // Create or update user profile in database
  Future<void> upsertUserProfile(UserModel user) async {
    await _supabase.from('users').upsert(user.toJson());
  }
}
