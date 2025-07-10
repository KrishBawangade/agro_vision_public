// Flutter core imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// A widget to display a weather parameter with an icon, title, and value
class CurrentWeatherParameterItem extends StatelessWidget {
  // Path to the leading SVG icon
  final String leadingIcon;

  // Title or label for the parameter (e.g., "Humidity")
  final String title;

  // Value of the parameter (e.g., "56%")
  final String value;

  const CurrentWeatherParameterItem({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Leading icon with dynamic color to match the current theme
      leading: SvgPicture.asset(
        leadingIcon,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onSurface,
          BlendMode.srcIn,
        ),
      ),

      // Parameter title (e.g., "Humidity")
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: 12,
        ),
      ),

      // Parameter value (e.g., "56%")
      subtitle: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
