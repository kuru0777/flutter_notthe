import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/theme_controller.dart';
import 'models/note.dart';
import 'constants/colors.dart';
import 'constants/styles.dart';
import 'services/database_service.dart';

class NoteDetailsPage extends StatefulWidget {
  final Note? initialNote;
  final bool isEditing;

  const NoteDetailsPage({super.key, this.initialNote, this.isEditing = false});

  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  final categoryController = TextEditingController();
  final themeController = Get.find<ThemeController>();
  final DatabaseService _databaseService = DatabaseService();
  String _selectedCategory = 'Genel';
  Set<String> _categories = {'Genel'};
  bool _isAddingCategory = false;
  Color _selectedColor = Colors.red;
  final Map<String, Color> _categoryColors = {'Genel': Colors.red};

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _initializeControllers();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _databaseService.getCategories();
      final categoryColors = await _databaseService.getCategoryColors();

      setState(() {
        // Set'e dönüştürerek benzersiz kategorileri al
        _categories = {...categories, 'Genel'};

        // Veritabanından gelen renkleri kullan
        for (var colorData in categoryColors) {
          final category = colorData['category'] as String;
          final color = colorData['categoryColor'] as int;
          _categoryColors[category] = Color(color);
        }

        // Eksik kategoriler için varsayılan renk ata
        for (var category in _categories) {
          if (!_categoryColors.containsKey(category)) {
            _categoryColors[category] = _getDefaultColor(category);
          }
        }
      });
    } catch (e) {
      debugPrint('Kategoriler yüklenirken hata: $e');
    }
  }

  void _initializeControllers() {
    if (widget.initialNote != null) {
      titleController.text = widget.initialNote!.title;
      noteController.text = widget.initialNote!.content;

      // Kategori kontrolü
      final noteCategory = widget.initialNote!.category;
      if (noteCategory.isNotEmpty) {
        _selectedCategory = noteCategory;
        _categories.add(noteCategory); // Kategoriyi Set'e ekle
        if (!_categoryColors.containsKey(noteCategory)) {
          _categoryColors[noteCategory] = _getDefaultColor(noteCategory);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.getPrimaryColor(
        themeController.isDarkMode.value,
      ),
      title: Text(
        widget.isEditing ? 'Notu Düzenle' : 'Yeni Not',
        style: TextStyle(
          color: AppColors.getSecondaryColor(themeController.isDarkMode.value),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCategorySection(),
          const SizedBox(height: 16),
          _buildTitleField(),
          const SizedBox(height: 16),
          _buildNoteField(),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final sortedCategories =
        _categories.toList()..sort(); // Kategorileri sırala

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isAddingCategory) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: categoryController,
                  decoration: AppStyles.getInputDecoration(
                    'Yeni Kategori',
                    themeController.isDarkMode.value,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _addNewCategory,
                color: AppColors.getSecondaryColor(
                  themeController.isDarkMode.value,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _isAddingCategory = false),
                color: AppColors.getSecondaryColor(
                  themeController.isDarkMode.value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildColorPicker(),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value:
                      _categories.contains(_selectedCategory)
                          ? _selectedCategory
                          : 'Genel',
                  decoration: AppStyles.getInputDecoration(
                    'Kategori',
                    themeController.isDarkMode.value,
                  ),
                  items:
                      sortedCategories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _categoryColors[category] ?? Colors.red,
                                ),
                              ),
                              Text(category),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                        _selectedColor =
                            _categoryColors[newValue] ?? Colors.red;
                      });
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _isAddingCategory = true),
                color: AppColors.getSecondaryColor(
                  themeController.isDarkMode.value,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori Rengi',
          style: TextStyle(
            color: AppColors.getSecondaryColor(
              themeController.isDarkMode.value,
            ),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.purple,
                Colors.teal,
                Colors.pink,
                Colors.indigo,
                Colors.amber,
                Colors.cyan,
              ].map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: Border.all(
                        color:
                            _selectedColor == color
                                ? AppColors.getSecondaryColor(
                                  themeController.isDarkMode.value,
                                )
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  void _addNewCategory() {
    final newCategory = categoryController.text.trim();
    if (newCategory.isNotEmpty && !_categories.contains(newCategory)) {
      setState(() {
        _categories.add(newCategory);
        _selectedCategory = newCategory;
        _categoryColors[newCategory] = _selectedColor;
        _isAddingCategory = false;
      });
      categoryController.clear();
    }
  }

  Color _getDefaultColor(String category) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];
    final index = category.hashCode % colors.length;
    return colors[index];
  }

  Widget _buildTitleField() {
    return TextField(
      controller: titleController,
      decoration: AppStyles.getInputDecoration(
        'Not Başlığı',
        themeController.isDarkMode.value,
      ),
    );
  }

  Widget _buildNoteField() {
    return Expanded(
      child: TextField(
        controller: noteController,
        textAlignVertical: TextAlignVertical.top,
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        decoration: AppStyles.getInputDecoration(
          'Bir şeyler yazın...',
          themeController.isDarkMode.value,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Obx(
      () => FloatingActionButton(
        backgroundColor: AppColors.getPrimaryColor(
          themeController.isDarkMode.value,
        ),
        onPressed: _handleSave,
        child: Icon(
          Icons.done,
          color: AppColors.getSecondaryColor(themeController.isDarkMode.value),
        ),
      ),
    );
  }

  void _handleSave() async {
    final title = titleController.text.trim();
    final content = noteController.text.trim();
    if (title.isNotEmpty) {
      // Kategori rengini güncelle
      await _databaseService.updateCategoryColor(
        _selectedCategory,
        _selectedColor.value,
      );

      Get.back(
        result: Note(
          id: widget.initialNote?.id,
          title: title,
          content: content,
          category: _selectedCategory,
          categoryColor: _selectedColor.value,
        ),
      );
    }
  }
}
