import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubit/mosques_cubit.dart';
import '../cubit/mosques_state.dart';
import 'widgets/mosque_floating_card.dart';
import 'widgets/mosque_radius_bar.dart';
import 'widgets/mosques_app_bar.dart';
import 'widgets/mosques_list_view.dart';
import 'widgets/mosques_map_view.dart';
import 'widgets/mosques_skeleton_view.dart';

class MosquesScreen extends StatelessWidget {
  const MosquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MosquesCubit>()..loadNearbyMosques(),
      child: const _MosquesScreenContent(),
    );
  }
}

class _MosquesScreenContent extends StatelessWidget {
  const _MosquesScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return BlocBuilder<MosquesCubit, MosquesState>(
      builder: (context, state) {
        final cubit = context.read<MosquesCubit>();

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: MosquesAppBar(
            mosquesCount: state.mosques.length,
            isMapView: state.isMapView,
            onToggleView: cubit.toggleViewMode,
            onRefresh: cubit.loadNearbyMosques,
          ),
          body: Column(
            children: [
              MosqueRadiusBar(
                selectedRadius: state.radiusInMeters,
                onRadiusChanged: cubit.changeRadius,
              ),
              Expanded(
                child: _buildBody(context, state, cubit, theme, appColors),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    MosquesState state,
    MosquesCubit cubit,
    ThemeData theme,
    dynamic appColors,
  ) {
    if (state.status == MosquesStatus.loading) {
      return const MosquesSkeletonView();
    }

    if (state.status == MosquesStatus.error) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48.sp,
                color: theme.colorScheme.error,
              ),
              Gap(12.h),
              Text(
                state.errorMessage ?? 'no_mosques_found'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: appColors.textMuted,
                  fontSize: 13.sp,
                ),
              ),
              Gap(16.h),
              CustomButton(
                text: 'retry'.tr(),
                width: 140.w,
                height: 44.h,
                borderRadius: 12,
                fontSize: 13.sp,
                onPressed: () => cubit.loadNearbyMosques(),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isMapView) {
      return Stack(
        children: [
          MosquesMapView(
            userLatitude: state.userLatitude,
            userLongitude: state.userLongitude,
            mosques: state.mosques,
            selectedMosque: state.selectedMosque,
            onMosqueSelected: cubit.selectMosque,
          ),
          if (state.selectedMosque != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MosqueFloatingCard(
                mosque: state.selectedMosque!,
                onDirectionsPressed: () =>
                    cubit.launchDirections(state.selectedMosque!),
                onClose: () => cubit.selectMosque(state.selectedMosque!),
              ),
            ),
        ],
      );
    }

    return MosquesListView(
      mosques: state.mosques,
      selectedMosque: state.selectedMosque,
      onMosqueSelected: cubit.selectMosque,
      onDirections: cubit.launchDirections,
      onRefresh: cubit.loadNearbyMosques,
      onExpandRadius: () => cubit.changeRadius(5000.0),
    );
  }
}
