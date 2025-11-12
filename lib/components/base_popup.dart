import 'dart:js_interop';

import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;

import '../helper/popup_height_helper.dart';
import 'svgs/icons/ic_close.dart';

/// Base popup component with slide-up/down animations
class BasePopup extends StatefulComponent {
  const BasePopup({
    super.key,
    required this.isVisible,
    required this.onClose,
    required this.child,
  });

  final bool isVisible;
  final VoidCallback onClose;
  final Component child;

  @override
  State<BasePopup> createState() => _BasePopupState();
}

class _BasePopupState extends State<BasePopup> {
  bool _hasAnimated = false;
  bool _isClosing = false;
  web.EventListener? _eventListener;
  final PopupHeightHelper _heightHelper = PopupHeightHelper();

  @override
  void initState() {
    super.initState();
    if (component.isVisible) {
      _triggerAnimation();
      _heightHelper.initialize();
    }
    _addEventCloseWithAnimationListener();
  }

  @override
  void dispose() {
    if (_eventListener != null && component.key != null) {
      web.document.removeEventListener(component.key.toString(), _eventListener);
    }
    _heightHelper.dispose();
    super.dispose();
  }

  @override
  void didUpdateComponent(BasePopup oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (component.isVisible && !oldComponent.isVisible) {
      // Reset state completely when opening
      setState(() {
        _hasAnimated = false;
        _isClosing = false;
      });
      _triggerAnimation();
      _heightHelper.refresh();
    } else if (!component.isVisible && oldComponent.isVisible && !_isClosing) {
      // If closed from outside without animation, reset immediately
      setState(() {
        _hasAnimated = false;
        _isClosing = false;
      });
    }
  }

  void _triggerAnimation() {
    Future.microtask(() {
      if (mounted) {
        Future.delayed(Duration(milliseconds: 10), () {
          if (mounted) {
            setState(() => _hasAnimated = true);
          }
        });
      }
    });
  }

  void _closeWithAnimation() {
    if (_isClosing) return; // Prevent multiple calls

    setState(() {
      _isClosing = true;
      _hasAnimated = false; // Start with exit class
    });

    // Trigger exit animation after a small delay
    Future.microtask(() {
      if (mounted) {
        Future.delayed(Duration(milliseconds: 10), () {
          if (mounted) {
            setState(() => _hasAnimated = true); // Apply exit-active class
          }
        });
      }
    });

    // Wait for animation to complete, then close
    Future.delayed(Duration(milliseconds: 320), () {
      if (mounted) {
        setState(() {
          _isClosing = false;
        });
        component.onClose();
      }
    });
  }

  void _addEventCloseWithAnimationListener() {
    final key = component.key;
    if (key == null) return;

    _eventListener = ((web.Event event) {
      _closeWithAnimation();
    }).toJS;
    web.document.addEventListener(key.toString(), _eventListener);
  }

  @override
  Component build(BuildContext context) {
    if (!component.isVisible && !_isClosing) return fragment([]);

    final popupClasses = [
      'popup-wrapper',
      if (_isClosing)
        (_hasAnimated ? 'slideInBtm-exit-active' : 'slideInBtm-exit')
      else
        (_hasAnimated ? 'slideInBtm-enter-active' : 'slideInBtm-enter'),
    ].join(' ');

    final backdropClasses = [
      'popup-backdrop',
      if (_isClosing)
        (_hasAnimated ? 'fade-exit-active' : 'fade-exit')
      else
        (_hasAnimated ? 'fade-enter-active' : 'fade-enter'),
    ].join(' ');

    return fragment([
      // Backdrop
      div(
        classes: backdropClasses,
        events: {
          'click': (event) => _closeWithAnimation(),
        },
        [],
      ),

      // Popup content
      div(
        classes: popupClasses,
        [
          div(
            classes: 'bar-messwin',
            [
              // Close button
              span(
                classes: 'iconfont icon-guanbi cursor-pointer popup-close-btn',
                events: {
                  'click': (event) => _closeWithAnimation(),
                },
                [IcClose()],
              ),

              // Child content
              component.child,
            ],
          ),
        ],
      ),
    ]);
  }
}
