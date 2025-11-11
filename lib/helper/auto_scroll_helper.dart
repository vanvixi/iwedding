import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart';

/// Auto Scroll Helper
///
/// Automatically scrolls the page slowly after initial delay
/// Supports both window scroll and container scroll (for mobile frames)
class AutoScrollHelper {
  // Configuration
  static const int _kInitialDelay = 3000;
  static const int _kScrollSpeed = 1;
  static const int _kScrollInterval = 30;
  static const int _kMaxContentWait = 8000;
  static const int _kRetryInterval = 500;
  static const int _kScrollDiffTolerance = 5;

  // State
  Timer? _autoScrollTimer;
  Element? _scrollContainer;
  bool _userHasInteracted = false;
  double _lastAutoScrollValue = 0;
  bool _isScrollingProgrammatically = false;

  // Event listeners
  late final EventListener _scrollListener;
  late final EventListener _interactionListener;

  /// Initialize auto scroll
  void initialize() {
    _scrollListener = _handleUserScroll.toJS;
    _interactionListener = _handleUserInteraction.toJS;

    // Add keyboard and wheel listeners
    window.addEventListener('wheel', _interactionListener);
    window.addEventListener('keydown', _interactionListener);

    // Add scroll listeners
    _addScrollListeners();

    // Start checking for scrollable content after initial delay
    Future.delayed(const Duration(milliseconds: _kInitialDelay), () {
      _checkAndStartAutoScroll();
    });
  }

  /// Dispose and cleanup
  void dispose() {
    _stopAutoScroll();
    _removeEventListeners();
  }

  void _addScrollListeners() {
    // Listen to scroll events on the custom-scroll container
    final container = document.querySelector('#wedding-page-container .custom-scroll');
    if (container != null) {
      container.addEventListener('scroll', _scrollListener);
    }
  }

  void _removeEventListeners() {
    window.removeEventListener('wheel', _interactionListener);
    window.removeEventListener('keydown', _interactionListener);

    final container = document.querySelector('#wedding-page-container .custom-scroll');
    if (container != null) {
      container.removeEventListener('scroll', _scrollListener);
    }
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _handleUserScroll(Event event) {
    // Ignore scroll events triggered by our auto-scroll
    if (_isScrollingProgrammatically || _scrollContainer == null) {
      return;
    }

    final currentScroll = _scrollContainer!.scrollTop.toDouble();
    final scrollDiff = (currentScroll - _lastAutoScrollValue).abs();

    // Detect manual scroll if difference is significant
    if (scrollDiff > _kScrollDiffTolerance && !_userHasInteracted) {
      _userHasInteracted = true;
      _stopAutoScroll();
    }
  }

  void _handleUserInteraction(Event event) {
    if (!_userHasInteracted) {
      _userHasInteracted = true;
      _stopAutoScroll();
    }
  }

  Element? _findScrollContainer() {
    // The scrollable container is div.custom-scroll inside #wedding-page-container
    final container = document.querySelector('#wedding-page-container .custom-scroll');

    if (container != null && container.scrollHeight > container.clientHeight + 10) {
      return container;
    }

    return null;
  }

  void _checkAndStartAutoScroll([int attempt = 1]) {
    if (_userHasInteracted) return;

    final container = _findScrollContainer();

    if (container != null) {
      _startAutoScroll();
    } else if (attempt * _kRetryInterval < _kMaxContentWait) {
      // Content might still be loading, retry
      Future.delayed(const Duration(milliseconds: _kRetryInterval), () {
        _checkAndStartAutoScroll(attempt + 1);
      });
    }
  }

  void _startAutoScroll() {
    if (_userHasInteracted) return;

    _scrollContainer = _findScrollContainer();
    if (_scrollContainer == null) return;

    _autoScrollTimer = Timer.periodic(
      const Duration(milliseconds: _kScrollInterval),
      _performScrollStep,
    );
  }

  void _performScrollStep(Timer timer) {
    if (_userHasInteracted || _scrollContainer == null) {
      timer.cancel();
      return;
    }

    final element = _scrollContainer!;
    final currentScroll = element.scrollTop.toDouble();
    final maxScroll = element.scrollHeight - element.clientHeight;

    // Check if reached bottom
    if (currentScroll >= maxScroll - 10) {
      _stopAutoScroll();
      return;
    }

    // Scroll down smoothly
    _isScrollingProgrammatically = true;
    element.scrollTop = (currentScroll + _kScrollSpeed).toInt();
    _lastAutoScrollValue = element.scrollTop.toDouble();
    _isScrollingProgrammatically = false;
  }
}
