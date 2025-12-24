import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utils/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        
        // User is signed in
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }
        
        // User is not signed in
        return const LoginScreen();
      },
    );
  }
}
