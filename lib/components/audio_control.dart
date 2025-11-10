import 'package:jaspr/jaspr.dart';

/// Audio control button component
class AudioControl extends StatelessComponent {
  const AudioControl({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      id: 'audio-control-wrapper',
      classes: 'cursor-pointer',
      [
        audio(
          src: '/audio/wedding-music.mp3',
          loop: true,
          preload: Preload.auto,
          [],
        ),
        div(
          classes: 'audio-toggle',
          [
            img(
              classes: 'music-icon',
              src: 'images/ic-audio.png',
              alt: 'music icon',
            ),
            div(
              classes: 'icon-cancel',
              [
                div(classes: 'icon-line', []),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
