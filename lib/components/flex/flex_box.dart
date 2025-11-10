import 'package:jaspr/jaspr.dart';

/// Simple box component with optional styling
///
/// Use for decorative elements, backgrounds, borders, etc.
class FlexBox extends StatelessComponent {
  const FlexBox({
    super.key,
    this.child,
    this.width,
    this.widthPercent,
    this.height,
    this.heightPercent,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });

  final Component? child;
  final double? width;
  final double? widthPercent;
  final double? height;
  final double? heightPercent;
  final double? padding;
  final String? backgroundColor;
  final String? borderRadius;
  final String? border;
  final String? boxShadow;

  @override
  Component build(BuildContext context) {
    // Parse borderRadius if provided (e.g., "8px" -> 8.0)
    BorderRadius? parsedRadius;
    if (borderRadius != null) {
      final radiusValue = double.tryParse(borderRadius!.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      if (radiusValue > 0) {
        parsedRadius = BorderRadius.all(Radius.circular(Unit.pixels(radiusValue)));
      }
    }

    // Determine width and height units
    Unit? widthUnit;
    if (widthPercent != null) {
      widthUnit = Unit.percent(widthPercent!);
    } else if (width != null) {
      widthUnit = Unit.pixels(width!);
    }

    Unit? heightUnit;
    if (heightPercent != null) {
      heightUnit = Unit.percent(heightPercent!);
    } else if (height != null) {
      heightUnit = Unit.pixels(height!);
    }

    return div(
      styles: Styles(
        width: widthUnit,
        height: heightUnit,
        padding: padding != null ? Padding.all(Unit.pixels(padding!)) : null,
        radius: parsedRadius,
        backgroundColor: backgroundColor != null ? Color(backgroundColor!) : null,
        raw: {
          if (border != null) 'border': border!,
          if (boxShadow != null) 'box-shadow': boxShadow!,
        },
      ),
      child != null ? [child!] : [],
    );
  }
}
