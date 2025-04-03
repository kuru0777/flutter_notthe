import 'package:flutter/material.dart';
import 'package:flutter_notthe/noteDetailsPage.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../models/note.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

class Notecard extends StatelessWidget {
  final int index;
  final Note note;
  final Function(int) onDelete;
  final Function(Note) onEdit;
  final ThemeController themeController = Get.find<ThemeController>();

  Notecard({
    super.key,
    required this.index,
    required this.note,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final category = note.category.isEmpty ? 'Genel' : note.category;
    final categoryColor = Color(note.categoryColor);

    return Obx(
      () => GestureDetector(
        onTap: () => onEdit(note),
        child: Container(
          height: 240,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: AppStyles.getNoteCardDecoration(
            themeController.isDarkMode.value,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: categoryColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          category,
                          style: TextStyle(
                            color: AppColors.getSecondaryColor(
                              themeController.isDarkMode.value,
                            ),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.title,
                      style: TextStyle(
                        color: AppColors.getSecondaryColor(
                          themeController.isDarkMode.value,
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        note.content,
                        style: TextStyle(
                          color: AppColors.getSecondaryColor(
                            themeController.isDarkMode.value,
                          ),
                          fontSize: 12,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 16),
                  onPressed: () => onDelete(index),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  iconSize: 16,
                  color: AppColors.getSecondaryColor(
                    themeController.isDarkMode.value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
