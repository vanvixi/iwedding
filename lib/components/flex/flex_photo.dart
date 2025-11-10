import 'package:jaspr/jaspr.dart';

/// Photo component with Flexbox layout
class FlexPhoto extends StatelessComponent {
  const FlexPhoto({
    super.key,
    required this.imageUrl,
    this.width,
    this.widthPercent,
    this.height,
    this.aspectRatio,
    this.borderRadius = '0px',
  });

  final String imageUrl;
  final double? width;
  final double? widthPercent;
  final double? height;
  final String? aspectRatio;
  final String borderRadius;

  @override
  Component build(BuildContext context) {
    // Parse aspectRatio string (e.g., "3/4" -> AspectRatio(3, 4))
    AspectRatio? parsedAspectRatio;
    if (aspectRatio != null) {
      final parts = aspectRatio!.split('/');
      if (parts.length == 2) {
        final num = int.tryParse(parts[0]);
        final denom = int.tryParse(parts[1]);
        if (num != null && denom != null) {
          parsedAspectRatio = AspectRatio(num, denom);
        }
      }
    }

    // Parse borderRadius string (e.g., "5px" -> 5.0)
    final radiusValue = double.tryParse(borderRadius.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

    // Determine width unit (prefer widthPercent over width)
    Unit? widthUnit;
    if (widthPercent != null) {
      widthUnit = Unit.percent(widthPercent!);
    } else if (width != null) {
      widthUnit = Unit.pixels(width!);
    } else {
      widthUnit = Unit.percent(100);
    }

    return div(
      styles: Styles(
        // Box Styles
        position: Position.relative(),
        width: widthUnit,
        height: height != null ? Unit.pixels(height!) : null,
        aspectRatio: parsedAspectRatio,
        radius: radiusValue > 0 ? BorderRadius.all(Radius.circular(Unit.pixels(radiusValue))) : null,
        overflow: Overflow.hidden,
      ),
      [
        div(
          classes: 'photo-component',
          styles: Styles(
            raw: {
              '-webkit-mask-box-image-source': 'none',
              '-webkit-mask-box-image-slice': '0 fill',
              'mask-image': 'none',
              'mask-size': '100% 100%',
              'mask-repeat': 'no-repeat',
            },
          ),
          [
            div(
              classes: 'photo-bg-wrap',
              styles: Styles(
                // Background Styles
                radius: radiusValue > 0 ? BorderRadius.all(Radius.circular(Unit.pixels(radiusValue))) : null,
                backgroundImage: ImageStyle.url(imageUrl),
              ),
              [],
            ),
          ],
        ),
      ],
    );
  }
}
