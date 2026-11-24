import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import '../../utils/extensions.dart';

/// Four Ottoman manuscript corner brackets overlaid inside featured cards.
class ManuscriptCorners extends StatelessWidget {
  final Color? color;
  final double inset;
  final double length;

  const ManuscriptCorners({
    super.key,
    this.color,
    this.inset = 10,
    this.length = 14,
  });

  @override
  Widget build(BuildContext context) {
    final c = (color ?? context.appColors.accentGold).withValues(alpha: 0.55);
    final pad = inset.r;
    final len = length.w;

    return Positioned.fill(
      child: IgnorePointer(
        child: Padding(
          padding: EdgeInsets.all(pad),
          child: Stack(
            children: [
              _corner(Alignment.topLeft, c, len, top: true, left: true),
              _corner(Alignment.topRight, c, len, top: true, right: true),
              _corner(Alignment.bottomLeft, c, len, bottom: true, left: true),
              _corner(Alignment.bottomRight, c, len, bottom: true, right: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _corner(
    Alignment alignment,
    Color c,
    double len, {
    bool top = false,
    bool bottom = false,
    bool left = false,
    bool right = false,
  }) {
    final side = BorderSide(color: c, width: 1.5);
    return Align(
      alignment: alignment,
      child: Container(
        width: len,
        height: len,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: top && left ? Radius.circular(4.r) : Radius.zero,
            topRight: top && right ? Radius.circular(4.r) : Radius.zero,
            bottomLeft: bottom && left ? Radius.circular(4.r) : Radius.zero,
            bottomRight: bottom && right ? Radius.circular(4.r) : Radius.zero,
          ),
          border: Border(
            top: top ? side : BorderSide.none,
            bottom: bottom ? side : BorderSide.none,
            left: left ? side : BorderSide.none,
            right: right ? side : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
