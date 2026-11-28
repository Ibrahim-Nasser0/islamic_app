import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/hadith_item.dart';
import '../../domain/repositories/hadith_repository.dart';
import 'hadith_state.dart';

class HadithCubit extends Cubit<HadithState> {
  static const int pageSize = 30;
  final HadithRepository repository;
  Timer? _searchDebounce;
  int _requestToken = 0;

  HadithCubit({required this.repository}) : super(const HadithState());

  Future<void> loadHadiths(String bookId) async {
    _searchDebounce?.cancel();
    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        activeBookId: bookId,
        searchQuery: '',
        gradeFilter: null,
        hadiths: const [],
        totalCount: 0,
        hasMore: true,
        errorMessage: null,
      ),
    );
    await _fetchFirstPage();
  }

  Future<void> setGradeFilter(String? gradeTier) async {
    if (state.activeBookId.isEmpty || state.gradeFilter == gradeTier) return;
    _searchDebounce?.cancel();
    emit(
      state.copyWith(
        gradeFilter: gradeTier,
        isLoading: true,
        isLoadingMore: false,
        hadiths: const [],
        errorMessage: null,
      ),
    );
    await _fetchFirstPage();
  }

  void searchHadiths(String query) {
    if (state.activeBookId.isEmpty) return;
    _searchDebounce?.cancel();
    final trimmed = query.trim();
    if (trimmed == state.searchQuery) return;
    if (trimmed.isEmpty) {
      emit(state.copyWith(searchQuery: '', isLoading: true, hadiths: const []));
      _fetchFirstPage();
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 220), () {
      if (isClosed) return;
      emit(state.copyWith(searchQuery: trimmed, isLoading: true, hadiths: const []));
      _fetchFirstPage();
    });
  }

  Future<void> _fetchFirstPage() async {
    final token = ++_requestToken;
    final bookId = state.activeBookId;
    final grade = state.gradeFilter;
    final query = state.searchQuery;

    final pageFuture = repository.getHadithsPage(
      bookId,
      limit: pageSize,
      offset: 0,
      gradeTier: grade,
      searchQuery: query.isEmpty ? null : query,
    );
    final countFuture = repository.countHadiths(bookId, gradeTier: grade);

    final pageResult = await pageFuture;
    final countResult = await countFuture;
    if (isClosed || token != _requestToken) return;

    final totalCount = countResult.fold((_) => 0, (c) => c);
    pageResult.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          totalCount: totalCount,
          hasMore: false,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          hadiths: items,
          totalCount: query.isEmpty ? totalCount : items.length,
          hasMore: items.length >= pageSize,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> loadMoreHadiths() async {
    if (state.activeBookId.isEmpty ||
        state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }
    final token = _requestToken;
    emit(state.copyWith(isLoadingMore: true, errorMessage: null));

    final result = await repository.getHadithsPage(
      state.activeBookId,
      limit: pageSize,
      offset: state.hadiths.length,
      gradeTier: state.gradeFilter,
      searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
    );
    if (isClosed || token != _requestToken) return;

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, errorMessage: failure.message),
      ),
      (nextItems) => emit(
        state.copyWith(
          isLoadingMore: false,
          hadiths: [...state.hadiths, ...nextItems],
          hasMore: nextItems.length >= pageSize,
          errorMessage: null,
        ),
      ),
    );
  }

  void selectHadith(HadithItem hadith) {
    emit(state.copyWith(selectedHadith: hadith));
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
