// ignore_for_file: must_be_immutable

import 'package:agro_vision/models/drawer_item_model.dart';
import 'package:agro_vision/models/user_data_model.dart';
import 'package:agro_vision/pages/main_page/widgets/custom_drop_down_theme_mode.dart';
import 'package:agro_vision/pages/profile_page.dart';
import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  bool isError = false;

  @override
  Widget build(BuildContext context) {
    // Get main provider for user and drawer state
    MainProvider mainProvider = Provider.of(context);

    // Fallback empty user data if not available
    UserDataModel? currentUserData = mainProvider.currentUserData ??
        UserDataModel(
          name: "",
          email: "",
          image: "",
          lastTimeRequestsUpdated: DateTime.now(),
        );

    return Drawer(
      child: Column(
        children: [
          // Top user info section
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primaryFixedDim,
                Theme.of(context).colorScheme.inversePrimary,
              ]),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ListTile(
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        currentUserData.name.isEmpty
                            ? currentUserData.email
                            : currentUserData.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: currentUserData.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          placeholder: (context, url) => Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // Theme mode selector and drawer list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Theme toggle section
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.themeMode.tr()),
                        const CustomDropDownThemeMode(),
                      ],
                    ),
                  ),
                  const Divider(),

                  // List of drawer items
                  Expanded(
                    child: ListView.builder(
                      itemCount: mainProvider.drawerItemList.length,
                      itemBuilder: (_, index) {
                        bool isSelected =
                            mainProvider.selectedDrawerItemIndex == index;
                        DrawerItemModel drawerItem =
                            mainProvider.drawerItemList[index];

                        return ListTile(
                          onTap: () {
                            // If item has a widget, navigate to ProfilePage (replace with actual target if needed)
                            if (drawerItem.pageWidget != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const ProfilePage()),
                              );
                              mainProvider.setSelectedDrawerItemIndex(
                                  selectedIndex: index);
                            } else {
                              // Call any provided custom action
                              if (drawerItem.onClick != null) {
                                drawerItem.onClick!(context);
                              }
                            }
                          },
                          title: Text(
                            drawerItem.title.tr(),
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : null,
                            ),
                          ),
                          leading: Icon(
                            drawerItem.icon,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : null,
                          ),
                          selected: isSelected,
                          selectedTileColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(175),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
