// ignore_for_file: use_build_context_synchronously

import 'package:agro_vision/env.dart';
import 'package:agro_vision/firebase_options.dart';
import 'package:agro_vision/pages/choose_language_page.dart';
import 'package:agro_vision/pages/main_page/main_page.dart';
import 'package:agro_vision/pages/sign_in_sign_up_page.dart';
import 'package:agro_vision/providers/chat_bot_provider.dart';
import 'package:agro_vision/providers/connectivity_provider.dart';
import 'package:agro_vision/providers/crop_calendar_provider.dart';
import 'package:agro_vision/providers/crop_market_provider.dart';
import 'package:agro_vision/providers/current_market_price_filter_provider.dart';
import 'package:agro_vision/providers/farm_plot_provider.dart';
import 'package:agro_vision/providers/location_provider.dart';
import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/providers/recommendations_for_crop_provider.dart';
import 'package:agro_vision/providers/translation_provider.dart';
import 'package:agro_vision/utils/constants.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/theme.dart';
import 'package:agro_vision/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensures that plugin services are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes EasyLocalization before using it
  await EasyLocalization.ensureInitialized();

  // Initializes Gemini AI with API key
  Gemini.init(apiKey: Env.geminiApiKey);

  // Initializes Firebase for the current platform (Android/iOS/Web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configures Firebase UI Auth with email sign-in provider
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  // Runs the app with localization and multi-provider support
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale("en"),
        Locale("hi"),
        Locale("mr"),
        Locale("te"),
        Locale("ta"),
        Locale("gu"),
        Locale("bn"),
        Locale("pa"),
        Locale("kn"),
      ],
      path: "lib/assets/translations", // Path to translation JSON files
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
          ChangeNotifierProvider(
              create: (context) =>
                  MainProvider(context.read<ConnectivityProvider>())),
          ChangeNotifierProvider(
              create: (_) => CurrentMarketPriceFilterProvider()),
          ChangeNotifierProvider(
              create: (context) => ChatBotProvider(
                  connectivtyProvider: context.read<ConnectivityProvider>())),
          ChangeNotifierProvider(create: (_) => CropCalendarProvider()),
          ChangeNotifierProvider(
              create: (context) => FarmPlotProvider(
                  cropCalendarProvider: context.read<CropCalendarProvider>())),
          ChangeNotifierProvider(
              create: (context) => CropMarketProvider(
                  connectivityProvider: context.read<ConnectivityProvider>(),
                  filterProvider:
                      context.read<CurrentMarketPriceFilterProvider>())),
          ChangeNotifierProvider(
              create: (_) => RecommendationsForCropProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => TranslationProvider()),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

/// Root widget of the application
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String _selectedAppLanguage = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // Loads shared preference value for app language selection
  void _loadInitialData() async {
    _selectedAppLanguage = await AppFunctions.getSharedPreferenceString(
      key: AppConstants.selectedAppLanguagePrefKey,
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of<MainProvider>(context);

    // Show loading indicator until language preference is loaded
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale, // Current selected locale
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: mainProvider.themeModeApp == ThemeModeApp.system
          ? ThemeMode.system
          : mainProvider.themeModeApp == ThemeModeApp.dark
              ? ThemeMode.dark
              : ThemeMode.light,
      home: FirebaseAuth.instance.currentUser != null
          ? const MainPage() // User already signed in
          : _selectedAppLanguage.isNotEmpty
              ? const SignInSignUpPage() // Language selected, proceed to auth
              : const ChooseLanguagePage(), // Ask user to choose language first
    );
  }
}
