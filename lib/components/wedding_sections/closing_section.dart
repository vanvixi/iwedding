import 'package:jaspr/jaspr.dart';
import 'package:wedding/components/spacer.dart';
import '../flex/flex_section.dart';
import '../flex/flex_text.dart';
import '../../consts/enums.dart';
import '../flex/flex_photo.dart';
import '../scroll_animated.dart';

class ClosingSection extends StatelessComponent {
  const ClosingSection({super.key});

  @override
  Component build(BuildContext context) {
    return FlexSection(
      gap: 16,
      paddingHorizontal: 16,
      children: [
        Spacer(height: 4),
        // Heart icon decoration
        ScrollAnimated(
          child: div(
            styles: Styles(
              width: Unit.pixels(62),
              height: Unit.pixels(86),
              margin: Margin.symmetric(horizontal: Unit.auto),
              backgroundImage: ImageStyle.url('images/ic-couple-chibi.png'),
              backgroundPosition: BackgroundPosition.center,
              backgroundRepeat: BackgroundRepeat.noRepeat,
              backgroundSize: BackgroundSize.contain,
            ),
            [],
          ),
        ),

        // Invitation message
        ScrollAnimated(
          child: FlexText(
            content: fragment([
              text('Chúng mình chân thành mời những người thân yêu,'),
              br(),
              text('những người bạn tốt nhất,'),
              br(),
              text('và những gia đình thân thiết'),
              br(),
              text('đến tham dự lễ cưới của chúng mình.'),
              br(),
              br(),
              text('Sự hiện diện của bạn là món quà quý giá nhất! 🎁'),
            ]),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.playfairDisplay,
            color: '#443b37',
            align: TextAlign.center,
            lineHeight: 1.6,
          ),
        ),

        ScrollAnimated(
          child: div(
            styles: Styles(
              display: Display.flex,
              width: Unit.percent(90),
              margin: Margin.symmetric(horizontal: Unit.auto),
            ),
            [
              FlexPhoto(
                imageUrl: 'images/gallery-17.webp',
                aspectRatio: '1/1',
              ),
            ],
          ),
        ),

        Spacer(height: 32),
        // Thank you message
        ScrollAnimated(
          child: FlexText(
            content: text('Thank you!'),
            fontSize: 40,
            fontWeight: FontWeight.normal,
            fontFamily: AppFonts.kattyDiona,
            color: '#db9999',
            align: TextAlign.center,
          ),
        ),
        Spacer(height: 32),
      ],
    );
  }
}
