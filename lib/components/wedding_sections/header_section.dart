import 'package:jaspr/jaspr.dart';
import '../flex/flex_section.dart';
import '../flex/flex_text.dart';
import '../spacer.dart';
import '../../consts/enums.dart';
import '../flex/flex_photo.dart';
import '../scroll_animated.dart';

class HeaderSection extends StatefulComponent {
  const HeaderSection({super.key});

  @override
  State createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  bool isShowContent = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () => setState(() => isShowContent = true));
    super.initState();
  }

  @override
  Component build(BuildContext context) {
    // Build wrapper classes with animation state
    final wrapperClasses = [
      'scroll-animated',
      'slide-up',
      if (isShowContent) 'is-visible',
    ].join(' ');

    return div(
      classes: wrapperClasses,
      styles: Styles(
        padding: Padding.symmetric(horizontal: Unit.pixels(16)),
      ),
      [
        FlexSection(
          gap: 16,
          children: [
            Spacer(height: 2),
            // 1. Save The Date
            FlexText(
              content: text('Save The Date｜Chúng mình kết hôn rồi!!!'),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.quicksand,
              align: TextAlign.left,
            ),

            // 2. Wedding Date
            FlexText(
              content: text('2025-11-16 11:00'),
              fontSize: 17,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.madamGhea,
              align: TextAlign.left,
            ),

            // 3. Greeting Message
            FlexText(
              content: fragment([
                text('/'),
                br(),
                text('Hi mọi ngườiii'),
                br(),
                text('Khi bạn nhận được tấm thiệp này,'),
                br(),
                text('là lúc ngày cưới của chúng mình đã gần'),
                br(),
                text('kề rồi đó'),
              ]),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.playfairDisplay,
              align: TextAlign.right,
            ),

            // 4. Welcome title (centered)
            FlexText(
              content: text('welcome to our wedding'),
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.faugllinBalseyn,
              color: '#545454',
              align: TextAlign.center,
            ),

            // 5. Hero Photo with overlay text
            div(
              styles: Styles(
                position: Position.relative(),
                width: Unit.percent(100),
                padding: Padding.only(
                  bottom: Unit.percent(118.18), // 455/385 = 118.18% - maintains aspect ratio of the layout
                ),
              ),
              [
                div(
                  styles: Styles(
                    position: Position.absolute(
                      top: Unit.pixels(0),
                      right: Unit.pixels(0),
                    ),
                    width: Unit.percent(71.4),
                  ),
                  [
                    FlexPhoto(
                      imageUrl: 'images/gallery-1.webp',
                      aspectRatio: '275/415',
                    ),

                    // 6. Romantic Quote - positioned relative to photo
                    div(
                      styles: Styles(
                        position: Position.absolute(
                          bottom: Unit.pixels(-50),
                          left: Unit.percent(-20),
                        ),
                      ),
                      [
                        FlexText(
                          content: fragment([
                            text('You make me'),
                            br(),
                            text('want to'),
                            br(),
                            text('be a better man'),
                          ]),
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                          fontFamily: AppFonts.faugllinBalseyn,
                          color: 'rgb(158, 10, 10)',
                          align: TextAlign.left,
                          letterSpacing: 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Spacer(height: 32),
        FlexText(
          content: fragment([
            text('Trước đây, chúng mình từng nghĩ rằng,'),
            br(),
            text('đám cưới chỉ là một thông báo chính thức.'),
            br(),
            text('Giờ mới hiểu, đó là một dịp hiếm hoi để tụ họp,'),
            br(),
            text('là sự vượt ngàn dặm để đến bên nhau,'),
            br(),
            text('là sự ủng hộ vô điều kiện đầy trân quý.'),
            br(),
            br(),
            text('Chúng mình trân trọng mời bạn và người thương đến chung vui trong ngày đặc biệt này! 💍✨'),
          ]),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.playfairDisplay,
          color: '#443b37',
          align: TextAlign.center,
          lineHeight: 1.6,
        ),
        Spacer(height: 32),
        _SongCard(),
      ],
    );
  }
}

class _SongCard extends StatelessComponent {
  const _SongCard();

  @override
  Component build(BuildContext context) {
    return ScrollAnimated(
      child: div(
        styles: Styles(
          display: Display.flex,
          width: Unit.percent(100),
          justifyContent: JustifyContent.center,
        ),
        [
          div(
            styles: Styles(
              display: Display.flex,
              width: Unit.percent(100),
              padding: Padding.all(Unit.pixels(16)),
              margin: Margin.symmetric(horizontal: Unit.pixels(16)),
              radius: BorderRadius.all(Radius.circular(Unit.pixels(10))),
              shadow: BoxShadow(
                offsetX: Unit.pixels(0),
                offsetY: Unit.pixels(0),
                blur: Unit.pixels(10),
                color: Color.rgba(0, 0, 0, 0.5),
              ),
              flexDirection: FlexDirection.row,
              justifyContent: JustifyContent.spaceBetween,
              alignItems: AlignItems.center,
              gap: Gap.all(Unit.pixels(12)),
              backgroundColor: Color('#ffffff'),
            ),
            [
              // Left: Song info
              div(
                styles: Styles(
                  display: Display.flex,
                  flexDirection: FlexDirection.column,
                  gap: Gap.all(Unit.pixels(4)),
                  flex: const Flex(grow: 1),
                ),
                [
                  FlexText(
                    content: text('A Thousand Years - Christina Perri'),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.signora,
                    align: TextAlign.left,
                  ),
                  FlexText(
                    content: text('Now playing a song for you ...'),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.signora,
                    align: TextAlign.left,
                  ),
                ],
              ),
              // Right: Album cover
              FlexPhoto(
                imageUrl: 'images/gallery-2.webp',
                width: 63,
                aspectRatio: '1/1',
                borderRadius: '5px',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
