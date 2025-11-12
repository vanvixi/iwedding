import 'dart:js_interop';
import 'package:web/web.dart';

/// Popup Height Helper
///
/// Adjusts popup height to prevent content from being covered by mobile browser UI
/// (address bars, home indicators, etc.)
class PopupHeightHelper {
  // Configuration
  static const String _kPopupSelector = '.popup-wrapper';
  static const double _kHeightPercentage = 0.8; // 80% of viewport
  static const int _kSetupRetryDelay = 50;
  static const int _kMaxRetries = 20;

  // DOM elements
  HTMLElement? _popupElement;

  // State
  int _setupAttempts = 0;

  // Event listeners
  late final EventListener _resizeListener;

  /// Initialize popup height adjustment
  void initialize() {
    _resizeListener = _handleResize.toJS;
    _setup();
  }

  /// Dispose and cleanup
  void dispose() {
    window.removeEventListener('resize', _resizeListener);
    _popupElement = null;
  }

  void _setup() {
    _setupAttempts++;

    // Query popup element
    _popupElement = document.querySelector(_kPopupSelector) as HTMLElement?;

    // Retry if element not ready
    if (_popupElement == null && _setupAttempts < _kMaxRetries) {
      Future.delayed(const Duration(milliseconds: _kSetupRetryDelay), _setup);
      return;
    }

    if (_popupElement == null) {
      return;
    }

    // Apply initial height adjustment
    _adjustHeight();

    // Listen to window resize events (includes orientation changes and browser UI changes)
    window.addEventListener('resize', _resizeListener);

    // Listen to visualViewport changes if available
    final visualViewport = window.visualViewport;
    if (visualViewport != null) {
      visualViewport.addEventListener('resize', _resizeListener);
    }
  }

  void _handleResize(Event event) {
    _adjustHeight();
  }

  void _adjustHeight() {
    final popup = _popupElement;
    if (popup == null) return;

    // Get actual visible viewport height
    // Visual viewport accounts for mobile browser UI (address bars, keyboards, etc.)
    final visualViewport = window.visualViewport;
    final viewportHeight = visualViewport?.height ?? window.innerHeight;

    // Calculate max height as percentage of visible viewport
    final maxHeight = viewportHeight * _kHeightPercentage;

    // Apply the height
    popup.style.maxHeight = '${maxHeight}px';
  }

  /// Manually trigger height adjustment
  /// Useful when popup visibility changes
  void refresh() {
    if (_popupElement == null) {
      _setup();
    } else {
      _adjustHeight();
    }
  }
}
