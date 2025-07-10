// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:agro_vision/models/user_data_model.dart';
import 'package:agro_vision/pages/main_page/widgets/app_drawer.dart';
import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:agro_vision/widgets/calculating_environment_values_dialog.dart';
import 'package:agro_vision/widgets/custom_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _profileImageUrl = "";
  String? _nameErrorText;

  @override
  void initState() {
    super.initState();

    // Get user data from MainProvider
    MainProvider mainProvider = Provider.of(context, listen: false);
    UserDataModel userData = mainProvider.currentUserData ??
        UserDataModel(
          name: "",
          email: "",
          image: "",
          imageFileName: "",
          lastTimeRequestsUpdated: DateTime.now(),
        );

    _nameController.text = userData.name;
    _emailController.text = userData.email;
    _profileImageUrl = userData.image;
  }

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of(context);
    UserDataModel userData = mainProvider.currentUserData ??
        UserDataModel(
          name: "",
          email: "",
          image: "",
          imageFileName: "",
          lastTimeRequestsUpdated: DateTime.now(),
        );
    XFile? selectedImage = mainProvider.selectedProfileImage;
    bool isButtonEnable = _nameErrorText == null;

    return PopScope(
      onPopInvokedWithResult: (isPopped, result) {
        mainProvider.setSelectedDrawerItemIndex(selectedIndex: null);
      },
      child: PopScope(
        onPopInvokedWithResult: (isPopped, result) {
          mainProvider.clearProfileImage(); // Clear selected image on pop
        },
        child: Scaffold(
          appBar: CustomAppBar(title: AppStrings.profile.tr()),
          drawer: AppDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image Picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          await mainProvider.pickImageFromGallery();
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: selectedImage == null
                              ? CachedNetworkImageProvider(
                                  _profileImageUrl,
                                  errorListener: (p0) {},
                                )
                              : FileImage(File(selectedImage.path)),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: selectedImage == null &&
                                    _profileImageUrl.isEmpty
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Name Field
                  TextField(
                    controller: _nameController,
                    onChanged: (value) {
                      if (_nameController.text.isEmpty) {
                        _nameErrorText = AppStrings.nameEmptyErrorMessage.tr();
                      } else {
                        _nameErrorText = null;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text(AppStrings.fullName.tr()),
                      errorText: _nameErrorText,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Email Field (Read-only)
                  TextField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      label: Text(AppStrings.email.tr()),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Update Profile Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: !isButtonEnable
                        ? null
                        : () async {
                            bool isValid = _validateInput();
                            isButtonEnable = isValid;
                            setState(() {});

                            if (isValid) {
                              CalculatingEnvironmentValuesDialog.show(
                                context,
                                message: AppStrings.pleaseWaitMessage.tr(),
                              );

                              // New user data object
                              UserDataModel newUserData = UserDataModel(
                                id: userData.id,
                                name: _nameController.text,
                                email: _emailController.text,
                                image: userData.image,
                                imageFileName: userData.imageFileName,
                                lastTimeRequestsUpdated: DateTime.now(),
                              );

                              // Upload new image if selected
                              if (selectedImage != null) {
                                String imageFileName =
                                    "image_${const Uuid().v4().substring(0, 6)}";
                                if (_profileImageUrl.isNotEmpty) {
                                  // Replace old image
                                  String newImageUrl =
                                      await mainProvider.updateProfileImage(
                                    oldImageFileName: userData.imageFileName,
                                    newImageFile: File(selectedImage.path),
                                    newImageFileName: imageFileName,
                                    onError: (e) {
                                      CalculatingEnvironmentValuesDialog.hide(
                                          context);
                                      AppFunctions.showToastMessage(
                                        msg: AppStrings.errorMessage.tr(),
                                      );
                                    },
                                  );
                                  newUserData.image = newImageUrl;
                                  newUserData.imageFileName = imageFileName;
                                } else {
                                  // Upload new image
                                  String newImageUrl =
                                      await mainProvider.uploadProfileImage(
                                    imageFile: File(selectedImage.path),
                                    imageFileName: imageFileName,
                                    onError: (e) {
                                      CalculatingEnvironmentValuesDialog.hide(
                                          context);
                                      AppFunctions.showToastMessage(
                                        msg: AppStrings.errorMessage.tr(),
                                      );
                                    },
                                  );
                                  newUserData.image = newImageUrl;
                                  newUserData.imageFileName = imageFileName;
                                }
                              }

                              // Check if name or image changed
                              if (newUserData.name != userData.name ||
                                  selectedImage != null) {
                                mainProvider.updateUserData(
                                  userData: newUserData,
                                  onUserDataUpdated: () {
                                    CalculatingEnvironmentValuesDialog.hide(
                                        context);
                                    AppFunctions.showToastMessage(
                                      msg: AppStrings
                                          .profileUpdateSuccessMessage
                                          .tr(),
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  onError: () {
                                    CalculatingEnvironmentValuesDialog.hide(
                                        context);
                                    AppFunctions.showSnackBar(
                                      context: context,
                                      msg: AppStrings.errorMessage.tr(),
                                    );
                                  },
                                );
                              } else {
                                CalculatingEnvironmentValuesDialog.hide(
                                    context);
                                AppFunctions.showToastMessage(
                                  msg: AppStrings.profileUpdateSuccessMessage
                                      .tr(),
                                );
                                Navigator.of(context).pop();
                              }
                            }
                          },
                    child: Text(AppStrings.updateProfile.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Validate name input
  bool _validateInput() {
    if (_nameController.text.isEmpty) {
      _nameErrorText = "Name can't be empty!";
    } else {
      _nameErrorText = null;
    }

    return _nameErrorText == null;
  }
}
