# AI SaaS App

A complete cross-platform AI-powered SaaS application built with Flutter. Supports web, iOS, Android, and desktop platforms with subscription management, credits system, and AI integration.

## Features

### 🔐 Authentication
- Email/password authentication
- Google OAuth sign-in
- Password reset functionality
- User profile management

### 💳 Subscription & Monetization
- Multiple subscription tiers (Free, Basic, Pro, Enterprise)
- Credit-based usage system
- One-time credit purchases
- Subscription management
- Usage tracking and history

### 🤖 AI Integration
- Text generation (GPT-4o-mini)
- Image generation (DALL-E 3)
- Image analysis (Vision API)
- Credit-based AI usage

### 📱 Cross-Platform Support
- **Web**: Progressive Web App
- **iOS**: Native iOS app (App Store ready)
- **Android**: Native Android app (Play Store ready)
- **Desktop**: macOS, Windows, Linux (optional)

## Prerequisites

- Flutter SDK 3.38.3 or higher
- Dart SDK 3.5.0 or higher
- Supabase account (free tier available)
- OpenAI API key (for AI features)

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd ai_saas_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Set Up Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to Project Settings → API
3. Copy your project URL and anon key
4. Run the SQL schema:
   - Go to SQL Editor in Supabase
   - Copy and paste the contents of `supabase_schema.sql`
   - Run the query

### 4. Configure Environment

Edit `lib/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  static const String openAIApiKey = 'YOUR_OPENAI_API_KEY';
}
```

### 5. Run the App

#### Web
```bash
flutter run -d chrome
```

#### iOS (macOS only)
```bash
flutter run -d ios
```

#### Android
```bash
flutter run -d android
```

## Project Structure

```
lib/
├── config/              # Configuration files
│   └── supabase_config.dart
├── models/              # Data models
│   ├── user_model.dart
│   └── subscription_model.dart
├── providers/           # State management
│   ├── auth_provider.dart
│   ├── subscription_provider.dart
│   └── ai_provider.dart
├── screens/             # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── subscription_screen.dart
│   ├── ai_playground_screen.dart
│   └── profile_screen.dart
├── services/            # Business logic
│   ├── auth_service.dart
│   ├── subscription_service.dart
│   └── ai_service.dart
└── main.dart            # App entry point
```

## Deployment

### iOS App Store

1. Configure signing in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. Update bundle identifier and signing team
3. Build for release:
   ```bash
   flutter build ios --release
   ```
4. Upload to App Store Connect via Xcode

### Google Play Store

1. Generate signing key:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Create `android/key.properties`:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-keystore>
   ```

3. Build for release:
   ```bash
   flutter build appbundle --release
   ```

4. Upload to Google Play Console

### Web Deployment

1. Build for web:
   ```bash
   flutter build web --release
   ```

2. Deploy the `build/web` directory to:
   - Firebase Hosting
   - Vercel
   - Netlify
   - Any static hosting service

## Database Schema

The app uses the following Supabase tables:

### `users`
- User profile information
- Subscription details
- Credits balance

### `credit_transactions`
- Transaction history
- Usage tracking
- Purchase records

See `supabase_schema.sql` for the complete schema.

## Subscription Plans

| Plan | Price | Credits/Month | Features |
|------|-------|---------------|----------|
| Free | $0 | 10 | Basic AI features |
| Basic | $9.99 | 100 | All AI features, priority processing |
| Pro | $29.99 | 500 | Advanced models, API access |
| Enterprise | $99.99 | 2000 | Custom training, team features |

## Credit Packages

- Starter Pack: 50 credits - $4.99
- Popular Pack: 150 credits (+10 bonus) - $12.99
- Power Pack: 500 credits (+50 bonus) - $39.99
- Mega Pack: 1000 credits (+150 bonus) - $69.99

## AI Features & Credit Costs

- Text Generation: 1 credit
- Image Generation: 10 credits
- Image Analysis: 3 credits

## Environment Variables

Required environment variables in `lib/config/supabase_config.dart`:

- `supabaseUrl`: Your Supabase project URL
- `supabaseAnonKey`: Your Supabase anonymous key
- `openAIApiKey`: Your OpenAI API key

## Security Notes

⚠️ **Important**: Never commit API keys to version control!

1. Add `lib/config/supabase_config.dart` to `.gitignore`
2. Use environment variables for production
3. Enable Row Level Security in Supabase
4. Use secure storage for sensitive data

## Troubleshooting

### Flutter Doctor Issues
```bash
flutter doctor
```

### Clear Build Cache
```bash
flutter clean
flutter pub get
```

### iOS Build Issues
```bash
cd ios
pod install
cd ..
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

## Support

For support, email support@example.com or open an issue on GitHub.

## Acknowledgments

- Flutter team for the amazing framework
- Supabase for the backend infrastructure
- OpenAI for AI capabilities
- Google Fonts for typography

---

Built with ❤️ using Flutter
