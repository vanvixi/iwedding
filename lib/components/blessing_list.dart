import 'dart:async';
import 'dart:js_interop';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;
import 'package:wedding/models/blessing.dart';
import 'package:wedding/services/blessing_service.dart';

@client
class BlessingList extends StatefulComponent {
  const BlessingList({super.key});

  @override
  State<BlessingList> createState() => _BlessingListState();
}

class _BlessingListState extends State<BlessingList> {
  static const int _kTickMs = 16;
  static const double _kSpeedPixelsPerSecond = 40.0;
  static const String _containerId = 'blessing-list-container';
  static const String _contentId = 'blessing-list-content';

  List<Blessing> _blessings = [];
  final BlessingService _blessingService = BlessingService();

  double _offset = 0.0;
  Timer? _timer;
  bool _animating = true;

  @override
  void initState() {
    super.initState();
    _blessingService.getBlessingsStream().listen((blessings) {
      setState(() => _blessings = blessings);

      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: _kTickMs), (_) {
      if (!_animating) return;
      final container = web.document.getElementById(_containerId);
      final content = web.document.getElementById(_contentId) as web.HTMLDivElement?;
      if (container == null || content == null) return;

      final delta = _kSpeedPixelsPerSecond * (_kTickMs / 1000);
      _offset += delta;

      final totalHeight = content.scrollHeight / 3;

      if (_offset >= totalHeight) _offset -= totalHeight;

      content.style.transform = 'translateY(-${_offset}px)';
    });

    final container = web.document.getElementById(_containerId);
    if (container != null) {
      container.addEventListener(
        'pointerdown',
        ((web.Event _) => _animating = false).toJS,
      );

      container.addEventListener(
        'pointerup',
        ((web.Event _) => _animating = true).toJS,
      );

      container.addEventListener(
        'pointercancel',
        ((web.Event _) => _animating = true).toJS,
      );
    }
  }

  @override
  Component build(BuildContext context) {
    if (_blessings.isEmpty) return div([]);

    final duplicated = [..._blessings, ..._blessings, ..._blessings];

    return div(
      id: _containerId,
      classes: 'blessing-list-container',
      styles: Styles(
        position: Position.absolute(
          left: Unit.pixels(12),
          bottom: Unit.expression('calc(5vh + 12px)'),
        ),
        zIndex: ZIndex(11),
        width: Unit.percent(70),
        height: Unit.pixels(150),
        overflow: Overflow.auto,
        raw: {
          'scrollbar-width': 'none',
          '-ms-overflow-style': 'none',
          'overscroll-behavior': 'contain',
          '-webkit-overflow-scrolling': 'touch',
        },
      ),
      [
        div(
          id: _contentId,
          styles: Styles(
            width: Unit.percent(100),
          ),
          [
            for (var blessing in duplicated)
              div(
                styles: Styles(
                  display: Display.block,
                  position: Position.relative(),
                  width: Unit.fitContent,
                  minHeight: Unit.pixels(28),
                  maxWidth: Unit.percent(100),
                  padding: Padding.symmetric(horizontal: Unit.pixels(10), vertical: Unit.pixels(6)),
                  margin: Margin.symmetric(vertical: Unit.pixels(3)),
                  border: Border.none,
                  radius: BorderRadius.circular(Unit.pixels(7)),
                  userSelect: UserSelect.none,
                  transition: Transition('opacity', duration: 0.5),
                  color: Color.rgba(255, 255, 255, 1),
                  textAlign: TextAlign.left,
                  fontSize: Unit.pixels(12),
                  lineHeight: Unit.pixels(16),
                  backgroundColor: Color.rgba(225, 117, 117, 0.5),
                  raw: {'-webkit-tap-highlight-color': 'transparent'},
                ),
                [
                  strong([text(blessing.name)]),
                  text(': ${blessing.message}'),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
