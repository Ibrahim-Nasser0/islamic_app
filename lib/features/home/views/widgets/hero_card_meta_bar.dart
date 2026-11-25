import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/haptics.dart';
import '../../presentation/models/time_of_day_atmosphere.dart';

/// Top bar in Hero Card displaying Location Pill & Hijri/Gregorian Date Column
class HeroCardMetaBar extends StatelessWidget {
  final String location;
  final String hijriDate;
  final String gregorianDate;
  final DayAtmosphere atmosphere;
  final VoidCallback? onLocationTap;

  const HeroCardMetaBar({
    super.key,
    required this.location,
    required this.hijriDate,
    required this.gregorianDate,
    required this.atmosphere,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final locationPill = Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1.0,
      child: InkWell(
        onTap: () {
          AppHaptics.light();
          onLocationTap?.call();
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: atmosphere.accentColor.withValues(alpha: 0.25),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 14.sp,
                color: atmosphere.accentColor,
              ),
              SizedBox(width: 4.w),
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
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: Align(
          alignment: AlignmentDirectional.topStart,
          child: locationPill,
        )),
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
