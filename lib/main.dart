import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/supabase_config.dart';
import 'providers/auth_provider.dart';
import 'providers/subscription_provider.dart';
import 'providers/ai_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/subscription_screen.dart';
import 'screens/ai_playground_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase only if credentials are provided
  if (SupabaseConfig.supabaseUrl != 'YOUR_SUPABASE_URL' &&
      SupabaseConfig.supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY') {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
    } catch (e) {
      print('Supabase initialization failed: $e');
    }
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => AIProvider()),
      ],
      child: MaterialApp(
        title: 'AI SaaS App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.interTextTheme(),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/home': (context) => const HomeScreen(),
          '/subscription': (context) => const SubscriptionScreen(),
          '/ai-playground': (context) => const AIPlaygroundScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
