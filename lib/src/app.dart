// lib/src/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'pages/landing_page.dart';
import 'pages/dashboard.dart';
import 'pages/profile_page.dart';
import 'pages/emergency_support_page.dart';
import 'pages/sample_item_details_view.dart';
import 'pages/sample_item_list_view.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/professional_signup_page.dart';
import 'pages/chat_page.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          home: const LandingPage(),
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();
                  case SampleItemListView.routeName:
                    return const SampleItemListView();
                  case LoginPage.routeName:
                    return const LoginPage();
                  case SignUpPage.routeName:
                    return const SignUpPage();
                  case ForgotPasswordPage.routeName:
                    return const ForgotPasswordPage();
                  case ProfessionalSignUpPage.routeName:
                    return const ProfessionalSignUpPage();
                  case Dashboard.routeName:
                    return const Dashboard();
                  case ChatPage.routeName:  
                    return const ChatPage();
                  case ProfilePage.routeName:
                   return ProfilePage();
                  case EmergencySupportPage.routeName:
                   return EmergencySupportPage();
                  default:
                    return const SampleItemListView();
                }
              },
            );
          },
        );
      },
    );
  }
}






