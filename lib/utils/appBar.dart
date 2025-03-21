import 'package:flutter/material.dart';
import '../controllers/theme_controller.dart';
import '../constants/colors.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData themeIcon;
  final VoidCallback onThemeChange;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.themeIcon,
    required this.onThemeChange,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => AppBar(
        backgroundColor: AppColors.getPrimaryColor(
          themeController.isDarkMode.value,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppColors.getSecondaryColor(
              themeController.isDarkMode.value,
            ),
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.getSecondaryColor(
                themeController.isDarkMode.value,
              ),
            ),
            child: IconButton(
              onPressed: () => themeController.toggleTheme(),
              icon: Icon(
                themeController.isDarkMode.value
                    ? Icons.brightness_6
                    : Icons.dark_mode,
                color: AppColors.getPrimaryColor(
                  themeController.isDarkMode.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
