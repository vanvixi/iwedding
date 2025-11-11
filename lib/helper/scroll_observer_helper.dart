import 'dart:js_interop';
import 'package:web/web.dart';

/// Scroll Animation Observer Helper
///
/// Detects when elements with class 'scroll-animated' enter the viewport
/// and adds 'is-visible' class to trigger animations
class ScrollObserverHelper {
  // Configuration
  static const String _kAnimatedClass = 'scroll-animated';
  static const String _kVisibleClass = 'is-visible';
  static const String _kThresholdAttr = 'data-threshold';
  static const double _kDefaultThreshold = 0.1;

  IntersectionObserver? _defaultObserver;
  MutationObserver? _mutationObserver;
  final Map<Element, IntersectionObserver> _customObservers = {};

  late final IntersectionObserverCallback _observerCallback;

  /// Initialize scroll observer
  void initialize() {
    _observerCallback = _createObserverCallback().toJS;

    // Create default observer
    _defaultObserver = IntersectionObserver(
      _observerCallback,
      IntersectionObserverInit(
        root: null,
        rootMargin: '0px',
        threshold: _kDefaultThreshold.toJS,
      ),
    );

    // Observe existing elements
    _observeExistingElements();

    // Watch for dynamically added elements
    _setupMutationObserver();
  }

  /// Dispose and cleanup
  void dispose() {
    _defaultObserver?.disconnect();
    _mutationObserver?.disconnect();

    // Disconnect all custom observers
    for (final observer in _customObservers.values) {
      observer.disconnect();
    }
    _customObservers.clear();
  }

  void Function(JSArray<JSObject>, IntersectionObserver) _createObserverCallback() {
    return (JSArray<JSObject> entriesJS, IntersectionObserver observer) {
      final entries = entriesJS.toDart;

      for (final entryJS in entries) {
        final entry = entryJS as IntersectionObserverEntry;

        if (entry.isIntersecting) {
          final target = entry.target;

          // Add visible class
          target.classList.add(_kVisibleClass);

          // Stop observing (one-time animation)
          observer.unobserve(target);
        }
      }
    };
  }

  void _observeExistingElements() {
    final elements = document.querySelectorAll('.$_kAnimatedClass');

    for (var i = 0; i < elements.length; i++) {
      final element = elements.item(i) as Element?;
      if (element != null) {
        _observeElement(element);
      }
    }
  }

  void _observeElement(Element element) {
    // Skip if already visible
    if (element.classList.contains(_kVisibleClass)) {
      return;
    }

    // Check for custom threshold
    final customThresholdStr = element.getAttribute(_kThresholdAttr);

    if (customThresholdStr != null) {
      final threshold = double.tryParse(customThresholdStr) ?? _kDefaultThreshold;

      // Create custom observer for this element
      final customObserver = IntersectionObserver(
        _observerCallback,
        IntersectionObserverInit(
          root: null,
          rootMargin: '0px',
          threshold: threshold.toJS,
        ),
      );

      customObserver.observe(element);
      _customObservers[element] = customObserver;
    } else {
      // Use default observer
      _defaultObserver?.observe(element);
    }
  }

  void _setupMutationObserver() {
    _mutationObserver = MutationObserver(
      ((JSArray<JSObject> mutationsJS, MutationObserver observer) {
        final mutations = mutationsJS.toDart;

        for (final mutationJS in mutations) {
          final mutation = mutationJS as MutationRecord;
          final addedNodes = mutation.addedNodes;

          for (var i = 0; i < addedNodes.length; i++) {
            final node = addedNodes.item(i);
            if (node == null) continue;

            // Check if node is an element with scroll-animated class
            if (node.nodeType == Node.ELEMENT_NODE) {
              final element = node as Element;

              if (element.classList.contains(_kAnimatedClass)) {
                _observeElement(element);
              }

              // Check children
              final children = element.querySelectorAll('.$_kAnimatedClass');
              for (var j = 0; j < children.length; j++) {
                final child = children.item(j) as Element?;
                if (child != null) {
                  _observeElement(child);
                }
              }
            }
          }
        }
      }).toJS,
    );

    final body = document.body;
    if (body != null) {
      _mutationObserver?.observe(
        body,
        MutationObserverInit(
          childList: true,
          subtree: true,
        ),
      );
    }
  }
}
