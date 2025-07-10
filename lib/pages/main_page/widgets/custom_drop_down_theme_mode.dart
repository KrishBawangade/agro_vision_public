import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/utils/constants.dart';
import 'package:agro_vision/utils/enums.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Dropdown to let users select app theme mode (Light / Dark / System)
class CustomDropDownThemeMode extends StatelessWidget {
  const CustomDropDownThemeMode({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the MainProvider to get and update theme mode
    MainProvider mainProvider = Provider.of<MainProvider>(context);

    // Current selected theme mode
    ThemeModeApp? selectedValue = mainProvider.themeModeApp;

    return SizedBox(
      width: double.infinity,
      child: DropdownButton<ThemeModeApp>(
        value: selectedValue,
        // Dropdown items for theme options
        items: ThemeModeApp.values.map((themeMode) {
          String themeModeString = AppStrings.system.tr();

          switch (themeMode) {
            case ThemeModeApp.dark:
              themeModeString = AppStrings.dark.tr();
              break;
            case ThemeModeApp.light:
              themeModeString = AppStrings.light.tr();
              break;
            case ThemeModeApp.system:
              themeModeString = AppStrings.system.tr();
              break;
          }

          return DropdownMenuItem<ThemeModeApp>(
            value: themeMode,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(themeModeString),
            ),
          );
        }).toList(),

        // When the theme mode is changed
        onChanged: (value) {
          if (value == null) return;

          // Update theme in provider
          mainProvider.setThemeModeApp(value);

          // Persist the selection using shared preferences
          AppFunctions.setSharedPreferenceString(
            key: AppConstants.themeModeKey,
            value: value.name,
          );
        },
      ),
    );
  }
}
