import 'dart:js_interop';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;
import 'package:wedding/components/spacer.dart';
import '../consts/enums.dart';
import 'base_popup.dart';

@client
class GiftPopupContainer extends StatefulComponent {
  const GiftPopupContainer({super.key});

  @override
  State<GiftPopupContainer> createState() => _GiftPopupContainerState();
}

class _GiftPopupContainerState extends State<GiftPopupContainer> {
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
    web.window.addEventListener('show-gift-popup', _showListener);
    web.window.addEventListener('show-blessing-popup', _hideListener);
  }

  @override
  void dispose() {
    if (_showListener != null) {
      web.window.removeEventListener('show-gift-popup', _showListener);
    }
    if (_hideListener != null) {
      web.window.removeEventListener('show-blessing-popup', _hideListener);
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
    return GiftPopup(
      key: ValueKey('gift-popup-$_isVisible'),
      isVisible: _isVisible,
      onClose: _handleClose,
    );
  }
}

class GiftPopup extends StatefulComponent {
  const GiftPopup({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  final bool isVisible;
  final void Function() onClose;

  @override
  State<GiftPopup> createState() => _GiftPopupState();
}

class _GiftPopupState extends State<GiftPopup> {
  GiftRecipient _currentRecipient = GiftRecipient.groom;

  void _switchTab(GiftRecipient newRecipient) {
    if (newRecipient == _currentRecipient) return;
    setState(() {
      _currentRecipient = newRecipient;
    });
  }

  @override
  Component build(BuildContext context) {
    return BasePopup(
      isVisible: component.isVisible,
      onClose: component.onClose,
      child: div(
        [
          div(
            classes: 'bar-m-tit',
            [text('Mừng cưới')],
          ),
          QRCardFlip(
            showBride: _currentRecipient == GiftRecipient.bride,
          ),
          Spacer(height: 16),
          div(
            classes: 'gift-tabs',
            [
              div(classes: 'gift-tab-indicator ${_currentRecipient == GiftRecipient.bride ? 'slide' : ''}', []),
              button(
                onClick: () => _switchTab(GiftRecipient.groom),
                classes: 'gift-tab ${_currentRecipient == GiftRecipient.groom ? 'active' : ''}',
                [text('Chú Rể')],
              ),
              button(
                onClick: () => _switchTab(GiftRecipient.bride),
                classes: 'gift-tab ${_currentRecipient == GiftRecipient.bride ? 'active' : ''}',
                [text('Cô Dâu')],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QRCardFlip extends StatelessComponent {
  const QRCardFlip({
    required this.showBride,
    super.key,
  });

  final bool showBride;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'gift-flip-card ${showBride ? 'flipped' : ''}',
      [
        div(
          classes: 'gift-flip-card-inner',
          [
            _buildCardFace(recipient: GiftRecipient.groom, isFront: true),
            _buildCardFace(recipient: GiftRecipient.bride, isFront: false),
          ],
        ),
      ],
    );
  }

  Component _buildCardFace({required GiftRecipient recipient, required bool isFront}) {
    return div(
      classes: 'gift-flip-card-${isFront ? 'front' : 'back'}',
      [
        img(
          src: recipient.qrCodePath,
          alt: 'QR Code',
          classes: 'gift-flip-card-img',
        ),
        div(
          classes: 'gift-flip-card-info',
          [
            div(
              classes: 'gift-flip-card-bankName',
              [text(recipient.bankName)],
            ),
            div(
              classes: 'gift-flip-card-accountNumber',
              [text(recipient.bankAccount)],
            ),
            div(
              classes: 'gift-flip-card-accountName',
              [text(recipient.accountName)],
            ),
          ],
        ),
      ],
    );
  }
}
