import 'package:jaspr/jaspr.dart';

class Spacer extends StatelessComponent {
  final double? width;
  final double? height;

  const Spacer({
    this.width,
    this.height,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(
        width: width != null ? Unit.pixels(width!) : null,
        height: height != null ? Unit.pixels(height!) : null,
      ),
      [],
    );
  }
}
