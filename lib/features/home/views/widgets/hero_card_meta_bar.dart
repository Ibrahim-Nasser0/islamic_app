import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/haptics.dart';
import '../../presentation/models/time_of_day_atmosphere.dart';

/// Top bar in Hero Card showing live GPS/manual location status & Hijri/Gregorian dates.
class HeroCardMetaBar extends StatelessWidget {
  final String location;
  final String hijriDate;
  final String gregorianDate;
  final DayAtmosphere atmosphere;
  final bool isManualLocation;
  final bool isRefreshingLocation;
  final VoidCallback? onLocationTap;

  const HeroCardMetaBar({
    super.key,
    required this.location,
    required this.hijriDate,
    required this.gregorianDate,
    required this.atmosphere,
    this.isManualLocation = false,
    this.isRefreshingLocation = false,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final locationPill = Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1.0,
      child: InkWell(
        onTap: isRefreshingLocation
            ? null
            : () {
                AppHaptics.light();
                onLocationTap?.call();
              },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: atmosphere.accentColor.withValues(alpha: 0.30),
              width: 0.85,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isRefreshingLocation)
                SizedBox(
                  width: 12.sp,
                  height: 12.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.6,
                    color: atmosphere.accentColor,
                  ),
                )
              else
                Icon(
                  isManualLocation
                      ? Icons.location_city_rounded
                      : Icons.my_location_rounded,
                  size: 13.5.sp,
                  color: atmosphere.accentColor,
                ),
              SizedBox(width: 5.w),
              Flexible(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!isRefreshingLocation) ...[
                SizedBox(width: 4.w),
                Icon(
                  Icons.sync_rounded,
                  size: 11.5.sp,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    final dateColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          hijriDate,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: atmosphere.accentColor,
            letterSpacing: 0.2,
          ),
        ),
        Gap(2.h),
        Text(
          gregorianDate,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: locationPill,
          ),
        ),
        Gap(8.w),
        Flexible(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.topEnd,
            child: dateColumn,
          ),
        ),
      ],
    );
  }
}
