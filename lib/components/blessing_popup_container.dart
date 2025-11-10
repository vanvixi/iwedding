import 'dart:js_interop';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;
import '../services/blessing_service.dart';
import 'base_popup.dart';

@client
class BlessingPopupContainer extends StatefulComponent {
  const BlessingPopupContainer({super.key});

  @override
  State<BlessingPopupContainer> createState() => _BlessingPopupContainerState();
}

class _BlessingPopupContainerState extends State<BlessingPopupContainer> {
  bool _isVisible = false;
  web.EventListener? _showListener;
  web.EventListener? _hideListener;

  @override
  void initState() {
    super.initState();

    // Create event listeners with proper JS interop
    _showListener = ((web.Event event) {
      setState(() {
        _isVisible = true;
      });
    }).toJS;

    _hideListener = ((web.Event event) {
      setState(() {
        _isVisible = false;
      });
    }).toJS;

    // Register listeners
    web.window.addEventListener('show-blessing-popup', _showListener);
    web.window.addEventListener('show-gift-popup', _hideListener);
  }

  @override
  void dispose() {
    if (_showListener != null) {
      web.window.removeEventListener('show-blessing-popup', _showListener);
    }
    if (_hideListener != null) {
      web.window.removeEventListener('show-gift-popup', _hideListener);
    }
    super.dispose();
  }

  void _handleClose() {
    setState(() {
      _isVisible = false;
    });
  }

  @override
  Component build(BuildContext context) {
    return BlessingPopup(
      key: ValueKey('blessing-popup-$_isVisible'),
      isVisible: _isVisible,
      onClose: _handleClose,
    );
  }
}

class BlessingPopup extends StatelessComponent {
  const BlessingPopup({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  final bool isVisible;
  final void Function() onClose;

  @override
  Component build(BuildContext context) {
    return BasePopup(
      key: ValueKey('BlessingPopup'),
      isVisible: isVisible,
      onClose: onClose,
      child: fragment([
        // Title
        div(
          classes: 'bar-m-tit',
          [text('Lời chúc')],
        ),

        div(
          classes: 'bar-m-cont',
          [BlessingForm()],
        ),
      ]),
    );
  }
}

class BlessingForm extends StatefulComponent {
  const BlessingForm({super.key});

  @override
  State<BlessingForm> createState() => _BlessingFormState();
}

class _BlessingFormState extends State<BlessingForm> {
  final BlessingService _blessingService = BlessingService();
  bool _isSubmitting = false;
  bool _isSubmittedSuccessfully = false;
  String _errorMessage = '';

  web.HTMLInputElement? get _nameInput {
    return web.document.querySelector('.bar-m-name') as web.HTMLInputElement?;
  }

  web.HTMLTextAreaElement? get _messageInput {
    return web.document.querySelector('.bar-m-mess') as web.HTMLTextAreaElement?;
  }

  Future<void> _handleSubmit() async {
    final name = _nameInput?.value.trim() ?? '';
    final message = _messageInput?.value.trim() ?? '';

    if (name.isEmpty || message.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập đầy đủ thông tin';
      });
      return;
    }

    if (name.length < 2) {
      setState(() {
        _errorMessage = 'Tên phải có ít nhất 3 ký tự';
      });
      return;
    }

    if (name.length > 25) {
      setState(() {
        _errorMessage = 'Tên không được vượt quá 25 ký tự';
      });
      return;
    }

    if (message.length > 500) {
      setState(() {
        _errorMessage = 'Lời chúc không được vượt quá 500 ký tự';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
    });

    try {
      await _blessingService.addBlessing(
        name: name,
        message: message,
      );

      // Success - clear form and reset state
      setState(() {
        _isSubmitting = false;
        _isSubmittedSuccessfully = true;
      });
      _clearForm();

      Future.delayed(Duration(milliseconds: 500), () => _closeBlessingPopup());
    } catch (e) {
      setState(() {
        _errorMessage = 'Có lỗi xảy ra. Vui lòng thử lại!';
        _isSubmitting = false;
      });
    }
  }

  void _closeBlessingPopup() {
    final eventName = ValueKey('BlessingPopup').toString();
    final event = web.CustomEvent(eventName, web.CustomEventInit(bubbles: true));
    web.document.dispatchEvent(event);
  }

  void _clearForm() {
    _nameInput?.value = '';
    _messageInput?.value = '';
  }

  @override
  Component build(BuildContext context) {
    return fragment([
      // Name input
      div(
        classes: 'bar-m-info',
        [
          input(
            type: InputType.text,
            classes: 'bar-m-com bar-m-name',
            attributes: {
              'maxlength': '25',
              'placeholder': 'Tên của bạn',
            },
          ),
        ],
      ),

      // Message textarea
      div(
        classes: 'bar-m-info',
        [
          textarea(
            classes: 'bar-m-com bar-m-mess',
            placeholder: 'Lời chúc của bạn',
            [],
          ),
        ],
      ),

      // Error message
      if (_errorMessage.isNotEmpty)
        div(
          classes: 'text-red-500 text-sm mt-2 text-center',
          [text(_errorMessage)],
        ),

      // Submit button
      button(
        classes: 'wedding-btn rounded',
        styles: Styles(
          width: Unit.percent(90),
          margin: Margin.only(top: Unit.pixels(24)),
        ),
        onClick: () => _handleSubmit(),
        disabled: _isSubmitting || _isSubmittedSuccessfully,
        [
          text(_isSubmittedSuccessfully ? 'Đã Gửi Lời Chúc' : (_isSubmitting ? 'Đang gửi...' : 'Gửi Lời Chúc')),
        ],
      ),
    ]);
  }
}
