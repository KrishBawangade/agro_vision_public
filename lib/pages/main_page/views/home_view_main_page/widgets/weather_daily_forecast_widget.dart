// Required imports
import 'package:agro_vision/models/current_weather_parameter_item_model.dart';
import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/services/weather_api/models/weather_daily_forecast_day_model.dart';
import 'package:agro_vision/services/weather_api/models/weather_daily_forecast_model.dart';
import 'package:agro_vision/services/weather_api/models/weather_forecast_day_model.dart';
import 'package:agro_vision/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Model to represent daily forecast data for UI
class WeatherDailyForecastParametersModel {
  final String date;
  final String condition;
  final String conditionIconUrl;
  final List<CurrentWeatherParameterItemModel> weatherParameterList;

  WeatherDailyForecastParametersModel({
    required this.date,
    required this.weatherParameterList,
    required this.condition,
    required this.conditionIconUrl,
  });
}

// Widget to render daily weather forecast section
class WeatherDailyForecastWidget extends StatelessWidget {
  const WeatherDailyForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Access weather forecast data from provider
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    WeatherDailyForecastModel? weatherDailyForecast =
        mainProvider.weatherForecastApiResponse?.forecast;

    // List to hold UI-ready forecast data
    var listWeatherParameterItem = [];

    // Loop through each forecast day (except today)
    for (WeatherForecastDayModel dayForecast
        in weatherDailyForecast?.forecastday ?? <WeatherForecastDayModel>[]) {
      var index = weatherDailyForecast!.forecastday?.indexOf(dayForecast);
      if (index == 0) continue; // Skip today's forecast

      WeatherDailyForecastDayModel? weatherDailyForecastDay = dayForecast.day;

      // Format date into readable string
      DateFormat dateFormat = DateFormat("dd MMM");
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          (dayForecast.date_epoch ?? 0) * 1000);
      String formattedDate = dateFormat.format(dateTime);

      // Convert raw forecast data into a display model
      WeatherDailyForecastParametersModel weatherDailyForecastParameters =
          WeatherDailyForecastParametersModel(
        date: formattedDate,
        condition: weatherDailyForecastDay?.condition?.text ?? "_",
        conditionIconUrl: weatherDailyForecastDay?.condition?.icon ?? "",
        weatherParameterList: [
          CurrentWeatherParameterItemModel(
            leadingIconPath: AppConstants.temperatureImagePath,
            title: "Temperature",
            value:
                "${weatherDailyForecastDay?.mintemp_c ?? "_"}°C/${weatherDailyForecastDay?.maxtemp_c ?? "_"}°C",
          ),
          CurrentWeatherParameterItemModel(
            leadingIconPath: AppConstants.rainImagePath,
            title: "Rain",
            value: "${weatherDailyForecastDay?.daily_chance_of_rain ?? "_"}%",
          ),
          CurrentWeatherParameterItemModel(
            leadingIconPath: AppConstants.windImagePath,
            title: "Wind",
            value: "${weatherDailyForecastDay?.maxwind_kph ?? "_"} km/h",
          ),
        ],
      );

      // Add formatted data to the list
      listWeatherParameterItem.add(weatherDailyForecastParameters);
    }

    return SizedBox(
      width: double.infinity,
      child: listWeatherParameterItem.isNotEmpty
          // If forecast is available, show forecast cards
          ? Row(
              children: listWeatherParameterItem.map((weatherModel) {
                var dailyWeatherForecast =
                    weatherModel as WeatherDailyForecastParametersModel;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display formatted date
                      Text(
                        dailyWeatherForecast.date,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Show condition text and icon
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dailyWeatherForecast.condition,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            dailyWeatherForecast.conditionIconUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl:
                                        "http:${dailyWeatherForecast.conditionIconUrl}",
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                    width: 24,
                                    height: 24,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // List of weather parameters (temp, rain, wind)
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dailyWeatherForecast
                              .weatherParameterList.length,
                          physics:
                              const NeverScrollableScrollPhysics(), // Prevent scroll inside column
                          itemBuilder: (context, index) {
                            var weatherParameter = dailyWeatherForecast
                                .weatherParameterList[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Weather icon (SVG)
                                  SvgPicture.asset(
                                    weatherParameter.leadingIconPath,
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Value (e.g., 25°C / 75%)
                                  Text(
                                    weatherParameter.value,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          // If no forecast available
          : Center(
              child: Text(
                "No Forecast Available!",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
    );
  }
}
