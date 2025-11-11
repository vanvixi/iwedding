import 'package:jaspr/jaspr.dart';
import '../helper/audio_control_helper.dart';

/// Audio control button component
@client
class AudioControl extends StatefulComponent {
  const AudioControl({super.key});

  @override
  State<AudioControl> createState() => _AudioControlState();
}

class _AudioControlState extends State<AudioControl> {
  late final AudioControlHelper _helper;

  @override
  void initState() {
    super.initState();
    _helper = AudioControlHelper();
    _helper.initialize();
  }

  @override
  void dispose() {
    _helper.dispose();
    super.dispose();
  }

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
