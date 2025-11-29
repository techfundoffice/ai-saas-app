class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final String interval; // 'month', 'year'
  final int creditsIncluded;
  final List<String> features;
  final bool isPopular;
  
  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.interval,
    required this.creditsIncluded,
    required this.features,
    this.isPopular = false,
  });
  
  static List<SubscriptionPlan> get availablePlans => [
    SubscriptionPlan(
      id: 'free',
      name: 'Free',
      description: 'Get started with basic features',
      price: 0,
      interval: 'month',
      creditsIncluded: 10,
      features: [
        '10 AI credits per month',
        'Basic AI features',
        'Community support',
        'Web access only',
      ],
    ),
    SubscriptionPlan(
      id: 'basic',
      name: 'Basic',
      description: 'Perfect for individuals',
      price: 9.99,
      interval: 'month',
      creditsIncluded: 100,
      features: [
        '100 AI credits per month',
        'All AI features',
        'Email support',
        'Mobile & web access',
        'Priority processing',
      ],
    ),
    SubscriptionPlan(
      id: 'pro',
      name: 'Pro',
      description: 'For power users',
      price: 29.99,
      interval: 'month',
      creditsIncluded: 500,
      features: [
        '500 AI credits per month',
        'Advanced AI models',
        'Priority support',
        'API access',
        'Custom integrations',
        'Analytics dashboard',
      ],
      isPopular: true,
    ),
    SubscriptionPlan(
      id: 'enterprise',
      name: 'Enterprise',
      description: 'For teams and businesses',
      price: 99.99,
      interval: 'month',
      creditsIncluded: 2000,
      features: [
        '2000 AI credits per month',
        'Unlimited AI models',
        'Dedicated support',
        'Custom AI training',
        'Team collaboration',
        'Advanced analytics',
        'SLA guarantee',
      ],
    ),
  ];
}

class CreditPackage {
  final String id;
  final String name;
  final int credits;
  final double price;
  final String? bonus;
  
  CreditPackage({
    required this.id,
    required this.name,
    required this.credits,
    required this.price,
    this.bonus,
  });
  
  static List<CreditPackage> get availablePackages => [
    CreditPackage(
      id: 'small',
      name: 'Starter Pack',
      credits: 50,
      price: 4.99,
    ),
    CreditPackage(
      id: 'medium',
      name: 'Popular Pack',
      credits: 150,
      price: 12.99,
      bonus: '+10 bonus credits',
    ),
    CreditPackage(
      id: 'large',
      name: 'Power Pack',
      credits: 500,
      price: 39.99,
      bonus: '+50 bonus credits',
    ),
    CreditPackage(
      id: 'mega',
      name: 'Mega Pack',
      credits: 1000,
      price: 69.99,
      bonus: '+150 bonus credits',
    ),
  ];
}
