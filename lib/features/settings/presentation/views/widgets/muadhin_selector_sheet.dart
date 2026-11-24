import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import '/../../../core/theme/typography.dart';
import '/../../../core/utils/extensions.dart';
import '/../../../core/utils/haptics.dart';
import '/../../../core/widgets/animations/button_animation.dart';
import '/../../../core/widgets/custom_button.dart';

import '../../models/muadhin_option.dart';
import 'muadhin_option_tile.dart';

class MuadhinSelectorSheet extends StatefulWidget {
  final String selectedId;
  final ValueChanged<MuadhinOption> onSelect;

  const MuadhinSelectorSheet({
    super.key,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  State<MuadhinSelectorSheet> createState() => _MuadhinSelectorSheetState();
}

class _MuadhinSelectorSheetState extends State<MuadhinSelectorSheet> {
  late final AudioPlayer _player;
  late String _tempSelectedId;
  String? _currentPlayingPath;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _tempSelectedId = widget.selectedId;
    _player = AudioPlayer();
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (!_isPlaying) _currentPlayingPath = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio(String audioPath) async {
    if (_currentPlayingPath == audioPath && _isPlaying) {
      AppHaptics.light();
      await _player.stop();
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentPlayingPath = null;
        });
      }
    } else {
      AppHaptics.medium();
      await _player.stop();
      await _player.play(AssetSource(audioPath));
      if (mounted) {
        setState(() {
          _isPlaying = true;
          _currentPlayingPath = audioPath;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  FlutterIslamicIcons.solidPrayer,
                  color: appColors.accentGold,
                  size: 22.sp,
                ),
                Gap(10.w),
                Text(
                  'select_muadhin'.tr(),
                  style: AppTypography.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Gap(4.h),
            Text(
              'selected_muadhin_subtitle'.tr(),
              style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
            ),
            Gap(16.h),
            ...MuadhinOption.defaultList.map((option) {
              final isSelected = option.id == _tempSelectedId;

              return MuadhinOptionTile(
                option: option,
                isSelected: isSelected,
                currentPlayingPath: _currentPlayingPath,
                isPlaying: _isPlaying,
                onSelect: () {
                  AppHaptics.selection();
                  setState(() {
                    _tempSelectedId = option.id;
                  });
                  _toggleAudio(option.regularAudioPath);
                },
                onToggleAudio: _toggleAudio,
              );
            }),
            Gap(12.h),
            CustomButton(
              text: 'confirm_selection'.tr(),
              icon: Icons.check_circle_rounded,
              height: 48.h,
              borderRadius: 14,
              fontSize: 14.sp,
              onPressed: () {
                AppHaptics.medium();
                _player.stop();
                final chosen = MuadhinOption.defaultList.firstWhere(
                  (m) => m.id == _tempSelectedId,
                  orElse: () => MuadhinOption.defaultList.first,
                );
                widget.onSelect(chosen);
                Navigator.pop(context);
              },
            ).buttonAnimation(),
          ],
        ),
      ),
    );
  }
}
