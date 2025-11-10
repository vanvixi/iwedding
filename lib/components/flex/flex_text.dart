import 'package:jaspr/jaspr.dart';

import '../../consts/enums.dart';

/// Simple text component with styling
///
/// Replaces deeply nested div structure with clean API
class FlexText extends StatelessComponent {
  const FlexText({
    super.key,
    required this.content,
    this.align = TextAlign.left,
    this.fontSize = 16,
    this.fontFamily = AppFonts.signora,
    this.fontWeight = FontWeight.w500,
    this.color = '#000000',
    this.lineHeight,
    this.letterSpacing = 0,
    this.position,
  });

  final Component content;
  final TextAlign align;
  final double fontSize;
  final AppFonts fontFamily;
  final FontWeight fontWeight;
  final String color;
  final double? lineHeight;
  final double letterSpacing;
  final Position? position;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        position: position,
        width: Unit.percent(100),
        color: Color(color),
        textAlign: align,
        fontFamily: FontFamily(fontFamily.value),
        fontSize: Unit.pixels(fontSize),
        fontWeight: fontWeight,
        letterSpacing: Unit.pixels(letterSpacing),
        raw: {
          if (lineHeight != null) 'line-height': lineHeight.toString(),
        },
      ),
      [content],
    );
  }
}
