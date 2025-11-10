import 'package:jaspr/jaspr.dart';
import '../flex/flex_section.dart';
import '../flex/flex_text.dart';
import '../../consts/enums.dart';

class AddressSection extends StatelessComponent {
  const AddressSection({super.key});

  @override
  Component build(BuildContext context) {
    return FlexSection(
      gap: 8,
      paddingHorizontal: 16,
      children: [
        // Wedding Address Title
        FlexText(
          content: text('Địa Chỉ Hôn Lễ | WEDDING ADDRESS'),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: AppFonts.mallong,
          align: TextAlign.center,
        ),

        // Hotel Name
        FlexText(
          content: text('Tư Gia Nhà Trai'),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.mallong,
          align: TextAlign.center,
        ),

        // Map iframe
        iframe(
          styles: Styles(
            width: Unit.percent(100),
            height: Unit.pixels(300),
            padding: Padding.symmetric(horizontal: Unit.pixels(16)),
          ),
          src:
              'https://www.google.com/maps/embed?pb=!1m17!1m12!1m3!1d3730.1378037885515!2d106.10603377524988!3d20.785712180803504!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m2!1m1!2zMjDCsDQ3JzA4LjYiTiAxMDbCsDA2JzMxLjAiRQ!5e0!3m2!1svi!2s!4v1762451632241!5m2!1svi!2s',
          loading: MediaLoading.lazy,
          [],
        ),
      ],
    );
  }
}
