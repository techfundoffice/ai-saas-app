class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? profilePicture;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Subscription info
  final String subscriptionTier; // 'free', 'basic', 'pro', 'enterprise'
  final DateTime? subscriptionExpiresAt;
  final bool isSubscriptionActive;
  
  // Credits system
  final int credits;
  final int totalCreditsUsed;
  
  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.profilePicture,
    required this.createdAt,
    this.updatedAt,
    this.subscriptionTier = 'free',
    this.subscriptionExpiresAt,
    this.isSubscriptionActive = false,
    this.credits = 0,
    this.totalCreditsUsed = 0,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      profilePicture: json['profile_picture'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
      subscriptionTier: json['subscription_tier'] as String? ?? 'free',
      subscriptionExpiresAt: json['subscription_expires_at'] != null
          ? DateTime.parse(json['subscription_expires_at'] as String)
          : null,
      isSubscriptionActive: json['is_subscription_active'] as bool? ?? false,
      credits: json['credits'] as int? ?? 0,
      totalCreditsUsed: json['total_credits_used'] as int? ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profile_picture': profilePicture,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'subscription_tier': subscriptionTier,
      'subscription_expires_at': subscriptionExpiresAt?.toIso8601String(),
      'is_subscription_active': isSubscriptionActive,
      'credits': credits,
      'total_credits_used': totalCreditsUsed,
    };
  }
  
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? subscriptionTier,
    DateTime? subscriptionExpiresAt,
    bool? isSubscriptionActive,
    int? credits,
    int? totalCreditsUsed,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      subscriptionExpiresAt: subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      isSubscriptionActive: isSubscriptionActive ?? this.isSubscriptionActive,
      credits: credits ?? this.credits,
      totalCreditsUsed: totalCreditsUsed ?? this.totalCreditsUsed,
    );
  }
}
