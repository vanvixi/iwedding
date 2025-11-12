import 'dart:js_interop';
import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;
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

enum GiftTab { groom, bride }

class _GiftPopupState extends State<GiftPopup> {
  GiftTab _currentTab = GiftTab.groom;

  final List<Map<String, String>> _groomAccounts = [
    {
      'qrCode': 'images/qr-vuongs2trang.png',
      'accountNumber': 'vuongs2trang',
      'accountName': 'Phạm Văn Vương',
      'bankName': 'TPBank',
    },
  ];

  final List<Map<String, String>> _brideAccounts = [
    {
      'qrCode': 'images/qr-trangs2vuong.png',
      'accountNumber': 'trangs2vuong',
      'accountName': 'Nguyễn Thị Phương Trang',
      'bankName': 'TPBank',
    },
  ];

  List<Map<String, String>> get _currentAccounts => _currentTab == GiftTab.groom ? _groomAccounts : _brideAccounts;

  @override
  Component build(BuildContext context) {
    return BasePopup(
      isVisible: component.isVisible,
      onClose: component.onClose,
      child: div(
        classes: 'gift-popup-content',
        [
          div(
            classes: 'bar-m-tit',
            [text('Mừng cưới')],
          ),

          div(
            classes: 'tab-content',
            [
              for (final account in _currentAccounts)
                div(
                  classes: 'qr-card',
                  styles: Styles(
                    display: Display.flex,
                    padding: Padding.all(Unit.pixels(16)),
                    margin: Margin.only(bottom: Unit.pixels(16)),
                    border: Border(width: Unit.pixels(1), color: Color('#eee')),
                    radius: BorderRadius.circular(Unit.pixels(10)),
                    flexDirection: FlexDirection.column,
                    alignItems: AlignItems.center,
                    backgroundColor: Color('#fff'),
                    raw: {'box-shadow': '0 2px 8px rgba(0,0,0,0.05)'},
                  ),
                  [
                    img(
                      src: account['qrCode']!,
                      alt: 'QR Code',
                      styles: Styles(
                        width: Unit.pixels(220),
                        height: Unit.pixels(220),
                        margin: Margin.only(bottom: Unit.pixels(14)),
                        border: Border(width: Unit.pixels(1), color: Color('#e0e0e0')),
                        radius: BorderRadius.circular(Unit.pixels(8)),
                        raw: {'-webkit-user-drag': 'none'},
                      ),
                    ),
                    // Thông tin tài khoản
                    div(
                      styles: Styles(width: Unit.percent(100), textAlign: TextAlign.center),
                      [
                        div(
                          styles: Styles(
                            margin: Margin.only(bottom: Unit.pixels(8)),
                            color: Color('#9e0a0a'),
                            fontSize: Unit.pixels(16),
                            fontWeight: FontWeight.bold,
                          ),
                          [text(account['bankName']!)],
                        ),
                        div(
                          styles: Styles(
                            margin: Margin.only(bottom: Unit.pixels(4)),
                            fontSize: Unit.pixels(18),
                            fontWeight: FontWeight.w600,
                          ),
                          [text(account['accountNumber']!)],
                        ),
                        div(
                          styles: Styles(color: Color('#666'), fontSize: Unit.pixels(14)),
                          [text(account['accountName']!)],
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),

          div(
            classes: 'gift-tabs',
            styles: Styles(
              display: Display.flex,
              width: Unit.percent(100),
              padding: Padding.all(Unit.pixels(4)),
              margin: Margin.symmetric(horizontal: Unit.pixels(16)),
              border: Border(width: Unit.pixels(1), color: Color('#e5e5e5')),
              radius: BorderRadius.circular(Unit.pixels(8)),
            ),
            [
              button(
                onClick: () => setState(() => _currentTab = GiftTab.groom),
                styles: _tabStyle(active: _currentTab == GiftTab.groom),
                [text('Chú Rể')],
              ),
              button(
                onClick: () => setState(() => _currentTab = GiftTab.bride),
                styles: _tabStyle(active: _currentTab == GiftTab.bride),
                [text('Cô Dâu')],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Styles _tabStyle({required bool active}) {
    return Styles(
      padding: Padding.all(Unit.pixels(4)),
      border: active ? Border(width: Unit.pixels(1), color: Color('#9e0a0a')) : null,
      radius: BorderRadius.circular(Unit.pixels(4)),
      cursor: Cursor.pointer,
      flex: Flex.auto,
      color: active ? Color('#9e0a0a') : Color('#333'),
      textAlign: TextAlign.center,
      fontWeight: active ? FontWeight.w600 : FontWeight.normal,
      backgroundColor: active ? Color('#fff5f5') : Color('#fff'),
    );
  }
}
