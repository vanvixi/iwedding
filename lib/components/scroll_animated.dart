import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;

/// Animation direction for scroll animations
enum AnimationDirection {
  up,    // slide-up: translateY(50px)
  down,  // slide-down: translateY(-50px)
  left,  // slide-left: translateX(50px)
  right, // slide-right: translateX(-50px)
}

/// Wrapper component that animates children when scrolled into view
///
/// Uses internal state to show content immediately on mount, then relies on
/// JavaScript Intersection Observer for subsequent scroll animations
class ScrollAnimated extends StatefulComponent {
  const ScrollAnimated({
    super.key,
    required this.child,
    this.threshold = 0.1,
    this.showImmediately = false,
    this.direction = AnimationDirection.up,
  });

  final Component child;
  final double threshold;
  final bool showImmediately;
  final AnimationDirection direction;

  @override
  State<ScrollAnimated> createState() => _ScrollAnimatedState();
}

class _ScrollAnimatedState extends State<ScrollAnimated> {
  bool _isVisible = false;
  String? _elementId;

  @override
  void initState() {
    super.initState();

    // Generate unique ID for this instance
    _elementId = 'scroll-animated-${DateTime.now().microsecondsSinceEpoch}-$hashCode';

    // Show content immediately if requested (for above-the-fold content)
    if (component.showImmediately) {
      // Use Future.microtask to trigger animation after first render
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _isVisible = true;
          });
        }
      });
    } else {
      // Check if element already has is-visible class (from previous render)
      Future.microtask(() {
        if (!mounted) return;
        final element = web.document.getElementById(_elementId!);
        if (element != null && element.classList.contains('is-visible')) {
          // Preserve visible state
          setState(() {
            _isVisible = true;
          });
        }
      });
    }
  }

  @override
  Component build(BuildContext context) {
    // Map direction to CSS class
    final directionClass = switch (component.direction) {
      AnimationDirection.up => 'slide-up',
      AnimationDirection.down => 'slide-down',
      AnimationDirection.left => 'slide-left',
      AnimationDirection.right => 'slide-right',
    };

    // Build CSS classes
    final classes = [
      'scroll-animated',
      directionClass,
      if (_isVisible) 'is-visible',
    ].join(' ');

    return div(
      id: _elementId,
      classes: classes,
      attributes: {
        'data-threshold': component.threshold.toString(),
      },
      [component.child],
    );
  }
}
