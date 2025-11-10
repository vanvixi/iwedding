import 'package:jaspr/jaspr.dart';

import 'pages/wedding_page.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return WeddingPage();
  }
}
