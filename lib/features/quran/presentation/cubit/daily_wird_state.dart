import 'package:equatable/equatable.dart';
import '../../domain/entities/daily_wird_verse.dart';

class DailyWirdState extends Equatable {
  final DailyWirdSlice? slice;
  final int dailyCount;
  final bool isCompletedForCurrentBatch;
  final bool isLoading;

  const DailyWirdState({
    this.slice,
    this.dailyCount = 5,
    this.isCompletedForCurrentBatch = false,
    this.isLoading = true,
  });

  DailyWirdState copyWith({
    DailyWirdSlice? slice,
    int? dailyCount,
    bool? isCompletedForCurrentBatch,
    bool? isLoading,
  }) {
    return DailyWirdState(
      slice: slice ?? this.slice,
      dailyCount: dailyCount ?? this.dailyCount,
      isCompletedForCurrentBatch:
          isCompletedForCurrentBatch ?? this.isCompletedForCurrentBatch,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        slice,
        dailyCount,
        isCompletedForCurrentBatch,
        isLoading,
      ];
}
