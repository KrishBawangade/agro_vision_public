// Importing required packages and local modules
import 'package:agro_vision/models/current_weather_parameter_item_model.dart';
import 'package:agro_vision/pages/main_page/views/home_view_main_page/widgets/current_weather_parameter_item.dart';
import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/services/weather_api/models/current_weather_model.dart';
import 'package:agro_vision/utils/constants.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// A stateless widget to display current weather details
class CurrentWeatherWidget extends StatelessWidget {
  const CurrentWeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the MainProvider for weather data
    MainProvider mainProvider = Provider.of<MainProvider>(context);

    // Get current weather data from the forecast response
    CurrentWeatherModel? currentWeather =
        mainProvider.weatherForecastApiResponse?.current;

    // Prepare a list of weather parameters (Temperature, Rain, Wind, Humidity)
    var listWeatherParameterItem = [
      CurrentWeatherParameterItemModel(
        leadingIconPath: AppConstants.temperatureImagePath,
        title: AppStrings.temperature.tr(),
        value: "${currentWeather?.temp_c ?? "_"} °C",
      ),
      CurrentWeatherParameterItemModel(
        leadingIconPath: AppConstants.rainImagePath,
        title: AppStrings.rain.tr(),
        value: "${currentWeather?.precip_mm ?? "_"} mm",
      ),
      CurrentWeatherParameterItemModel(
        leadingIconPath: AppConstants.windImagePath,
        title: AppStrings.wind.tr(),
        value: "${currentWeather?.wind_kph ?? "_"} km/hr",
      ),
      CurrentWeatherParameterItemModel(
        leadingIconPath: AppConstants.humidityImagePath,
        title: AppStrings.humidity.tr(),
        value: "${currentWeather?.humidity ?? "_"}%",
      ),
    ];

    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Column(
        children: [
          // Display weather condition (text + icon)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentWeather?.condition?.text ?? "_",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              currentWeather?.condition?.icon != null
                  ? CachedNetworkImage(
                      imageUrl: "http:${currentWeather?.condition?.icon ?? ""}",
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 30,
                      height: 30,
                    )
                  : const SizedBox(),
            ],
          ),

          const SizedBox(height: 16),

          // Grid displaying 4 weather parameter cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listWeatherParameterItem.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              childAspectRatio: 2 / 1, // Width to height ratio
            ),
            itemBuilder: (context, index) {
              var currentWeatherParameterItem = listWeatherParameterItem[index];
              return CurrentWeatherParameterItem(
                leadingIcon: currentWeatherParameterItem.leadingIconPath,
                title: currentWeatherParameterItem.title,
                value: currentWeatherParameterItem.value,
              );
            },
          ),
        ],
      ),
    );
  }
}
