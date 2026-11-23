import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import 'package:quran/quran.dart' as quran;

import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../presentation/cubit/quran_cubit.dart';
import '../presentation/cubit/quran_state.dart';
import 'widgets/quran_ayah_tile.dart';
import 'widgets/quran_continuous_view.dart';
import 'widgets/quran_reader_app_bar.dart';
import 'widgets/surah_header_banner.dart';

/// Full-screen Quran Reader supporting Continuous Mushaf flow and Ayah-by-Ayah modes
class QuranReaderScreen extends StatefulWidget {
  final int initialSurahNumber;
  final int initialAyah;

  const QuranReaderScreen({
    super.key,
    required this.initialSurahNumber,
    this.initialAyah = 1,
  });

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  late int _currentSurahNumber;
  bool _isContinuousMode = true;

  @override
  void initState() {
    super.initState();
    _currentSurahNumber = widget.initialSurahNumber.clamp(1, 114);
  }

  void _changeSurah(int newSurah) {
    if (newSurah < 1 || newSurah > 114) return;
    AppHaptics.selection();
    setState(() => _currentSurahNumber = newSurah);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuranCubit>(),
      child: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          final cubit = context.read<QuranCubit>();
          final totalVerses = quran.getVerseCount(_currentSurahNumber);
          final surahName = quran.getSurahNameArabic(_currentSurahNumber);
          final appColors = context.appColors;

          return Scaffold(
            appBar: QuranReaderAppBar(
              title: 'سُورَةُ $surahName',
              fontSize: state.fontSize,
              isContinuousMode: _isContinuousMode,
              onToggleMode: () =>
                  setState(() => _isContinuousMode = !_isContinuousMode),
              onIncreaseFont: cubit.increaseFontSize,
              onDecreaseFont: cubit.decreaseFontSize,
            ),
            body: SafeArea(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 30.h),
                children: [
                  // 1. Ornamental Surah Header & Basmala
                  SurahHeaderBanner(surahNumber: _currentSurahNumber),

                  // 2. Reader Body
                  if (_isContinuousMode)
                    QuranContinuousView(
                      surahNumber: _currentSurahNumber,
                      totalVerses: totalVerses,
                      fontSize: state.fontSize,
                      onAyahTap: (ayah) => cubit.saveLastRead(
                        surahNumber: _currentSurahNumber,
                        ayahNumber: ayah,
                      ),
                    )
                  else
                    ...List.generate(totalVerses, (index) {
                      final ayahNum = index + 1;
                      final verseText = quran.getVerse(
                        _currentSurahNumber,
                        ayahNum,
                        verseEndSymbol: false,
                      );
                      final isBookmarked = cubit.isBookmarked(
                        _currentSurahNumber,
                        ayahNum,
                      );

                      return QuranAyahTile(
                        surahNumber: _currentSurahNumber,
                        ayahNumber: ayahNum,
                        verseText: verseText,
                        fontSize: state.fontSize,
                        isBookmarked: isBookmarked,
                        onToggleBookmark: () => cubit.toggleBookmark(
                          surahNumber: _currentSurahNumber,
                          ayahNumber: ayahNum,
                        ),
                        onSetLastRead: () {
                          cubit.saveLastRead(
                            surahNumber: _currentSurahNumber,
                            ayahNumber: ayahNum,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم حفظ آية $ayahNum كآخر قراءة',
                                textAlign: TextAlign.center,
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      );
                    }),
                  Gap(20.h),

                  // 3. Navigation between Surahs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentSurahNumber > 1)
                        OutlinedButton.icon(
                          onPressed: () =>
                              _changeSurah(_currentSurahNumber - 1),
                          icon: const Icon(Icons.arrow_back_rounded, size: 16),
                          label: Text('previous_surah'.tr()),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: appColors.cardBorder),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      if (_currentSurahNumber < 114)
                        ElevatedButton.icon(
                          onPressed: () =>
                              _changeSurah(_currentSurahNumber + 1),
                          label: Text('next_surah'.tr()),
                          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.accentGold,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
