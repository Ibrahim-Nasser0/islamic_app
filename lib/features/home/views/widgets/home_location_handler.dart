import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../settings/data/datasources/settings_local_data_source.dart';
import '../../../settings/presentation/views/widgets/location_selector_sheet.dart';
import '../../data/datasources/location_service.dart';
import '../../presentation/cubit/prayer_times_cubit.dart';
import '../../presentation/cubit/prayer_times_state.dart';

/// Handles tapping the Home Hero location pill: refreshes GPS if automatic,
/// opens city picker if manual, or guides user to enable GPS/permissions.
Future<void> handleHomeLocationTap(BuildContext context) async {
  final cubit = context.read<PrayerTimesCubit>();
  final state = cubit.state;
  final isAr = context.locale.languageCode == 'ar';

  if (state is PrayerTimesLoaded && state.isManualLocation) {
    _openManualCityPicker(
      context,
      cubit: cubit,
      currentName: state.schedule.getLocalizedLocation(context.locale.languageCode),
      isManual: true,
    );
    return;
  }

  final status = await cubit.refreshLocation();
  if (!context.mounted) return;

  if (status == LocationAcquireStatus.gpsDisabled ||
      status == LocationAcquireStatus.permissionDeniedForever) {
    final isDisabled = status == LocationAcquireStatus.gpsDisabled;
    final res = await AppDialogs.confirm(
      context,
      title: 'location_issue_title'.tr(),
      message: isDisabled
          ? 'location_gps_disabled_msg'.tr()
          : 'location_perm_denied_msg'.tr(),
      icon: Icons.location_off_rounded,
      iconColor: context.appColors.accentGold,
      confirmText: 'open_settings',
      cancelText: 'choose_city_manual',
    );
    if (!context.mounted) return;
    if (res == true) {
      if (isDisabled) {
        await Geolocator.openLocationSettings();
      } else {
        await Geolocator.openAppSettings();
      }
    } else if (res == false) {
      final curr = cubit.state;
      final name = curr is PrayerTimesLoaded
          ? curr.schedule.getLocalizedLocation(isAr ? 'ar' : 'en')
          : '';
      _openManualCityPicker(context, cubit: cubit, currentName: name, isManual: false);
    }
  }
}

void _openManualCityPicker(
  BuildContext context, {
  required PrayerTimesCubit cubit,
  required String currentName,
  required bool isManual,
}) {
  showCustomBottomSheet(
    context: context,
    child: LocationSelectorSheet(
      currentLocationName: currentName,
      isManual: isManual,
      onLocationSelected: (nameAr, nameEn, manual, lat, lng) async {
        final settingsDs = sl<SettingsLocalDataSource>();
        if (manual) {
          await settingsDs.setManualLocation(
            lat: lat,
            lng: lng,
            nameAr: nameAr,
            nameEn: nameEn,
          );
        } else {
          await settingsDs.resetToGps();
        }
        await cubit.loadPrayerTimes();
      },
    ),
  );
}
