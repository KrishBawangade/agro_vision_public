import 'package:flutter/material.dart';

/// Model class representing an item in the app's navigation drawer.
class DrawerItemModel {
  /// Title of the drawer item
  final String title;

  /// Icon to be displayed alongside the title
  final IconData icon;

  /// Optional page widget to navigate to when the item is tapped
  final Widget? pageWidget;

  /// Optional custom click handler if you want to perform a custom action
  /// instead of direct navigation
  final Function(BuildContext context)? onClick;

  /// Constructor to initialize a drawer item with a title, icon,
  /// and optionally a page or an onClick handler
  DrawerItemModel({
    required this.title,
    required this.icon,
    this.pageWidget,
    this.onClick,
  });
}
