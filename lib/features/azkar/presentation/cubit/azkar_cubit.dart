import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/haptics.dart';
import '../../domain/entities/azkar_category.dart';
import '../../domain/repositories/azkar_repository.dart';
import 'azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  final AzkarRepository repository;

  AzkarCubit({required this.repository}) : super(const AzkarState());

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoading: true));
    final result = await repository.getCategories();
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (categories) => emit(state.copyWith(
        isLoading: false,
        categories: categories,
      )),
    );
  }

  Future<void> selectCategory(String categoryId) async {
    emit(state.copyWith(isLoading: true, isCategoryCelebrated: false));
    final result = await repository.getCategoryById(categoryId);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (category) => emit(state.copyWith(
        isLoading: false,
        activeCategory: category,
      )),
    );
  }

  Future<void> decrementDhikr(String dhikrId) async {
    final active = state.activeCategory;
    if (active == null) return;

    final itemIndex = active.items.indexWhere((i) => i.id == dhikrId);
    if (itemIndex == -1) return;

    final item = active.items[itemIndex];
    if (item.isCompleted) return;

    final newRemaining = item.remainingCount - 1;
    final updatedItem = item.copyWith(remainingCount: newRemaining);
    final updatedList = [...active.items]..[itemIndex] = updatedItem;
    final updatedCategory = active.copyWith(items: updatedList);

    if (newRemaining == 0) {
      AppHaptics.heavy();
    } else {
      AppHaptics.selection();
    }

    final isAllFinished = updatedCategory.isAllCompleted;

    emit(state.copyWith(
      activeCategory: updatedCategory,
      justCompletedDhikrId: newRemaining == 0 ? dhikrId : null,
      isCategoryCelebrated: isAllFinished,
    ));

    await repository.updateDhikrCount(active.id, dhikrId, newRemaining);
    _refreshCategoryInList(updatedCategory);
  }

  Future<void> resetActiveCategory() async {
    final active = state.activeCategory;
    if (active == null) return;

    AppHaptics.medium();
    await repository.resetCategory(active.id);
    final resetItems = active.items
        .map((i) => i.copyWith(remainingCount: i.targetCount))
        .toList();
    final updatedCategory = active.copyWith(items: resetItems);

    emit(state.copyWith(
      activeCategory: updatedCategory,
      isCategoryCelebrated: false,
    ));

    _refreshCategoryInList(updatedCategory);
  }

  void _refreshCategoryInList(AzkarCategory category) {
    final list = [...state.categories];
    final idx = list.indexWhere((c) => c.id == category.id);
    if (idx != -1) {
      list[idx] = category;
      emit(state.copyWith(categories: list));
    }
  }
}
