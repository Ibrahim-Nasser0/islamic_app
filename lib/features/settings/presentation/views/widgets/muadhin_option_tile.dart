import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import '/../../../core/utils/extensions.dart';
import '../../models/muadhin_option.dart';

class MuadhinOptionTile extends StatelessWidget {
  final MuadhinOption option;
  final bool isSelected;
  final String? currentPlayingPath;
  final bool isPlaying;
  final VoidCallback onSelect;
  final ValueChanged<String> onToggleAudio;

  const MuadhinOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.currentPlayingPath,
    required this.isPlaying,
    required this.onSelect,
    required this.onToggleAudio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.08)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected
              ? appColors.accentGold.withValues(alpha: 0.7)
              : appColors.cardBorder,
          width: isSelected ? 1.4 : 0.8,
        ),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSelect,
              borderRadius: BorderRadius.circular(12.r),
              child: Row(
                children: [
                  Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? appColors.accentGold.withValues(alpha: 0.15)
                          : appColors.badgeBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.volume_up_rounded,
                      size: 20.sp,
                      color: isSelected
                          ? appColors.accentGold
                          : theme.colorScheme.primary,
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.nameKey.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Gap(2.h),
                        Text(
                          option.location,
                          style: TextStyle(fontSize: 11.sp, color: appColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: appColors.accentGold,
                      size: 22.sp,
                    ),
                ],
              ),
            ),
          ),
          Gap(10.h),
          Row(
            children: [
              _buildAudioChip(
                context,
                label: 'preview_regular_adhan'.tr(),
                audioPath: option.regularAudioPath,
              ),
              Gap(8.w),
              _buildAudioChip(
                context,
                label: 'preview_fajr_adhan'.tr(),
                audioPath: option.fajrAudioPath,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioChip(
    BuildContext context, {
    required String label,
    required String audioPath,
  }) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isPlayingThis = currentPlayingPath == audioPath && isPlaying;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onToggleAudio(audioPath),
          borderRadius: BorderRadius.circular(10.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: isPlayingThis
                  ? theme.colorScheme.primary.withValues(alpha: 0.15)
                  : appColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isPlayingThis
                    ? theme.colorScheme.primary
                    : appColors.cardBorder,
                width: isPlayingThis ? 1.2 : 0.8,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPlayingThis
                      ? Icons.stop_circle_rounded
                      : Icons.play_circle_fill_rounded,
                  size: 16.sp,
                  color: isPlayingThis
                      ? theme.colorScheme.primary
                      : appColors.accentGold,
                ),
                Gap(5.w),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight:
                          isPlayingThis ? FontWeight.bold : FontWeight.w500,
                      color: isPlayingThis
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
