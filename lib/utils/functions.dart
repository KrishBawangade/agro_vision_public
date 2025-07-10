import 'dart:math';

import 'package:agro_vision/utils/enums.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppFunctions {
  // 🔑 Get a string value from SharedPreferences
  static getSharedPreferenceString({required String key}) async {
    SharedPreferencesAsync pref = SharedPreferencesAsync();
    String stringValue = await pref.getString(key) ?? "";
    return stringValue;
  }

  // 💾 Set a string value in SharedPreferences
  static setSharedPreferenceString({
    required String key,
    required String value,
    Function(String)? callBack,
  }) async {
    SharedPreferencesAsync pref = SharedPreferencesAsync();
    await pref.setString(key, value);
  }

  // 🎨 Convert stored theme string to enum
  static ThemeModeApp themeModeFromString(String themeModeString) {
    return ThemeModeApp.values.firstWhere(
      (element) => element.name == themeModeString,
      orElse: () => ThemeModeApp.system,
    );
  }

  // 📅 Show a date picker dialog
  static Future<DateTime?> selectDate({
    required BuildContext context,
    DateTime? initialDate,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
  }

  // 💧 Calculate monthly average humidity from hourly values
  static calculateAverageHumidity({required List<double?> hourlyHumidityList}) {
    List<List<double>> dailyHumidityList = splitList(
      list: hourlyHumidityList.where((h) => h != null).cast<double>().toList(),
      chunkSize: 24,
    );
    List<double> dailyHumidityAverageList = [];

    for (var day in dailyHumidityList) {
      dailyHumidityAverageList.add(day.reduce((a, b) => a + b) / day.length);
    }

    List<List<double>> monthlyHumidityList =
        splitList(list: dailyHumidityAverageList, chunkSize: 30);
    List<double> monthlyHumidityAverageList = [];

    for (var month in monthlyHumidityList) {
      monthlyHumidityAverageList
          .add(month.reduce((a, b) => a + b) / month.length);
    }

    return monthlyHumidityAverageList;
  }

  // 🌡️ Calculate monthly average temperature from daily list
  static calculateAverageTemperature({required List<double?> list}) {
    List<List<double>> monthlyList = splitList(
      list: list.where((h) => h != null).cast<double>().toList(),
      chunkSize: 30,
    );
    List<double> monthlyAverageList = [];

    for (var month in monthlyList) {
      monthlyAverageList.add(month.reduce((a, b) => a + b) / month.length);
    }

    return monthlyAverageList;
  }

  // 🌧️ Calculate monthly total rainfall from daily list
  static calculateRainfallMonthlySum({required List<double?> list}) {
    List<List<double>> monthlyRainfallList = splitList(
      list: list.where((h) => h != null).cast<double>().toList(),
      chunkSize: 30,
    );
    return monthlyRainfallList
        .map((month) => month.reduce((a, b) => a + b))
        .toList();
  }

  // 🧩 Split a list into fixed-size chunks
  static List<List<T>> splitList<T>({
    required List<T> list,
    required int chunkSize,
  }) {
    List<List<T>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      int end = i + chunkSize < list.length ? i + chunkSize : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }

  // 🍞 Show toast (short popup at bottom)
  showToast({required String msg, Color? backgroundColor, Color? textColor}) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT);
  }

  // 📣 Show snackbar message
  static showSnackBar({
    required BuildContext context,
    required String msg,
    SnackBarAction? action,
    Duration? duration,
  }) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: action,
      duration: duration ?? const Duration(seconds: 4),
      dismissDirection: DismissDirection.horizontal,
    );
    try {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } catch (_) {}
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // 🍞 Show toast message using await
  static showToastMessage({required String msg}) async {
    await Fluttertoast.showToast(msg: msg);
  }

  // ⚠️ Show a simple Yes/Cancel confirmation dialog
  static Future<void> showSimpleAlertDialog({
    required BuildContext context,
    required String alertTitle,
    required String alertBody,
    required Function() onYesButtonCliked,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alertTitle),
        content: Text(alertBody),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppStrings.cancel.tr(),
                    style: const TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  onYesButtonCliked();
                  Navigator.of(context).pop();
                },
                child: Text(AppStrings.yes.tr()),
              ),
            ],
          )
        ],
      ),
    );
  }

  // 🎨 Convert Color object to hex string (e.g., "#FF0000FF")
  static String colorToHexString(Color color) {
    return "#${color.toARGB32().toRadixString(16).padLeft(8, "0")}";
  }

  // 🔄 Convert hex string to Color object
  static Color hexStringToColor(String hexString) {
    return Color(int.parse(hexString.replaceFirst("#", ""), radix: 16));
  }

  // 🎲 Generate a random RGB color
  static Color generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
        255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
  }

  // 🌐 Get current locale from context
  static Locale getCurrentLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }

  // 🌍 Get current language code (like 'en', 'hi')
  static String getCurrentLanguageCode(BuildContext context) {
    return getCurrentLocale(context).languageCode;
  }

  // 📛 Convert language code to full name
  static String getLanguageName(String langCode) {
    Map<String, String> languageMap = {
      "en": "English",
      "hi": "Hindi",
      "mr": "Marathi",
      "te": "Telugu",
      "ta": "Tamil",
      "gu": "Gujarati",
      "bn": "Bengali",
      "pa": "Punjabi",
      "kn": "Kannada"
    };
    return languageMap[langCode] ?? "English";
  }

  // 🔄 Get language code from name (e.g., "Hindi" -> "hi")
  static String getLanguageCodeByName(String languageName) {
    Map<String, String> languageMap = {
      "en": "English",
      "hi": "Hindi",
      "mr": "Marathi",
      "te": "Telugu",
      "ta": "Tamil",
      "gu": "Gujarati",
      "bn": "Bengali",
      "pa": "Punjabi",
      "kn": "Kannada"
    };
    return languageMap.entries
        .firstWhere((lang) => lang.value == languageName,
            orElse: () => const MapEntry("en", "English"))
        .key;
  }

  // ⏰ Check if more than 24 hours passed since last update
  static bool is24HoursPassedSince(DateTime lastUpdated) {
    final now = DateTime.now();
    return now.difference(lastUpdated).inHours >= 24;
  }
}
