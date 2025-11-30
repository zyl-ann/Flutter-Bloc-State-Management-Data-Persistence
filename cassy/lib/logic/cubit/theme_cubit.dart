import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
// ignore: unused_import
import '../../core/constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box themeBox;

  ThemeCubit(this.themeBox) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = themeBox.get('isDark', defaultValue: false);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    final isDark = state == ThemeMode.dark;
    themeBox.put('isDark', !isDark);
    emit(!isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
