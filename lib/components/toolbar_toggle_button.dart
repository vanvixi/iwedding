import 'package:jaspr/jaspr.dart';
import 'package:web/web.dart' as web;
import 'svgs/icons/ic_close.dart';
import 'svgs/icons/ic_menu.dart';

@client
class ToolbarToggleButton extends StatefulComponent {
  const ToolbarToggleButton({super.key});

  @override
  State<ToolbarToggleButton> createState() => _ToolbarToggleButtonState();
}

class _ToolbarToggleButtonState extends State<ToolbarToggleButton> {
  bool _isToolbarVisible = true;

  void _toggleToolbar() {
    setState(() {
      _isToolbarVisible = !_isToolbarVisible;
    });

    // Toggle CSS class on container
    final container = web.document.getElementById('wedding-page-container');
    if (container != null) {
      container.classList.toggle('hide-toolbar');
    }
  }

  @override
  Component build(BuildContext context) {
    return button(
      classes: 'toolbar-toggle-button',
      onClick: () => _toggleToolbar(),
      [if (_isToolbarVisible) IcClose() else IcMenu()],
    );
  }
}
