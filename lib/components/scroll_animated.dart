import 'package:jaspr/jaspr.dart';

/// Animation direction for scroll animations
enum AnimationDirection {
  up,    // slide-up: translateY(50px)
  down,  // slide-down: translateY(-50px)
  left,  // slide-left: translateX(50px)
  right, // slide-right: translateX(-50px)
}

/// Wrapper component that animates children when scrolled into view
///
/// Relies on ScrollObserverHelper (initialized in WeddingPage) to add 'is-visible'
/// class when element enters viewport. Component only renders markup with proper
/// classes and attributes.
class ScrollAnimated extends StatelessComponent {
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
  Component build(BuildContext context) {
    // Map direction to CSS class
    final directionClass = switch (direction) {
      AnimationDirection.up => 'slide-up',
      AnimationDirection.down => 'slide-down',
      AnimationDirection.left => 'slide-left',
      AnimationDirection.right => 'slide-right',
    };

    // Build CSS classes
    // If showImmediately is true, add 'is-visible' class directly
    // Otherwise, ScrollObserverHelper will add it when element enters viewport
    final classes = [
      'scroll-animated',
      directionClass,
      if (showImmediately) 'is-visible',
    ].join(' ');

    return div(
      classes: classes,
      attributes: {
        // Add threshold attribute for ScrollObserverHelper to use
        if (!showImmediately) 'data-threshold': threshold.toString(),
      },
      [child],
    );
  }
}
