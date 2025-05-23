import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/global_data_provider.dart';
import 'providers/storage_provider.dart';
import 'utils/app_theme.dart';

// Screens
import 'screens/first_load_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/language_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/my_booking_screen.dart';
import 'screens/my_booking_details_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/user_screen.dart';
import 'screens/branch_screen.dart';
import 'screens/staff_screen.dart';
import 'screens/service_screen.dart';
import 'screens/date_time_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/points_screen.dart';
import 'screens/coupon_screen.dart';
import 'screens/referral_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/about_app_screen.dart';
import 'screens/social_media_screen.dart';
import 'screens/country_screen.dart';
import 'screens/edit_profile_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StorageProvider()),
        ChangeNotifierProvider(create: (_) => GlobalDataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'growTokyo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      // initialRoute: '/first-load',
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        // Get the route name
        final routeName = settings.name;

        // Get the corresponding widget for this route
        Widget page;
        switch (routeName) {
          case '/first-load':
            page = const FirstLoadScreen();
            break;
          case '/welcome':
            page = const WelcomeScreen();
            break;
          case '/language':
            page = const LanguageScreen();
            break;
          case '/login':
            page = const LoginScreen();
            break;
          case '/signup':
            page = const SignUpScreen();
            break;
          case '/home':
            page = const HomeScreen();
            break;
          case '/my-booking':
            page = const MyBookingScreen();
            break;
          case '/my-booking-details':
            page = const MyBookingDetailsScreen();
            break;
          case '/shop':
            page = const ShopScreen();
            break;
          case '/user':
            page = const UserScreen();
            break;
          case '/branch':
            page = const BranchScreen();
            break;
          case '/staff':
            page = const StaffScreen();
            break;
          case '/service':
            page = const ServiceScreen();
            break;
          case '/date-time':
            page = const DateTimeScreen();
            break;
          case '/detail':
            page = const DetailScreen();
            break;
          case '/points':
            page = const PointsScreen();
            break;
          case '/coupon':
            page = const CouponScreen();
            break;
          case '/referral':
            page = const ReferralScreen();
            break;
          case '/notifications':
            page = const NotificationsScreen();
            break;
          case '/settings':
            page = const SettingScreen();
            break;
          case '/about-app':
            page = const AboutAppScreen();
            break;
          case '/social-media':
            page = const SocialMediaScreen();
            break;
          case '/country':
            page = const CountryScreen();
            break;
          case '/edit-profile':
            page = const EditProfileScreen();
            break;
          default:
            page = const FirstLoadScreen();
        }

        // Return a custom page route with fade in/fade out animation
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Pure fade transition
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1), // Fast fade
        );
      },
      // Routes property removed as we're using onGenerateRoute
    );
  }
}
