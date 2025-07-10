import 'package:flutter/material.dart';

/// A reusable custom AppBar widget with configurable title and actions.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // The title displayed in the AppBar
  final List<Widget>? actions; // Optional action buttons (e.g., icons)

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Uses the theme's inversePrimary color for background
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      
      // Sets the title text
      title: Text(title),
      
      // Adds action buttons if provided
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
