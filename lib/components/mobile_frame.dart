import 'package:jaspr/jaspr.dart';

/// Mobile phone frame wrapper component
class MobileFrame extends StatelessComponent {
  const MobileFrame({
    super.key,
    required this.children,
  });

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'mobile-frame',
      styles: Styles(
        position: Position.relative(),
        width: Unit.pixels(385),
        height: Unit.vh(90),
        minWidth: Unit.pixels(385),
        margin: Margin.all(Unit.auto),
        border: Border(width: Unit.pixels(1), color: Color('#e0e0e0')),
        radius: BorderRadius.circular(Unit.pixels(4)),
        overflow: Overflow.hidden,
        shadow: BoxShadow(
          offsetX: Unit.pixels(0),
          offsetY: Unit.pixels(0),
          blur: Unit.pixels(10),
          color: Color.rgba(0, 0, 0, 0.1),
        ),
        raw: {'flex-shrink': '0'},
      ),
      children,
    );
  }
}
