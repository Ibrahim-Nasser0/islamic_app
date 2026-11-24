import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/widgets/custom_skeleton.dart';
import 'package:material_ui/material_ui.dart';


class MosquesSkeletonView extends StatelessWidget {
  const MosquesSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              CustomSkeleton(width: 44.r, height: 44.r, borderRadius: 12),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSkeleton(width: 140.w, height: 16.h, borderRadius: 4),
                    Gap(6.h),
                    CustomSkeleton(width: 100.w, height: 12.h, borderRadius: 4),
                    Gap(8.h),
                    Row(
                      children: [
                        CustomSkeleton(width: 50.w, height: 12.h, borderRadius: 4),
                        Gap(8.w),
                        CustomSkeleton(width: 70.w, height: 12.h, borderRadius: 4),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              const CustomSkeleton.circular(size: 28),
            ],
          ),
        );
      },
    );
  }
}
