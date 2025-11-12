import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart';

/// Auto Scroll Helper
///
/// Automatically scrolls the page slowly after initial delay
/// Supports both window scroll and container scroll (for mobile frames)
final class AutoScrollHelper {
  // --- Configuration ---
  static const int _kInitialDelay = 3000; // ms
  static const double _kScrollSpeed = 1.0; // px per frame
  static const int _kScrollDiffTolerance = 5; // px
  static const double _kMoveThreshold = 24; // px for user drag
  static const int _kMaybeTouchTimeout = 300; // ms
  static const int _kMaxContentWait = 8000; // ms
  static const int _kRetryInterval = 500; // ms

  // --- State ---
  Element? _scrollContainer;
  bool _userHasInteracted = false;
  bool _maybeUserTouch = false;
  double _maybeTouchStartX = 0;
  double _maybeTouchStartY = 0;
  double _lastAutoScrollValue = 0;
  bool _isScrollingProgrammatically = false;
  Timer? _maybeTouchTimer;
  int _rafId = 0;

  // --- Listener instances ---
  late final EventListener _scrollListener;
  late final EventListener _interactionListener;
  late final EventListener _pointerDownListener;
  late final EventListener _pointerMoveListener;
  late final EventListener _pointerUpListener;
  late final EventListener _touchStartListener;
  late final EventListener _touchMoveListener;
  late final EventListener _touchEndListener;

  /// Initialize auto scroll
  void initialize() {
    // Store listener instances
    _scrollListener = _handleUserScroll.toJS;
    _interactionListener = _handleImmediateInteraction.toJS;
    _pointerDownListener = _handleUserDown.toJS;
    _pointerMoveListener = _handleUserMove.toJS;
    _pointerUpListener = _handleUserUp.toJS;
    _touchStartListener = _handleUserDown.toJS;
    _touchMoveListener = _handleUserMove.toJS;
    _touchEndListener = _handleUserUp.toJS;

    _addEventListeners();

    // Start auto scroll after initial delay
    Future.delayed(
      const Duration(milliseconds: _kInitialDelay),
      () => _checkAndStartAutoScroll(),
    );
  }

  /// Dispose and cleanup
  void dispose() {
    _stopAutoScroll();
    _removeEventListeners();
  }

  void _addEventListeners() {
    // Wheel/keyboard stop auto-scroll immediately
    window.addEventListener('wheel', _interactionListener);
    window.addEventListener('keydown', _interactionListener);

    // Pointer events
    window.addEventListener('pointerdown', _pointerDownListener);
    window.addEventListener('pointermove', _pointerMoveListener);
    window.addEventListener('pointerup', _pointerUpListener);

    // Touch events
    window.addEventListener('touchstart', _touchStartListener);
    window.addEventListener('touchmove', _touchMoveListener);
    window.addEventListener('touchend', _touchEndListener);

    final container = document.querySelector('#wedding-page-container .custom-scroll');
    if (container != null) {
      container.addEventListener('scroll', _scrollListener);
    }
  }

  void _removeEventListeners() {
    window.removeEventListener('wheel', _interactionListener);
    window.removeEventListener('keydown', _interactionListener);

    window.removeEventListener('pointerdown', _pointerDownListener);
    window.removeEventListener('pointermove', _pointerMoveListener);
    window.removeEventListener('pointerup', _pointerUpListener);

    window.removeEventListener('touchstart', _touchStartListener);
    window.removeEventListener('touchmove', _touchMoveListener);
    window.removeEventListener('touchend', _touchEndListener);

    final container = document.querySelector('#wedding-page-container .custom-scroll');
    if (container != null) {
      container.removeEventListener('scroll', _scrollListener);
    }
  }

  // --- Auto scroll ---
  void _checkAndStartAutoScroll([int attempt = 1]) {
    if (_userHasInteracted) return;

    final container = _findScrollContainer();
    if (container != null) {
      _startAutoScroll();
    } else if (attempt * _kRetryInterval < _kMaxContentWait) {
      Future.delayed(const Duration(milliseconds: _kRetryInterval), () {
        _checkAndStartAutoScroll(attempt + 1);
      });
    }
  }

  Element? _findScrollContainer() {
    final container = document.querySelector('#wedding-page-container .custom-scroll');
    if (container != null && container.scrollHeight > container.clientHeight + 10) {
      return container;
    }
    return null;
  }

  void _startAutoScroll() {
    if (_userHasInteracted) return;

    _scrollContainer = _findScrollContainer();
    if (_scrollContainer == null) return;

    _rafLoop();
  }

  void _rafLoop() {
    if (_userHasInteracted || _scrollContainer == null) return;

    final element = _scrollContainer!;
    final currentScroll = element.scrollTop.toDouble();
    final maxScroll = element.scrollHeight - element.clientHeight;

    if (currentScroll >= maxScroll - 1) {
      _stopAutoScroll();
      return;
    }

    _isScrollingProgrammatically = true;
    element.scrollTop = (currentScroll + _kScrollSpeed).toInt();
    _lastAutoScrollValue = element.scrollTop.toDouble();
    _isScrollingProgrammatically = false;

    _rafId = window.requestAnimationFrame(_rafLoop.toJS);
  }

  void _stopAutoScroll() {
    if (_rafId != 0) {
      window.cancelAnimationFrame(_rafId);
      _rafId = 0;
    }
  }

  // --- User interaction ---
  void _handleImmediateInteraction(Event e) {
    if (!_userHasInteracted) {
      _userHasInteracted = true;
      _stopAutoScroll();
    }
  }

  void _handleUserScroll(Event e) {
    if (_scrollContainer == null || _userHasInteracted) return;

    final currentScroll = _scrollContainer!.scrollTop.toDouble();
    final scrollDiff = (currentScroll - _lastAutoScrollValue).abs();

    if (!_isScrollingProgrammatically && scrollDiff > _kScrollDiffTolerance) {
      _userHasInteracted = true;
      _stopAutoScroll();
    }
  }

  // --- Pointer / Touch unified handlers ---
  void _handleUserDown(Event e) {
    if (!e.isA<PointerEvent>() && !e.isA<TouchEvent>()) return;

    _maybeUserTouch = true;

    if (e.isA<PointerEvent>()) {
      final p = e as PointerEvent;
      _maybeTouchStartX = p.clientX.toDouble();
      _maybeTouchStartY = p.clientY.toDouble();
    } else {
      final t = e as TouchEvent;
      if (t.touches.length == 0) return;
      final touch = t.touches.item(0);
      if (touch == null) return;
      _maybeTouchStartX = touch.clientX.toDouble();
      _maybeTouchStartY = touch.clientY.toDouble();
    }

    _maybeTouchTimer?.cancel();
    _maybeTouchTimer = Timer(const Duration(milliseconds: _kMaybeTouchTimeout), () {
      _maybeUserTouch = false;
      _maybeTouchTimer = null;
    });
  }

  void _handleUserMove(Event e) {
    if (!_maybeUserTouch) return;
    if (!e.isA<PointerEvent>() && !e.isA<TouchEvent>()) return;

    double clientX = 0;
    double clientY = 0;

    if (e.isA<PointerEvent>()) {
      final p = e as PointerEvent;
      clientX = p.clientX.toDouble();
      clientY = p.clientY.toDouble();
    } else {
      final t = e as TouchEvent;
      if (t.touches.length == 0) return;
      final touch = t.touches.item(0);
      if (touch == null) return;
      clientX = touch.clientX.toDouble();
      clientY = touch.clientY.toDouble();
    }

    final dx = (clientX - _maybeTouchStartX).abs();
    final dy = (clientY - _maybeTouchStartY).abs();

    if (dx > _kMoveThreshold || dy > _kMoveThreshold) {
      _maybeTouchTimer?.cancel();
      _maybeUserTouch = false;
      _userHasInteracted = true;
      _stopAutoScroll();
    }
  }

  void _handleUserUp(Event e) {
    if (!_maybeUserTouch) return;
    _maybeTouchTimer?.cancel();
    _maybeUserTouch = false;
  }
}
