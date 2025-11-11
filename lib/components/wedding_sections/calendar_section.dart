import 'package:jaspr/jaspr.dart';
import '../../helper/calendar_helper.dart';
import '../flex/flex_section.dart';
import '../flex/flex_text.dart';
import '../../consts/enums.dart';
import '../spacer.dart';

class CalendarSection extends StatelessComponent {
  const CalendarSection({super.key});

  @override
  Component build(BuildContext context) {
    // Calendar configuration - November 2025, heart on day 16
    final calendar = CalendarData(
      year: 2025,
      month: 11,
      specialDay: 16,
    );

    return FlexSection(
      gap: 8,
      paddingHorizontal: 16,
      children: [
        Spacer(height: 4),
        // Wedding Time Header
        FlexText(
          content: text('Thời Gian Hôn Lễ | WEDDING TIME'),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: AppFonts.mallong,
          align: TextAlign.center,
        ),

        // Date and Time
        FlexText(
          content: fragment([
            text('Chủ Nhật, 16/11/2025 | 11:00 AM'),
            br(),
            text('Âm Lịch: 27/9/2025'),
          ]),
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: AppFonts.mallong,
          align: TextAlign.center,
        ),

        // Calendar Widget
        div(
          styles: Styles(
            margin: Margin.symmetric(horizontal: Unit.auto),
          ),
          [
            div(
              classes: 'calendar componentBOX',
              styles: Styles(
                width: Unit.percent(100),
                height: Unit.percent(100),
                radius: BorderRadius.all(Radius.circular(Unit.pixels(0))),
                color: Color.rgb(153, 153, 153),
                fontFamily: FontFamily('Arial'),
                fontSize: Unit.pixels(14),
              ),
              [
                div(classes: 'template-one', [
                  div(classes: 'one-back', []),
                  div(
                    classes: 'one-head',
                    styles: Styles(
                      backgroundColor: Color('#971726'),
                    ),
                    [
                      text(calendar.headerText),
                    ],
                  ),
                  div(classes: 'one-body', [
                    // Weekday headers
                    div(classes: 'body-week', [text('MON')]),
                    div(classes: 'body-week', [text('TUE')]),
                    div(classes: 'body-week', [text('WED')]),
                    div(classes: 'body-week', [text('THU')]),
                    div(classes: 'body-week', [text('FRI')]),
                    div(classes: 'body-week', [text('SAT')]),
                    div(classes: 'body-week', [text('SUN')]),

                    // Empty cells before first day
                    ...List.generate(
                      calendar.emptyBefore,
                      (i) => div(classes: 'empty', [div([])]),
                    ),

                    // Date cells
                    ...List.generate(
                      calendar.daysInMonth,
                      (i) {
                        final day = i + 1;
                        final isSpecialDay = day == calendar.specialDay;

                        return div(
                          classes: isSpecialDay ? 'colorF' : '',
                          styles: isSpecialDay
                              ? Styles(
                                  position: Position.relative(),
                                )
                              : null,
                          [
                            if (isSpecialDay)
                              img(
                                src: 'images/ic-heart-print.png',
                                alt: 'heart',
                                styles: Styles(
                                  position: Position.absolute(
                                    top: Unit.pixels(0),
                                    left: Unit.pixels(0),
                                  ),
                                  width: Unit.percent(100),
                                  height: Unit.percent(100),
                                  raw: {
                                    'object-fit': 'contain',
                                    'object-position': 'center',
                                    'z-index': '0',
                                  },
                                ),
                              ),
                            div(
                              styles: Styles(
                                position: Position.relative(),
                                raw: {
                                  'z-index': '1',
                                },
                              ),
                              [text('$day')],
                            ),
                          ],
                        );
                      },
                    ),
                  ]),
                ]),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
