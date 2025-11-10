import 'package:jaspr/jaspr.dart';

class IcMenu extends StatelessComponent {
  const IcMenu({
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
          d: 'M88 152h336M88 256h336M88 360h336',
          attributes: {
            'fill': 'none',
            'stroke-linecap': 'round',
            'stroke-miterlimit': '10',
            'stroke-width': strokeWidth.toString(),
          },
          [],
        ),
      ],
    );
  }
}
