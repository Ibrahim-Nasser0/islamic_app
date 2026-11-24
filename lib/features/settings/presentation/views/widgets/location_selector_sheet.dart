import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/services/location_preference_service.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/custom_text_field.dart';
import 'package:islamic_app/features/home/data/datasources/city_resolver_helper.dart';
import 'package:islamic_app/features/home/data/datasources/location_service.dart';
import 'package:material_ui/material_ui.dart';

import 'location_gps_tile.dart';

class LocationSelectorSheet extends StatefulWidget {
  final String currentLocationName;
  final bool isManual;
  final void Function(String nameAr, String nameEn, bool isManual, double lat, double lng) onLocationSelected;

  const LocationSelectorSheet({
    super.key,
    required this.currentLocationName,
    required this.isManual,
    required this.onLocationSelected,
  });

  @override
  State<LocationSelectorSheet> createState() => _LocationSelectorSheetState();
}

class _LocationSelectorSheetState extends State<LocationSelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoadingGps = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectGps() async {
    setState(() => _isLoadingGps = true);
    AppHaptics.medium();
    await LocationPreferenceService.resetToGps();
    final loc = await LocationService().getCurrentLocation();
    if (!mounted) return;
    setState(() => _isLoadingGps = false);
    widget.onLocationSelected(loc.nameAr, loc.nameEn, false, loc.latitude, loc.longitude);
    Navigator.pop(context);
  }

  void _selectCity(({String nameAr, String nameEn, double lat, double lng}) city) async {
    AppHaptics.selection();
    await LocationPreferenceService.setManualLocation(
      latitude: city.lat,
      longitude: city.lng,
      nameAr: city.nameAr,
      nameEn: city.nameEn,
    );
    if (!mounted) return;
    widget.onLocationSelected(city.nameAr, city.nameEn, true, city.lat, city.lng);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isArabic = context.locale.languageCode == 'ar';

    final filteredCities = CityResolverHelper.knownLocations.where((loc) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return loc.nameAr.toLowerCase().contains(q) || loc.nameEn.toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'select_location'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Gap(4.h),
          Text(
            'location_sheet_desc'.tr(),
            style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
          ),
          Gap(14.h),
          LocationGpsTile(
            isManual: widget.isManual,
            isLoading: _isLoadingGps,
            onTap: _selectGps,
          ),
          Gap(12.h),
          Text(
            'or_select_city'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: appColors.textMuted,
            ),
          ),
          Gap(8.h),
          CustomTextField(
            controller: _searchController,
            hint: 'search_city_hint'.tr(),
            prefixIcon: Icon(Icons.search_rounded, size: 18.sp, color: appColors.accentGold),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          Gap(10.h),
          SizedBox(
            height: 240.h,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredCities.length,
              separatorBuilder: (context, index) => Divider(color: appColors.cardBorder, height: 1),
              itemBuilder: (context, idx) {
                final city = filteredCities[idx];
                final cityName = isArabic ? city.nameAr : city.nameEn;
                final isSelected =
                    widget.isManual &&
                    (widget.currentLocationName.contains(city.nameAr) ||
                        widget.currentLocationName.contains(city.nameEn));

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _selectCity(city),
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18.sp,
                            color: isSelected ? appColors.accentGold : appColors.textMuted,
                          ),
                          Gap(10.w),
                          Expanded(
                            child: Text(
                              cityName,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? appColors.accentGold : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_rounded, size: 18.sp, color: appColors.accentGold),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
