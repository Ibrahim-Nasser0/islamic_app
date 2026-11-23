import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'dhikr_item.dart';

/// Category containing a collection of authentic Dhikr items (e.g. Morning, Evening)
class AzkarCategory extends Equatable {
  final String id;
  final String titleKey;
  final String subtitleKey;
  final IconData icon;
  final List<DhikrItem> items;

  const AzkarCategory({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    required this.items,
  });

  int get totalItems => items.length;

  int get completedItems => items.where((i) => i.isCompleted).length;

  double get overallProgress =>
      totalItems > 0 ? (completedItems / totalItems).clamp(0.0, 1.0) : 0.0;

  bool get isAllCompleted => totalItems > 0 && completedItems == totalItems;

  AzkarCategory copyWith({
    String? id,
    String? titleKey,
    String? subtitleKey,
    IconData? icon,
    List<DhikrItem>? items,
  }) {
    return AzkarCategory(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      subtitleKey: subtitleKey ?? this.subtitleKey,
      icon: icon ?? this.icon,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [id, titleKey, subtitleKey, icon, items];
}
