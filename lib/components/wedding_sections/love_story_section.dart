import 'package:jaspr/jaspr.dart';
import '../flex/flex_box.dart';
import '../flex/flex_section.dart';
import '../flex/flex_text.dart';
import '../flex/flex_photo.dart';
import '../flex/flex_date_header.dart';
import '../scroll_animated.dart';
import '../../consts/enums.dart';
import '../spacer.dart';

class LoveStorySection extends StatelessComponent {
  const LoveStorySection({super.key});

  @override
  Component build(BuildContext context) {
    return FlexSection(
      gap: 16,
      children: [
        ScrollAnimated(
          child: FlexText(
            content: text('About Us'),
            fontSize: 30,
            fontFamily: AppFonts.sacramento,
            fontWeight: FontWeight.w500,
            color: '#db9999',
            align: TextAlign.center,
          ),
        ),
        Spacer(height: 8),
        ScrollAnimated(
          child: FlexDateHeader(
            dateText: 'Lần đầu gặp gỡ | 06.10.2024',
            align: TextAlign.left,
          ),
        ),

        ScrollAnimated(
          child: FlexText(
            content: div(
              styles: Styles(
                padding: Padding.symmetric(horizontal: Unit.pixels(16)),
              ),
              [
                text('Ở độ tuổi đôi mươi, '),
                div([text('chúng ta luôn tin rằng sẽ có một người ')]),
                div([text('mang theo ánh sao đến bên mình. ')]),
                div([text('Cũng từng tự hỏi tình yêu là gì, ')]),
                div([text('nhưng chẳng thể diễn tả rõ ràng. ')]),
                div([text('Cho đến ngày gặp anh/em, em chợt nghĩ, ')]),
                div([text('có lẽ tình yêu là những buổi chiều bên nhau, ')]),
                div([text('ngồi trên ghế đá công viên, ')]),
                div([text('trò chuyện mãi không dứt. ')]),
                div([text('Đến khi hoàng hôn buông xuống, gió chiều trở nên dịu dàng, ')]),
                div([text("em nói: 'Hôm nay thật đẹp.' ")]),
                div([text("Anh mỉm cười: 'Mọi thứ đều thật đẹp.' 💫💕")]),
              ],
            ),
            fontSize: 14,
            fontFamily: AppFonts.quicksand,
            align: TextAlign.left,
            lineHeight: 1.39,
          ),
        ),

        ScrollAnimated(
          child: div(
            styles: Styles(
              position: Position.relative(),
              width: Unit.percent(100),
              padding: Padding.only(
                bottom: Unit.percent(62.33), // 240/385 = 62.33%
              ),
            ),
            [
              div(
                styles: Styles(
                  display: Display.flex,
                  position: Position.absolute(
                    top: Unit.pixels(0),
                    right: Unit.pixels(16),
                  ),
                  width: Unit.percent(79.2),
                  justifyContent: JustifyContent.end,
                ),
                [
                  FlexPhoto(
                    imageUrl: 'images/gallery-7.webp',
                    aspectRatio: '305/205',
                  ),

                  // Overlay text - positioned relative to photo
                  div(
                    styles: Styles(
                      position: Position.absolute(
                        bottom: Unit.pixels(-44),
                        left: Unit.percent(-16),
                      ),
                    ),
                    [
                      FlexText(
                        content: ScrollAnimated(
                          child: fragment([
                            text('I love you with'),
                            br(),
                            text('all my heart'),
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

        div(
          styles: Styles(
            position: Position.relative(),
            width: Unit.percent(100),
            padding: Padding.only(
              bottom: Unit.percent(71.17), // 274/385 = 71.17%
            ),
          ),
          [
            div(
              styles: Styles(
                position: Position.absolute(
                  top: Unit.pixels(-10),
                  left: Unit.pixels(0),
                ),
                width: Unit.percent(44.2),
              ),
              [
                ScrollAnimated(
                  direction: AnimationDirection.right,
                  child: FlexPhoto(
                    imageUrl: 'images/gallery-8.webp',
                    aspectRatio: '170/275',
                  ),
                ),
              ],
            ),
            div(
              styles: Styles(
                position: Position.absolute(
                  top: Unit.pixels(-40),
                  right: Unit.pixels(16),
                ),
                width: Unit.percent(48.8),
              ),
              [
                ScrollAnimated(
                  direction: AnimationDirection.left,
                  child: FlexPhoto(
                    imageUrl: 'images/gallery-9.webp',
                    aspectRatio: '188/252',
                  ),
                ),
              ],
            ),
          ],
        ),

        Spacer(height: 4),
        ScrollAnimated(
          child: FlexDateHeader(
            dateText: '14.02.2025 | Anh cầu hôn em',
            align: TextAlign.right,
          ),
        ),

        ScrollAnimated(
          child: FlexText(
            content: div(
              styles: Styles(
                padding: Padding.symmetric(horizontal: Unit.pixels(16)),
              ),
              [
                text('Em từng nghĩ, '),
                div([text('cầu hôn có lẽ là điều lãng mạn nhất trong những ngày bình dị. ')]),
                div([text('Bên bờ biển, dưới ánh bình minh, ')]),
                div([text('khoảnh khắc anh cầm bó hoa tiến về phía em, ')]),
                div([text('em chưa bao giờ cảm thấy hạnh phúc đến vậy. ')]),
                div([text('Chúng mình lặng lẽ đón gió biển, ')]),
                div([text('anh nhìn em bằng ánh mắt dịu dàng. ')]),
                div([text('Có lẽ, đây chính là tình yêu. ')]),
                div([text('Trong tình yêu, ')]),
                div([text('mọi vết thương rồi sẽ lành, mọi nỗi buồn cũng sẽ qua. ')]),
                div([text('Chỉ cần mở lòng, trên hành trình yêu thương, ')]),
                div([text('cùng anh đón ánh mặt trời.')]),
              ],
            ),
            fontSize: 14,
            fontFamily: AppFonts.quicksand,
            align: TextAlign.right,
            lineHeight: 1.39,
          ),
        ),
        Spacer(height: 4),
        div(
          styles: Styles(
            position: Position.relative(),
            width: Unit.percent(100),
            padding: Padding.only(
              left: Unit.pixels(16),
              right: Unit.pixels(16),
              bottom: Unit.percent(103.9), // 400/385 = 103.9%
            ),
          ),
          [
            div(
              styles: Styles(
                position: Position.absolute(
                  top: Unit.pixels(0),
                  left: Unit.pixels(0),
                ),
                width: Unit.percent(60.3),
              ),
              [
                ScrollAnimated(
                  child: FlexPhoto(
                    imageUrl: 'images/gallery-10.webp',
                    aspectRatio: '232/370',
                  ),
                ),
              ],
            ),
            div(
              styles: Styles(
                position: Position.absolute(
                  top: Unit.pixels(24),
                  right: Unit.pixels(0),
                ),
                width: Unit.percent(51),
              ),
              [
                ScrollAnimated(
                  direction: AnimationDirection.left,
                  child: FlexBox(
                    heightPercent: 51,
                    backgroundColor: '#ffffff',
                    padding: 10,
                    child: FlexPhoto(
                      imageUrl: 'images/gallery-11.webp',
                      aspectRatio: '178/270',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        Spacer(height: 4),
        ScrollAnimated(
          direction: AnimationDirection.left,
          child: FlexDateHeader(
            dateText: '29.05.2025 | Chúng mình bên nhau',
            align: TextAlign.right,
          ),
        ),

        ScrollAnimated(
          child: FlexText(
            content: div(
              styles: Styles(
                padding: Padding.symmetric(horizontal: Unit.pixels(16)),
              ),
              [
                p([text('Chuyến đi đầu tiên không có đích đến, ')]),
                p([text('vậy mà ta lại tìm thấy tình yêu. ')]),
                p([text('Em chụp phong cảnh, khen trời thu đẹp, ')]),
                p([text('anh chụp em, nói muốn lưu giữ điều tuyệt vời. ')]),
                p([text('Gió lướt qua núi đồi, mang theo niềm vui, ')]),
                p([text('tình yêu đến, chẳng sớm, chẳng muộn, ')]),
                p([text('vừa vặn dành cho chúng mình...')]),
              ],
            ),
            fontSize: 14,
            fontFamily: AppFonts.quicksand,
            align: TextAlign.right,
            lineHeight: 1.3,
          ),
        ),

        div(
          styles: Styles(
            position: Position.relative(),
            width: Unit.percent(100),
            padding: Padding.only(
              bottom: Unit.percent(77.92), // 300/385 = 77.92%
            ),
          ),
          [
            div(
              styles: Styles(
                position: Position.absolute(
                  top: Unit.pixels(0),
                  left: Unit.pixels(16),
                ),
                width: Unit.percent(45.2),
              ),
              [
                ScrollAnimated(
                  direction: AnimationDirection.right,
                  child: FlexPhoto(
                    imageUrl: 'images/gallery-12.webp',
                    aspectRatio: '174/249',
                  ),
                ),
              ],
            ),
            div(
              styles: Styles(
                position: Position.absolute(
                  top: Unit.pixels(50),
                  right: Unit.pixels(16),
                ),
                width: Unit.percent(44.4),
              ),
              [
                ScrollAnimated(
                  direction: AnimationDirection.left,
                  child: FlexPhoto(
                    imageUrl: 'images/gallery-13.webp',
                    aspectRatio: '171/245',
                  ),
                ),
              ],
            ),
          ],
        ),

        div(
          styles: Styles(
            position: Position.relative(),
            width: Unit.percent(100),
            padding: Padding.only(
              bottom: Unit.percent(62.34), // 240/385 = 62.34%
            ),
          ),
          [
            div(
              styles: Styles(
                position: Position.absolute(
                  top: Unit.pixels(-60),
                  left: Unit.pixels(16),
                ),
                width: Unit.percent(45.2),
              ),
              [
                ScrollAnimated(
                  direction: AnimationDirection.right,
                  child: FlexPhoto(
                    imageUrl: 'images/gallery-14.webp',
                    aspectRatio: '174/249',
                  ),
                ),
              ],
            ),
            div(
              styles: Styles(
                position: Position.absolute(
                  top: Unit.pixels(-12),
                  right: Unit.pixels(16),
                ),
                width: Unit.percent(44.4),
              ),
              [
                ScrollAnimated(
                  direction: AnimationDirection.left,
                  child: FlexPhoto(
                    imageUrl: 'images/gallery-15.webp',
                    aspectRatio: '171/245',
                  ),
                ),
              ],
            ),
          ],
        ),

        Spacer(height: 4),
        ScrollAnimated(
          child: FlexDateHeader(
            dateText: '16.11.2025 | Chúng mình đính hôn rồi!',
            align: TextAlign.center,
          ),
        ),

        ScrollAnimated(
          child: FlexText(
            content: fragment([
              text('Anh lắng nghe câu chuyện của em, '),
              div([text('em ghi nhớ sự dịu dàng của anh. ')]),
              div([text('Nắm tay nhau, từ cuốn sách nhỏ bìa trắng, ')]),
              div([text('đến những chuyến đi khắp thế gian, ')]),
              div([text('mỗi trang đều mang sắc màu riêng. ')]),
              div([text('Từ những ngày thơ trẻ đến khi trưởng thành, ')]),
              div([text('trên hành trình dài của thời gian, ')]),
              div([text('chúng mình cứ thế bên nhau, ')]),
              div([text('thật lâu, thật lâu..')]),
            ]),
            fontSize: 14,
            fontFamily: AppFonts.quicksand,
            align: TextAlign.center,
            lineHeight: 1.49,
          ),
        ),

        ScrollAnimated(
          child: div(
            styles: Styles(
              display: Display.flex,
              width: Unit.percent(80.5),
              margin: Margin.symmetric(horizontal: Unit.auto),
            ),
            [
              FlexPhoto(
                imageUrl: 'images/gallery-16.webp',
                aspectRatio: '1/1',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
