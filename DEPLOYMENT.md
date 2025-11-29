# Deployment Guide

Complete guide for deploying your AI SaaS App to production across all platforms.

## Table of Contents

1. [Web Deployment](#web-deployment)
2. [iOS App Store](#ios-app-store)
3. [Google Play Store](#google-play-store)
4. [Desktop Distribution](#desktop-distribution)
5. [Backend Configuration](#backend-configuration)

---

## Web Deployment

### Option 1: Firebase Hosting (Recommended)

1. **Install Firebase CLI**
   ```bash
   npm install -g firebase-tools
   ```

2. **Login to Firebase**
   ```bash
   firebase login
   ```

3. **Initialize Firebase**
   ```bash
   firebase init hosting
   ```
   - Select your project
   - Set public directory to: `build/web`
   - Configure as single-page app: Yes
   - Set up automatic builds: Optional

4. **Build and Deploy**
   ```bash
   flutter build web --release
   firebase deploy --only hosting
   ```

### Option 2: Vercel

1. **Install Vercel CLI**
   ```bash
   npm install -g vercel
   ```

2. **Build the app**
   ```bash
   flutter build web --release
   ```

3. **Deploy**
   ```bash
   cd build/web
   vercel --prod
   ```

### Option 3: Netlify

1. **Build the app**
   ```bash
   flutter build web --release
   ```

2. **Deploy via Netlify CLI**
   ```bash
   npm install -g netlify-cli
   netlify deploy --prod --dir=build/web
   ```

Or drag and drop the `build/web` folder to Netlify's web interface.

---

## iOS App Store

### Prerequisites

- macOS with Xcode installed
- Apple Developer Program membership ($99/year)
- Valid Apple ID

### Steps

1. **Configure App Signing**
   
   Open the project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
   
   - Select Runner in the project navigator
   - Go to Signing & Capabilities
   - Select your Team
   - Update Bundle Identifier (e.g., `com.yourcompany.aisaasapp`)

2. **Update App Information**
   
   Edit `ios/Runner/Info.plist`:
   - Update `CFBundleDisplayName`
   - Update `CFBundleName`
   - Add privacy descriptions for camera, photos, etc.

3. **Configure Deep Linking**
   
   For Google Sign-In, add URL schemes in Xcode:
   - Go to Info → URL Types
   - Add your reversed client ID

4. **Build for Release**
   ```bash
   flutter build ios --release
   ```

5. **Archive in Xcode**
   - In Xcode, select "Any iOS Device" as target
   - Product → Archive
   - Wait for archive to complete

6. **Upload to App Store Connect**
   - Click "Distribute App"
   - Select "App Store Connect"
   - Follow the wizard
   - Upload

7. **Submit for Review**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Fill in app information
   - Add screenshots (required sizes)
   - Submit for review

### Required Assets

- App Icon: 1024x1024px
- Screenshots:
  - iPhone 6.7": 1290x2796px
  - iPhone 6.5": 1242x2688px
  - iPad Pro 12.9": 2048x2732px

---

## Google Play Store

### Prerequisites

- Google Play Developer account ($25 one-time fee)
- Android Studio installed

### Steps

1. **Generate Upload Key**
   
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```
   
   Remember your passwords!

2. **Configure Signing**
   
   Create `android/key.properties`:
   ```properties
   storePassword=YOUR_STORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=upload
   storeFile=/Users/YOUR_USERNAME/upload-keystore.jks
   ```

3. **Update Build Configuration**
   
   Edit `android/app/build.gradle`:
   
   ```gradle
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }
   
   android {
       ...
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

4. **Update App Information**
   
   Edit `android/app/src/main/AndroidManifest.xml`:
   - Update `android:label`
   - Add required permissions
   - Configure deep linking for OAuth

5. **Build App Bundle**
   ```bash
   flutter build appbundle --release
   ```
   
   Output: `build/app/outputs/bundle/release/app-release.aab`

6. **Create App in Play Console**
   - Go to [Google Play Console](https://play.google.com/console)
   - Create new app
   - Fill in app details

7. **Upload App Bundle**
   - Go to Release → Production
   - Create new release
   - Upload `app-release.aab`
   - Add release notes

8. **Complete Store Listing**
   - App name and description
   - Screenshots (required)
   - Feature graphic: 1024x500px
   - App icon: 512x512px
   - Privacy policy URL

9. **Submit for Review**

### Required Assets

- App Icon: 512x512px
- Feature Graphic: 1024x500px
- Screenshots:
  - Phone: 1080x1920px (minimum 2)
  - 7" Tablet: 1024x1600px (optional)
  - 10" Tablet: 1600x2560px (optional)

---

## Desktop Distribution

### macOS

1. **Build**
   ```bash
   flutter build macos --release
   ```

2. **Create DMG** (optional)
   - Use tools like `create-dmg`
   - Or distribute the `.app` directly

3. **Code Signing** (for distribution)
   - Requires Apple Developer account
   - Use Xcode to sign the app

### Windows

1. **Build**
   ```bash
   flutter build windows --release
   ```

2. **Create Installer** (optional)
   - Use Inno Setup or NSIS
   - Package the `build/windows/runner/Release` folder

### Linux

1. **Build**
   ```bash
   flutter build linux --release
   ```

2. **Create Package**
   - Create `.deb` for Debian/Ubuntu
   - Create `.rpm` for Fedora/RHEL
   - Or distribute as AppImage

---

## Backend Configuration

### Supabase Production Setup

1. **Database Optimization**
   - Enable connection pooling
   - Set up database backups
   - Configure replication (if needed)

2. **Security**
   - Enable Row Level Security (RLS)
   - Review and tighten policies
   - Enable email confirmations
   - Set up rate limiting

3. **Authentication**
   - Configure OAuth providers:
     - Google OAuth
     - Apple Sign In (for iOS)
   - Set up email templates
   - Configure redirect URLs for production

4. **Storage** (if using)
   - Set up storage buckets
   - Configure access policies
   - Enable CDN

### Environment Variables

Create different configs for development and production:

**Development**: `lib/config/supabase_config.dart`
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://dev-project.supabase.co';
  static const String supabaseAnonKey = 'dev-key';
  static const String openAIApiKey = 'dev-openai-key';
}
```

**Production**: Use environment variables or build flavors

### Monitoring & Analytics

1. **Set up Firebase Analytics**
   ```bash
   flutter pub add firebase_analytics
   ```

2. **Error Tracking**
   - Sentry
   - Firebase Crashlytics
   - Bugsnag

3. **Performance Monitoring**
   - Firebase Performance
   - New Relic

---

## Pre-Launch Checklist

### General
- [ ] All API keys are secured
- [ ] Environment variables configured
- [ ] Database migrations completed
- [ ] Backup strategy in place
- [ ] Error tracking enabled
- [ ] Analytics configured

### Web
- [ ] Custom domain configured
- [ ] SSL certificate active
- [ ] SEO metadata added
- [ ] PWA manifest configured
- [ ] Performance optimized

### iOS
- [ ] App Store Connect account ready
- [ ] App icons and screenshots prepared
- [ ] Privacy policy URL added
- [ ] App description written
- [ ] Keywords optimized
- [ ] Pricing and availability set

### Android
- [ ] Play Console account ready
- [ ] App signing configured
- [ ] Store listing complete
- [ ] Content rating obtained
- [ ] Privacy policy URL added
- [ ] Target API level meets requirements

---

## Post-Launch

1. **Monitor Performance**
   - Check crash reports
   - Review analytics
   - Monitor API usage

2. **User Feedback**
   - Respond to reviews
   - Track feature requests
   - Monitor support tickets

3. **Updates**
   - Regular bug fixes
   - Feature updates
   - Security patches

4. **Marketing**
   - App Store Optimization (ASO)
   - Social media promotion
   - User acquisition campaigns

---

## Troubleshooting

### Common Issues

**iOS Build Fails**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter build ios
```

**Android Signing Issues**
- Verify `key.properties` path
- Check password correctness
- Ensure keystore file exists

**Web Performance**
- Enable code splitting
- Optimize images
- Use lazy loading
- Enable caching

---

## Support

For deployment issues:
- Check Flutter documentation: https://docs.flutter.dev
- Supabase docs: https://supabase.com/docs
- Stack Overflow: Tag with `flutter`, `supabase`

---

**Good luck with your launch! 🚀**
