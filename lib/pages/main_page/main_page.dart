// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:agro_vision/models/bottom_navigation_item_app.dart';
import 'package:agro_vision/models/drawer_item_model.dart';
import 'package:agro_vision/pages/language_selection_page.dart';
import 'package:agro_vision/pages/main_page/views/chat_bot_view_main_page.dart';
import 'package:agro_vision/pages/main_page/views/home_view_main_page/home_view_main_page.dart';
import 'package:agro_vision/pages/main_page/views/market_view_main_page/market_view_main_page.dart';
import 'package:agro_vision/pages/main_page/widgets/app_drawer.dart';
import 'package:agro_vision/pages/profile_page.dart';
import 'package:agro_vision/pages/sign_in_sign_up_page.dart';
import 'package:agro_vision/providers/chat_bot_provider.dart';
import 'package:agro_vision/providers/crop_market_provider.dart';
import 'package:agro_vision/providers/farm_plot_provider.dart';
import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/utils/constants.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:agro_vision/widgets/confirm_exit_dialog.dart';
import 'package:agro_vision/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:provider/provider.dart';

/// Main landing page with bottom navigation, drawer, and dynamic app bar actions
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isInitialized = false;

  /// One-time dependency loading (weather, market, crop list)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      Future.microtask(() async {
        MainProvider mainProvider =
            Provider.of<MainProvider>(context, listen: false);
        CropMarketProvider cropMarketProvider =
            Provider.of<CropMarketProvider>(context, listen: false);
        FarmPlotProvider farmPlotProvider =
            Provider.of<FarmPlotProvider>(context, listen: false);

        final currentLocale = context.locale;

        await mainProvider.getLocationAndLoadWeatherResponse(context);
        await Future.wait([
          cropMarketProvider
              .loadCurrentMarketPriceDetails(currentLocale.languageCode),
          farmPlotProvider.loadCropList(context),
        ]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ChatBotProvider chatBotProvider = Provider.of<ChatBotProvider>(context);
    MainProvider mainProvider = Provider.of<MainProvider>(context);

    /// Bottom navigation pages
    final List<BottomNavigationItemRoute> listBottomNavigationItemRoute = [
      BottomNavigationItemRoute(
        label: AppStrings.home,
        navigationDestination: NavigationDestination(
          icon: const Icon(Icons.home),
          label: AppStrings.home.tr(),
        ),
        pageView: const HomeViewMainPage(),
      ),
      BottomNavigationItemRoute(
        label: AppStrings.market,
        navigationDestination: NavigationDestination(
          icon: const Icon(Icons.business),
          label: AppStrings.market.tr(),
        ),
        pageView: const MarketViewMainPage(),
      ),
      BottomNavigationItemRoute(
        label: AppStrings.chatBot,
        navigationDestination: NavigationDestination(
          icon: const Icon(Icons.chat),
          label: AppStrings.chatBot.tr(),
        ),
        pageView: const ChatBotViewMainPage(),
      ),
    ];

    /// Drawer items setup
    List<DrawerItemModel> drawerItemList = [
      DrawerItemModel(
        title: AppStrings.profile,
        icon: Icons.account_box,
        pageWidget: const ProfilePage(),
      ),
      DrawerItemModel(
        title: AppStrings.changeLanguage,
        icon: Icons.language,
        onClick: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LanguageSelectionPage()),
          );
        },
      ),
      DrawerItemModel(
        title: AppStrings.logOut,
        icon: Icons.logout,
        onClick: (context1) async {
          try {
            await FirebaseAuth.instance.signOut();
            await AppFunctions.showToastMessage(
                msg: AppStrings.signOutSuccessMessage.tr());
            await Navigator.of(context1).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignInSignUpPage()),
              (route) => route.settings.arguments == AppConstants.mainPage,
            );
          } catch (e) {
            if (kDebugMode) debugPrint("Sign-out error: $e");
          }
        },
      ),
    ];

    /// Set drawer items once frame builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainProvider.setDrawerItemList(drawerItemList: drawerItemList);
    });

    /// App bar actions for each tab
    List<Widget>? appBarActions;
    switch (_selectedIndex) {
      case 2: // ChatBot tab
        appBarActions = [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              if (chatBotProvider.messageList.isNotEmpty) {
                await AppFunctions.showSimpleAlertDialog(
                  context: context,
                  alertTitle: AppStrings.confirmDeleteChat.tr(),
                  alertBody: AppStrings.askDeleteWholeChatMessage.tr(),
                  onYesButtonCliked: () async {
                    await chatBotProvider.deleteAllMessages();
                    AppFunctions.showSnackBar(
                      context: context,
                      msg: AppStrings.chatClearedSuccessMessage.tr(),
                    );
                  },
                );
              } else {
                AppFunctions.showSnackBar(
                  context: context,
                  msg: AppStrings.chatIsAlreadyEmptyMessage.tr(),
                );
              }
            },
          ),
        ];
        break;

      case 1: // Market tab
        CropMarketProvider cropMarketProvider =
            Provider.of<CropMarketProvider>(context);
        DateTime arrivalDate = DateTime.utc(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        if (cropMarketProvider.currentMarketPriceRecordList.isNotEmpty &&
            (cropMarketProvider.currentMarketPriceRecordList[0].arrival_date ??
                    "")
                .isNotEmpty) {
          arrivalDate = DateFormat("dd/MM/yyyy").parseUtc(
              cropMarketProvider.currentMarketPriceRecordList[0].arrival_date!);
        }
        String formattedDate = DateFormat("dd MMM yyyy").format(arrivalDate);
        appBarActions = [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              !cropMarketProvider.isLoading ? formattedDate : "",
              style:
                  TextStyle(fontSize: 18, color: Theme.of(context).hintColor),
            ),
          )
        ];
        break;

      default:
        appBarActions = null;
        break;
    }

    /// Handles system back button with confirmation
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (isPopped, result) async {
        bool shouldExit =
            await ConfirmExitDialog.showConfirmExitDialog(context: context)??false;
        if (shouldExit) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else {
            FlutterExitApp.exitApp();
          }
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: listBottomNavigationItemRoute[_selectedIndex].label.tr(),
          actions: appBarActions,
        ),
        drawer: AppDrawer(),
        bottomNavigationBar: NavigationBar(
          destinations: listBottomNavigationItemRoute
              .map((e) => e.navigationDestination)
              .toList(),
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: listBottomNavigationItemRoute[_selectedIndex].pageView,
        ),
      ),
    );
  }
}
