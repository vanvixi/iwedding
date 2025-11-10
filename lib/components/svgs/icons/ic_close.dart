import 'package:jaspr/jaspr.dart';

class IcClose extends StatelessComponent {
  const IcClose({
    super.key,
    this.size = 24,
    this.color = 'currentColor',
    this.strokeWidth = 32,
  });

  final double size;
  final String color;
  final double strokeWidth;

  @override
  Component build(BuildContext context) {
    return svg(
      viewBox: '0 0 512 512',
      attributes: {
        'stroke': color,
        'fill': color,
        'stroke-width': '0',
        'height': size.toString(),
        'width': size.toString(),
        'xmlns': 'http://www.w3.org/2000/svg',
      },
      [
        path(
          d: 'M368 368 144 144m224 0L144 368',
          attributes: {
            'fill': 'none',
            'stroke-linecap': 'round',
            'stroke-linejoin': 'round',
            'stroke-width': strokeWidth.toString(),
          },
          [],
        ),
      ],
    );
  }
}
