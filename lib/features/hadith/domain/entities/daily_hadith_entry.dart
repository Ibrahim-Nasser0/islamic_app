import 'package:equatable/equatable.dart';

import 'hadith_item.dart';

/// Pairs a [HadithItem] with its source collection identifier.
class DailyHadithEntry extends Equatable {
  final String bookId;
  final HadithItem hadith;

  const DailyHadithEntry({
    required this.bookId,
    required this.hadith,
  });

  @override
  List<Object?> get props => [bookId, hadith];
}
