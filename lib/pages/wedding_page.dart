import 'package:jaspr/jaspr.dart';
import '../components/audio_control.dart';
import '../components/mobile_frame.dart';
import '../components/wedding_sections/address_section.dart';
import '../components/wedding_sections/calendar_section.dart';
import '../components/wedding_sections/closing_section.dart';
import '../components/wedding_sections/header_section.dart';
import '../components/wedding_sections/love_story_section.dart';
import '../components/wedding_sections/story_intro_section.dart';
import '../components/blessing_list.dart';
import '../components/blessing_popup_container.dart';
import '../components/gift_popup_container.dart';
import '../components/toolbar.dart';
import '../components/toolbar_toggle_button.dart';
import '../helper/auto_scroll_helper.dart';
import '../helper/scroll_observer_helper.dart';

@client
class WeddingPage extends StatelessComponent {
  const WeddingPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'wedding-page',
      styles: Styles(
        backgroundColor: Color('#f0f2f5'),
        raw: {
          'width': '100dvw',
          'height': '100dvh',
          'padding-top': '5dvh',
        },
      ),
      [
        MobileFrame(
          children: [
            AudioControl(),
            _PageContainer(),
          ],
        ),
      ],
    );
  }
}

class _PageContainer extends StatefulComponent {
  const _PageContainer();

  @override
  State createState() => _PageContainerState();
}

class _PageContainerState extends State<_PageContainer> {
  late final AutoScrollHelper _autoScrollHelper;
  late final ScrollObserverHelper _scrollObserverHelper;

  @override
  void initState() {
    super.initState();
    _autoScrollHelper = AutoScrollHelper();
    _scrollObserverHelper = ScrollObserverHelper();
    _autoScrollHelper.initialize();
    _scrollObserverHelper.initialize();
  }

  @override
  void dispose() {
    _autoScrollHelper.dispose();
    _scrollObserverHelper.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return div(
      id: 'wedding-page-container',
      styles: Styles(
        overflow: Overflow.hidden,
      ),
      [
        div(
          classes: 'relative custom-scroll touch-action:auto',
          styles: Styles(
            display: Display.flex,
            height: Unit.percent(100),
            overflow: Overflow.only(x: Overflow.hidden, y: Overflow.auto),
            justifyContent: JustifyContent.center,
            backgroundColor: Color('#fff'),
          ),
          [
            div(
              id: 'wd-page-container-wrapper',
              styles: Styles(
                display: Display.flex,
                width: Unit.pixels(385),
                maxWidth: Unit.pixels(500),
                padding: Padding.only(bottom: Unit.pixels(80)),
                margin: Margin.all(Unit.auto),
                flexDirection: FlexDirection.column,
                gap: Gap.all(Unit.pixels(32)),
                backgroundColor: Color('#fff'),
              ),
              [
                // Header section
                HeaderSection(),

                // Story introduction section
                StoryIntroSection(),

                // Timeline with love story photos and quotes
                LoveStorySection(),

                // Time and calendar section
                CalendarSection(),

                // Address and venue info section
                AddressSection(),

                // Closing section with thank you message
                ClosingSection(),
              ],
            ),
          ],
        ),

        ToolbarToggleButton(),
        BlessingList(),
        Toolbar(),
        BlessingPopupContainer(),
        GiftPopupContainer(),
      ],
    );
  }
}
