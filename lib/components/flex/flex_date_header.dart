import 'package:jaspr/jaspr.dart';
import 'package:wedding/consts/enums.dart';

/// Date header component for timeline events
///
/// Shows date with optional heart decoration and alignment
class FlexDateHeader extends StatelessComponent {
  const FlexDateHeader({
    super.key,
    required this.dateText,
    this.align = TextAlign.left,
    this.showHeart = true,
    this.fontSize = 23,
  });

  final String dateText;
  final TextAlign align;
  final bool showHeart;
  final double fontSize;

  @override
  Component build(BuildContext context) {
    final justifyContent = align == TextAlign.left
        ? JustifyContent.start
        : align == TextAlign.center
        ? JustifyContent.center
        : JustifyContent.end;

    return div(
      styles: Styles(
        display: Display.flex,
        width: Unit.percent(100),
        flexDirection: FlexDirection.row,
        justifyContent: justifyContent,
        alignItems: AlignItems.end,
      ),
      [
        if (showHeart && align == TextAlign.left)
          div(
            styles: Styles(
              position: Position.absolute(bottom: Unit.pixels(0)),
              width: Unit.pixels(48),
              height: Unit.pixels(56),
              transform: Transform.rotate(Angle.deg(-22)),
              backgroundImage: ImageStyle.url('images/ic-multi-heart.png'),
              backgroundPosition: BackgroundPosition.center,
              backgroundRepeat: BackgroundRepeat.noRepeat,
              backgroundSize: BackgroundSize.contain,
            ),
            [],
          ),
        div(
          styles: Styles(
            position: showHeart
                ? Position.absolute(
                    bottom: Unit.pixels(-8),
                    left: align == TextAlign.left ? Unit.pixels(44) : null,
                    right: align == TextAlign.right ? Unit.pixels(44) : null,
                  )
                : null,
            color: Color('#db9999'),
            fontFamily: FontFamily(AppFonts.signora.value),
            fontSize: Unit.pixels(fontSize),
            fontWeight: FontWeight.w500,
          ),
          [
            text(dateText),
          ],
        ),
        if (showHeart && align == TextAlign.right)
          div(
            styles: Styles(
              position: Position.absolute(bottom: Unit.pixels(0)),
              width: Unit.pixels(48),
              height: Unit.pixels(56),
              transform: Transform.rotate(Angle.deg(-22)),
              backgroundImage: ImageStyle.url('images/ic-multi-heart.png'),
              backgroundPosition: BackgroundPosition.center,
              backgroundRepeat: BackgroundRepeat.noRepeat,
              backgroundSize: BackgroundSize.contain,
            ),
            [],
          ),
      ],
    );
  }
}
