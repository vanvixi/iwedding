import 'package:jaspr/jaspr.dart';
import 'package:wedding/components/scroll_animated.dart';
import '../flex/flex_box.dart';
import '../flex/flex_section.dart';
import '../flex/flex_text.dart';
import '../flex/flex_photo.dart';
import '../spacer.dart';
import '../../consts/enums.dart';

class StoryIntroSection extends StatelessComponent {
  const StoryIntroSection({super.key});

  @override
  Component build(BuildContext context) {
    return FlexSection(
      gap: 16,
      children: [
        ScrollAnimated(
          child: FlexText(
            content: fragment([
              text('Tiếp theo,'),
              br(),
              text('là câu chuyện tình yêu của chúng mình'),
              br(),
              text('...'),
            ]),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.playfairDisplay,
            color: '#443b37',
            align: TextAlign.center,
          ),
        ),

        ScrollAnimated(
          child: div(
            styles: Styles(
              position: Position.relative(),
              width: Unit.percent(100),
              padding: Padding.only(
                bottom: Unit.percent(120.78), // 465/385 = 120.78% - maintains aspect ratio of the layout
              ),
            ),
            [
              div(
                styles: Styles(
                  position: Position.absolute(
                    top: Unit.pixels(0),
                    left: Unit.pixels(0),
                  ),
                  width: Unit.percent(81.0),
                ),
                [
                  FlexPhoto(
                    imageUrl: 'images/gallery-3.webp',
                    aspectRatio: '312/422',
                  ),

                  // Overlay text - positioned relative to photo
                  div(
                    styles: Styles(
                      position: Position.absolute(
                        bottom: Unit.pixels(-50),
                        right: Unit.percent(-16),
                      ),
                    ),
                    [
                      FlexText(
                        content: ScrollAnimated(
                          child: fragment([
                            text('You are the one '),
                            div([text('I have ')]),
                            div([text('been looking for')]),
                          ]),
                        ),
                        fontSize: 27,
                        fontFamily: AppFonts.faugllinBalseyn,
                        fontWeight: FontWeight.w500,
                        color: '#9e0a0a',
                        align: TextAlign.left,
                        letterSpacing: 4,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Spacer(height: 1),
        ScrollAnimated(
          child: FlexText(
            content: fragment([
              text('Tình yêu đích thực không phải là khoảng cách, '),
              br(),
              text('mà là một lựa chọn. '),
              br(),
              text('Chúng mình chọn nắm lấy nhau, trân trọng nhau, '),
              br(),
              text('và cùng nhau gìn giữ. '),
              br(),
              text('Từ hôm nay, mãi mãi một lòng.'),
            ]),
            fontSize: 17,
            fontFamily: AppFonts.soulNoteDisplay,
            fontWeight: FontWeight.w500,
            align: TextAlign.center,
            lineHeight: 1.5,
          ),
        ),

        div(
          styles: Styles(
            position: Position.relative(),
            width: Unit.percent(100),
            padding: Padding.only(
              left: Unit.pixels(16),
              right: Unit.pixels(16),
              bottom: Unit.percent(140.25), // 540/385 = 140.25% - maintains aspect ratio of the layout
            ),
          ),
          [
            div(
              styles: Styles(
                position: Position.absolute(
                  top: Unit.pixels(0),
                  left: Unit.pixels(0),
                ),
                width: Unit.percent(70.1),
              ),
              [
                ScrollAnimated(
                  child: FlexPhoto(
                    imageUrl: 'images/gallery-2.webp',
                    aspectRatio: '270/364',
                  ),
                ),
              ],
            ),
            div(
              styles: Styles(
                position: Position.absolute(
                  bottom: Unit.pixels(50),
                  right: Unit.pixels(0),
                ),
                width: Unit.percent(55),
              ),
              [
                ScrollAnimated(
                  direction: AnimationDirection.left,
                  child: FlexBox(
                    heightPercent: 55,
                    backgroundColor: '#ffffff',
                    padding: 10,
                    child: FlexPhoto(
                      imageUrl: 'images/gallery-5.webp',
                      aspectRatio: '1/1',
                    ),
                  ),
                ),
              ],
            ),
            div(
              styles: Styles(
                position: Position.absolute(
                  bottom: Unit.pixels(0),
                  left: Unit.pixels(16),
                ),
                // width: Unit.percent(54.5),
              ),
              [
                ScrollAnimated(
                  child: FlexText(
                    content: fragment(
                      [
                        text('Giữa dòng người tấp nập,'),
                        br(),
                        text('chúng mình gặp nhau vào mùa hè,'),
                        br(),
                        text('chúng mình gặp nhau vào mùa hè,'),
                        br(),
                        text('hẹn ước vào mùa xuân,'),
                        br(),
                        text('và hôm nay, trong khoảnh khắc đẹp nhất,'),
                        br(),
                        text('chúng mình quyết định nắm tay nhau trọn đời.'),
                      ],
                    ),
                    fontSize: 15,
                    fontFamily: AppFonts.signora,
                    fontWeight: FontWeight.w500,
                    align: TextAlign.left,
                    lineHeight: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        Spacer(height: 1),
        ScrollAnimated(
          child: img(
            src: 'images/gallery-6.webp',
            styles: Styles(width: Unit.percent(100)),
          ),
        ),
      ],
    );
  }
}
