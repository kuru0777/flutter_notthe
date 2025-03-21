import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'utils/appBar.dart';
import 'utils/noteCard.dart';
import './controllers/theme_controller.dart';
import './noteDetailsPage.dart';
import './models/note.dart';
import './services/database_service.dart';
import './constants/colors.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.changeTheme});
  final String title;
  final VoidCallback changeTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService _databaseService = DatabaseService();
  List<Note> notes = [];
  IconData _themeIcon = Icons.dark_mode;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final loadedNotes = await _databaseService.getNotes();
    setState(() {
      notes = loadedNotes;
    });
  }

  void _addNote() async {
    final result = await Get.to(() => const NoteDetailsPage());
    if (result != null && result is Note) {
      try {
        await _databaseService.insertNote(result);
        setState(() {}); // Yeniden yükleme tetikle
      } catch (e) {
        debugPrint('Not eklenirken hata: $e');
        Get.snackbar(
          'Hata',
          'Not eklenirken bir sorun oluştu',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void _deleteNote(int index, Note note) async {
    try {
      await _databaseService.deleteNote(note.title);
      setState(() {}); // Yeniden yükleme tetikle
      Get.snackbar(
        'Başarılı',
        'Not silindi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('Not silinirken hata: $e');
      Get.snackbar(
        'Hata',
        'Not silinirken bir sorun oluştu',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _changeTheme() {
    setState(() {
      _themeIcon =
          _themeIcon == Icons.dark_mode ? Icons.light_mode : Icons.light_mode;
    });
    widget.changeTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        themeIcon: _themeIcon,
        onThemeChange: _changeTheme,
      ),
      body: FutureBuilder<List<Note>>(
        future: _databaseService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final notes = snapshot.data ?? [];

          if (notes.isEmpty) {
            return const Center(child: Text('Henüz not eklenmemiş'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.8,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return Notecard(
                index: index,
                note: notes[index],
                onDelete: (index) => _deleteNote(index, notes[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          backgroundColor: AppColors.getPrimaryColor(
            themeController.isDarkMode.value,
          ),
          onPressed: _addNote,
          tooltip: 'Add New Note',
          child: Icon(
            Icons.add,
            color: AppColors.getSecondaryColor(
              themeController.isDarkMode.value,
            ),
          ),
        ),
      ),
    );
  }
}
