import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/features/mosques/domain/entities/mosque.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';


import 'mosque_marker_widget.dart';

class MosquesMapView extends StatefulWidget {
  final double userLatitude;
  final double userLongitude;
  final List<Mosque> mosques;
  final Mosque? selectedMosque;
  final ValueChanged<Mosque> onMosqueSelected;

  const MosquesMapView({
    super.key,
    required this.userLatitude,
    required this.userLongitude,
    required this.mosques,
    required this.selectedMosque,
    required this.onMosqueSelected,
  });

  @override
  State<MosquesMapView> createState() => _MosquesMapViewState();
}

class _MosquesMapViewState extends State<MosquesMapView> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(covariant MosquesMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMosque != null &&
        widget.selectedMosque != oldWidget.selectedMosque) {
      _mapController.move(
        LatLng(
          widget.selectedMosque!.latitude,
          widget.selectedMosque!.longitude,
        ),
        15.5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final userPos = LatLng(widget.userLatitude, widget.userLongitude);

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: userPos,
            initialZoom: 15.0,
            minZoom: 10.0,
            maxZoom: 18.0,
          ),
          children: [
            TileLayer(
              urlTemplate: appColors.mapTileUrl,
              userAgentPackageName: 'com.zad.almuslim',
              maxZoom: 19,
              tileBuilder: (context, tileWidget, tile) {
                final filter = appColors.mapColorFilter;
                if (filter != null) {
                  return ColorFiltered(
                    colorFilter: filter,
                    child: tileWidget,
                  );
                }
                return tileWidget;
              },
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: userPos,
                  width: 22.r,
                  height: 22.r,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                ...widget.mosques.map((m) {
                  final isSelected = widget.selectedMosque?.id == m.id;
                  return Marker(
                    point: LatLng(m.latitude, m.longitude),
                    width: 44.r,
                    height: 52.r,
                    child: MosqueMarkerWidget(
                      mosque: m,
                      isSelected: isSelected,
                      onTap: () => widget.onMosqueSelected(m),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
        Positioned(
          top: 12.h,
          right: 16.w,
          child: Column(
            children: [
              _buildMapControlBtn(
                icon: Icons.my_location_rounded,
                onTap: () {
                  AppHaptics.light();
                  _mapController.move(userPos, 15.0);
                },
              ),
              SizedBox(height: 8.h),
              _buildMapControlBtn(
                icon: Icons.add_rounded,
                onTap: () {
                  AppHaptics.light();
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  );
                },
              ),
              SizedBox(height: 8.h),
              _buildMapControlBtn(
                icon: Icons.remove_rounded,
                onTap: () {
                  AppHaptics.light();
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapControlBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Icon(icon, size: 20.sp, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}
