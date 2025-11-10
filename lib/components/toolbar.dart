import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;

/// Toolbar at bottom of wedding page with message and gift buttons
@client
class Toolbar extends StatelessComponent {
  const Toolbar({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      id: 'wedding-toolbar',
      styles: Styles(
        position: Position.fixed(
          left: Unit.percent(50),
          bottom: Unit.vh(5),
        ),
        zIndex: ZIndex(9999998), // Above popup backdrop (9999997) but below popup content (9999999)
        width: Unit.percent(100),
        height: Unit.pixels(64),
        maxWidth: Unit.pixels(385),
        boxSizing: BoxSizing.borderBox,
      ),
      [
        div(
          styles: Styles(
            display: Display.flex,
            position: Position.relative(),
            width: Unit.percent(100),
            height: Unit.percent(100),
            padding: Padding.all(Unit.pixels(8)),
            justifyContent: JustifyContent.spaceBetween,
            alignItems: AlignItems.center,
          ),
          [
            div(
              styles: Styles(
                display: Display.flex,
                width: Unit.pixels(150),
                height: Unit.pixels(35),
                padding: Padding.only(left: Unit.pixels(16), right: Unit.pixels(8)),
                boxSizing: BoxSizing.borderBox,
                radius: BorderRadius.circular(Unit.pixels(30)),
                justifyContent: JustifyContent.spaceBetween,
                alignItems: AlignItems.center,
                color: Color('#ffffff'),
                fontSize: Unit.pixels(13),
                lineHeight: Unit.pixels(39),
                backgroundColor: Color.rgba(0, 0, 0, 0.2),
              ),
              events: {
                'click': (event) {
                  // Dispatch custom event to show blessing popup
                  web.window.dispatchEvent(web.CustomEvent('show-blessing-popup'));
                },
              },
              [
                span(
                  styles: Styles(
                    display: Display.inlineBlock,
                    width: Unit.expression('calc(100% - 30px)'),
                  ),
                  [text('Gửi lời chúc...')],
                ),
                img(
                  src: 'images/ic-message.png',
                  styles: Styles(
                    height: Unit.pixels(24),
                    raw: {'vertical-align': 'middle'},
                  ),
                ),
              ],
            ),

            div(
              styles: Styles(display: Display.flex, gap: Gap.all(Unit.pixels(12))),
              [
                div(
                  events: {
                    'click': (event) {
                      // Dispatch custom event to show gift popup
                      web.window.dispatchEvent(web.CustomEvent('show-gift-popup'));
                    },
                  },
                  styles: Styles(
                    width: Unit.pixels(35),
                    height: Unit.pixels(35),
                    cursor: Cursor.pointer,
                    backgroundImage: ImageStyle.url('images/ic-gift-box.png'),
                    backgroundRepeat: BackgroundRepeat.noRepeat,
                    backgroundSize: BackgroundSize.contain,
                    raw: {
                      'animation': 'bounceGift 6s ease infinite',
                      '-webkit-animation': 'bounceGift 6s ease infinite',
                    },
                  ),
                  [],
                ),
                // div(
                //   styles: Styles(
                //     width: Unit.pixels(35),
                //     height: Unit.pixels(35),
                //     cursor: Cursor.pointer,
                //     backgroundImage: ImageStyle.url('images/ic-like.png'),
                //     backgroundRepeat: BackgroundRepeat.noRepeat,
                //     backgroundSize: BackgroundSize.contain,
                //   ),
                //   [],
                // ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
