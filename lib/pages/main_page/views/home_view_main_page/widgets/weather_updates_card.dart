// Imports required widgets and utilities
import 'package:agro_vision/pages/main_page/views/home_view_main_page/widgets/current_weather_widget.dart';
import 'package:agro_vision/pages/main_page/views/home_view_main_page/widgets/weather_daily_forecast_widget.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Card widget that allows users to toggle between current and daily forecast
class WeatherUpdatesCard extends StatefulWidget {
  const WeatherUpdatesCard({super.key});

  @override
  State<WeatherUpdatesCard> createState() => _WeatherUpdatesCardState();
}

class _WeatherUpdatesCardState extends State<WeatherUpdatesCard> {
  // Tracks which view is currently selected
  bool _isCurrentWeatherSelected = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle buttons for "Current" and "Forecast"
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  // Current Weather Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        backgroundColor: _isCurrentWeatherSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      onPressed: () {
                        if (!_isCurrentWeatherSelected) {
                          setState(() {
                            _isCurrentWeatherSelected = true;
                          });
                        }
                      },
                      child: Text(
                        AppStrings.current.tr(),
                        style: TextStyle(
                          color: _isCurrentWeatherSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Daily Forecast Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        backgroundColor: !_isCurrentWeatherSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      onPressed: () {
                        if (_isCurrentWeatherSelected) {
                          setState(() {
                            _isCurrentWeatherSelected = false;
                          });
                        }
                      },
                      child: Text(
                        AppStrings.dayForecast.tr(),
                        style: TextStyle(
                          color: !_isCurrentWeatherSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Render current or forecast weather widget based on selection
            SizedBox(
              height: 225,
              child: Center(
                child: _isCurrentWeatherSelected
                    ? const CurrentWeatherWidget()
                    : const WeatherDailyForecastWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
