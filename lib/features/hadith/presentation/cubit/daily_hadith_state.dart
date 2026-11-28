import 'package:equatable/equatable.dart';

import '../../domain/entities/daily_hadith_entry.dart';

class DailyHadithState extends Equatable {
  final bool isLoading;
  final DailyHadithEntry? entry;
  final String? activeDateKey;
  final String? errorMessage;

  const DailyHadithState({
    this.isLoading = true,
    this.entry,
    this.activeDateKey,
    this.errorMessage,
  });

  DailyHadithState copyWith({
    bool? isLoading,
    DailyHadithEntry? entry,
    String? activeDateKey,
    String? errorMessage,
  }) {
    return DailyHadithState(
      isLoading: isLoading ?? this.isLoading,
      entry: entry ?? this.entry,
      activeDateKey: activeDateKey ?? this.activeDateKey,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, entry, activeDateKey, errorMessage];
}
