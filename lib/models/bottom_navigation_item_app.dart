import 'package:flutter/material.dart';

/// Defines a route item used in the application's bottom navigation bar.
///
/// Each item includes the destination (icon + label), the associated view/page,
/// and an optional label override for display or accessibility purposes.
class BottomNavigationItemRoute {
  /// The navigation destination (icon and label) shown in the bottom nav bar.
  final NavigationDestination navigationDestination;

  /// The page (view) to display when this route is selected.
  final Widget pageView;

  /// An optional label override for this route (defaults to empty).
  final String label;

  BottomNavigationItemRoute({
    required this.navigationDestination,
    required this.pageView,
    this.label = "",
  });
}
