import 'dart:async';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;
import 'package:wedding/models/blessing.dart';
import 'package:wedding/services/blessing_service.dart';

@client
class BlessingList extends StatefulComponent {
  const BlessingList({super.key, this.limit = 10});

  final int limit;

  @override
  State<BlessingList> createState() => _BlessingListState();
}

class _BlessingListState extends State<BlessingList> {
  final BlessingService _blessingService = BlessingService();
  List<Blessing> _blessings = [];
  StreamSubscription<List<Blessing>>? _blessingsSubscription;

  final String _containerId = 'blessing-list-container-${DateTime.now().millisecondsSinceEpoch}';

  bool _isInitialScrollSet = false;
  bool _animating = false;
  num? _lastTimestamp;
  static const double _kSpeedPixelsPerSecond = 40.0;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    _startListeningToBlessings();
  }

  @override
  void dispose() {
    _stopAnimation();
    _blessingsSubscription?.cancel();
    _fallbackTimer?.cancel();
    super.dispose();
  }

  void _startListeningToBlessings() {
    _blessingsSubscription = _blessingService.getBlessingsStream(limit: component.limit).listen((blessings) {
      setState(() {
        _blessings = blessings;
        // reset initial state when list changes
        _isInitialScrollSet = false;
      });

      // Small delay to let Jaspr render DOM nodes
      Future.delayed(const Duration(milliseconds: 50), () async {
        // Try to set initial pos; if success and content is scrollable, start anim
        final ready = await _waitForContainerReady(timeoutMs: 2000);
        if (!ready) {
          return;
        }
        _setInitialScrollPosition();
        _startAnimation();
      });
    });
  }

  /// Wait until the container exists and its scrollHeight > clientHeight or timeout
  Future<bool> _waitForContainerReady({int timeoutMs = 2000}) async {
    final int interval = 50;
    int waited = 0;
    while (waited < timeoutMs) {
      final container = web.document.getElementById(_containerId);
      if (container != null) {
        final sh = container.scrollHeight;
        final ch = container.clientHeight;
        if (sh > ch) return true;
      }
      await Future.delayed(Duration(milliseconds: interval));
      waited += interval;
    }
    return false;
  }

  void _setInitialScrollPosition() {
    if (_isInitialScrollSet) return;
    final container = web.document.getElementById(_containerId);
    if (container == null) return;

    final scrollHeight = container.scrollHeight;
    final clientHeight = container.clientHeight;

    if (scrollHeight <= clientHeight) {
      // nothing to scroll
      return;
    }

    final oneSetHeight = scrollHeight / 3.0;
    // Put initial scrollTop at middle set, preserving remainder if any.
    container.scrollTop = oneSetHeight;
    _isInitialScrollSet = true;
  }

  void _startAnimation() {
    if (_animating) return;
    final container = web.document.getElementById(_containerId);
    if (container == null) {
      // shouldn't happen because we waited, but be safe
      return;
    }

    final scrollHeight = container.scrollHeight;
    final clientHeight = container.clientHeight;
    if (scrollHeight <= clientHeight) {
      // nothing to scroll
      return;
    }

    _animating = true;
    _lastTimestamp = null;
    // Start RAF loop; cast when passing callback to avoid assignment/cast issues elsewhere.
    try {
      // ignore: invalid_runtime_check_with_js_interop_types
      web.window.requestAnimationFrame(_animationFrame as web.FrameRequestCallback);
      // Setup a fallback: if RAF doesn't run within 300ms, use Timer fallback
      Future.delayed(Duration(milliseconds: 300), () {
        if (!_animating) return;
        // If lastTimestamp still null after RAF scheduled, fallback
        if (_lastTimestamp == null) {
          _startFallbackTimer();
        }
      });
    } catch (e) {
      // if requestAnimationFrame call itself throws, start fallback
      _startFallbackTimer();
    }
  }

  void _stopAnimation() {
    _animating = false;
    _lastTimestamp = null;
    _fallbackTimer?.cancel();
    _fallbackTimer = null;
  }

  void _startFallbackTimer() {
    // if RAF is not available or not invoking, use a Timer with 60fps-ish period
    _fallbackTimer?.cancel();
    _fallbackTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!_animating) return;
      _fallbackStep(16);
    });
  }

  void _fallbackStep(int deltaMsInt) {
    final container = web.document.getElementById(_containerId);
    if (container == null) {
      _stopAnimation();
      return;
    }

    final dy = _kSpeedPixelsPerSecond * (deltaMsInt / 1000.0);
    container.scrollTop = container.scrollTop + dy;

    final scrollHeight = container.scrollHeight;
    final oneSetHeight = scrollHeight / 3.0;

    if (container.scrollTop >= oneSetHeight * 2.0) {
      container.scrollTop = container.scrollTop - oneSetHeight;
    } else if (container.scrollTop <= 0.0) {
      container.scrollTop = container.scrollTop + oneSetHeight;
    }
  }

  void _animationFrame(num timestamp) {
    if (!_animating) return;

    final container = web.document.getElementById(_containerId);
    if (container == null) {
      _stopAnimation();
      return;
    }

    _lastTimestamp ??= timestamp;
    final deltaMs = (timestamp - _lastTimestamp!).toDouble();
    _lastTimestamp = timestamp;

    if (deltaMs <= 0) {
      // schedule next
      // ignore: invalid_runtime_check_with_js_interop_types
      web.window.requestAnimationFrame(_animationFrame as web.FrameRequestCallback);
      return;
    }

    final dy = _kSpeedPixelsPerSecond * (deltaMs / 1000.0);
    container.scrollTop = container.scrollTop + dy;

    final scrollHeight = container.scrollHeight;
    final oneSetHeight = scrollHeight / 3.0;

    if (container.scrollTop >= oneSetHeight * 2.0) {
      // preserve remainder by subtracting exactly oneSetHeight
      container.scrollTop = container.scrollTop - oneSetHeight;
    } else if (container.scrollTop <= 0.0) {
      container.scrollTop = container.scrollTop + oneSetHeight;
    }

    // schedule next
    // ignore: invalid_runtime_check_with_js_interop_types
    web.window.requestAnimationFrame(_animationFrame as web.FrameRequestCallback);
  }

  @override
  Component build(BuildContext context) {
    if (_blessings.isEmpty) {
      return div([]);
    }

    // Duplicate list 3 times: [Group 0, Group 1 (middle), Group 2]
    final duplicatedBlessings = [
      ..._blessings,
      ..._blessings,
      ..._blessings,
    ];

    return div(
      id: _containerId,
      classes: 'blessing-list-container',
      styles: Styles(
        position: Position.fixed(
          left: Unit.percent(50),
          bottom: Unit.expression('calc(5vh + 56px)'),
        ),
        zIndex: ZIndex(1001),
        width: Unit.pixels(285),
        height: Unit.pixels(180),
        overflow: Overflow.auto,
        pointerEvents: PointerEvents.none,
        transform: Transform.translate(x: Unit.pixels(-192.5 + 12)),
        raw: {
          'scrollbar-width': 'none',
          '-ms-overflow-style': 'none',
        },
      ),
      [
        for (var blessing in duplicatedBlessings)
          div(
            styles: Styles(
              display: Display.flex,
              position: Position.relative(),
              width: Unit.fitContent,
              minHeight: Unit.pixels(28),
              maxWidth: Unit.percent(100),
              padding: Padding.symmetric(horizontal: Unit.pixels(10), vertical: Unit.pixels(2)),
              margin: Margin.symmetric(vertical: Unit.pixels(3)),
              border: Border.none,
              radius: BorderRadius.circular(Unit.pixels(7)),
              userSelect: UserSelect.none,
              transition: Transition('opacity', duration: 0.5, curve: Curve.easeInOut),
              justifyContent: JustifyContent.start,
              alignItems: AlignItems.center,
              color: Color.rgba(255, 255, 255, 1),
              textAlign: TextAlign.left,
              fontSize: Unit.pixels(12),
              lineHeight: Unit.pixels(14),
              whiteSpace: WhiteSpace.noWrap,
              backgroundColor: Color.rgba(225, 117, 117, 0.5),
              raw: {'-webkit-tap-highlight-color': 'transparent'},
            ),
            [
              strong([text(blessing.name)]),
              text(': ${blessing.message}'),
            ],
          ),
      ],
    );
  }
}
