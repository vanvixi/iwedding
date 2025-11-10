import 'package:jaspr/jaspr.dart';

/// Flexible section container with vertical layout
class FlexSection extends StatelessComponent {
  const FlexSection({
    super.key,
    required this.children,
    this.gap = 20,
    this.paddingHorizontal = 0,
    this.paddingVertical = 0,
    this.align = AlignItems.stretch,
  });

  final List<Component> children;
  final double gap;
  final double paddingHorizontal;
  final double paddingVertical;
  final AlignItems align;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        display: Display.flex,
        width: Unit.percent(100),
        padding: Padding.symmetric(
          horizontal: Unit.pixels(paddingHorizontal),
          vertical: Unit.pixels(paddingVertical),
        ),
        flexDirection: FlexDirection.column,
        alignItems: align,
        gap: Gap.all(Unit.pixels(gap)),
      ),
      children,
    );
  }
}
