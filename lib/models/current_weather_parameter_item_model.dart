/// Represents a single weather parameter displayed in the current weather section.
///
/// This model is used to define individual weather attributes such as temperature,
/// humidity, wind speed, etc., including their icon, title, and value.
class CurrentWeatherParameterItemModel {
  /// Path to the icon asset representing the weather parameter (e.g., temperature, humidity).
  final String leadingIconPath;

  /// Title or label of the weather parameter (e.g., "Temperature", "Humidity").
  final String title;

  /// Value of the parameter, typically including the unit (e.g., "32°C", "78%").
  final String value;

  CurrentWeatherParameterItemModel({
    required this.leadingIconPath,
    required this.title,
    required this.value,
  });
}
