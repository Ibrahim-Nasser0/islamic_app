import 'package:material_ui/material_ui.dart';

class PageViewItemModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badgeText;

  const PageViewItemModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeText,
  });
}
