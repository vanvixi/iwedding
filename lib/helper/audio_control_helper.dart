import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart';

/// Audio Control Helper
///
/// Controls the audio element and music icon
class AudioControlHelper {
  // Configuration
  static const double _kTargetVolume = 0.5;
  static const int _kFadeSteps = 20;
  static const int _kFadeDuration = 2000;
  static const int _kSetupRetryDelay = 500;

  // Auto-play event types that browsers allow
  static const List<String> _kAutoPlayEvents = [
    'click',
    'touchstart',
    'touchend',
    'scroll',
    'wheel',
    'keydown',
    'keyup',
    'mousedown',
    'pointerdown',
  ];

  // DOM elements
  HTMLAudioElement? _audio;
  Element? _audioWrapper;
  Element? _audioToggle;

  // State
  bool _isPlaying = false;
  bool _hasAutoPlayed = false;

  // Event listeners
  late final EventListener _clickListener;
  final List<EventListener> _autoPlayListeners = [];

  /// Initialize audio control
  void initialize() {
    _clickListener = _handleClick.toJS;
    _setup();
  }

  /// Dispose and cleanup
  void dispose() {
    _audioWrapper?.removeEventListener('click', _clickListener);
    _removeAutoPlayListeners();
  }

  void _setup() {
    // Query DOM elements
    _audio = document.querySelector('audio') as HTMLAudioElement?;
    _audioWrapper = document.getElementById('audio-control-wrapper');
    final musicIcon = document.querySelector('.music-icon');

    // Retry if elements not ready
    if (_audio == null || _audioWrapper == null || musicIcon == null) {
      Future.delayed(const Duration(milliseconds: _kSetupRetryDelay), _setup);
      return;
    }

    // Find audio toggle container
    _audioToggle = musicIcon.closest('.audio-toggle');

    // Set initial volume and state
    _audio!.volume = _kTargetVolume;
    _updateIconState();

    // Add event listeners
    _audioWrapper!.addEventListener('click', _clickListener);
    _setupAutoPlay();
  }

  void _setupAutoPlay() {
    for (final eventType in _kAutoPlayEvents) {
      final listener = _createAutoPlayListener().toJS;
      _autoPlayListeners.add(listener);
      document.addEventListener(eventType, listener);
    }
  }

  void Function(Event) _createAutoPlayListener() {
    return (Event event) {
      if (_hasAutoPlayed || _isPlaying) return;

      _tryPlayAudio(() {
        _hasAutoPlayed = true;
        _removeAutoPlayListeners();
      });
    };
  }

  void _removeAutoPlayListeners() {
    for (var i = 0; i < _kAutoPlayEvents.length && i < _autoPlayListeners.length; i++) {
      document.removeEventListener(_kAutoPlayEvents[i], _autoPlayListeners[i]);
    }
    _autoPlayListeners.clear();
  }

  void _handleClick(Event event) {
    event.preventDefault();
    event.stopPropagation();

    if (_audio == null) return;

    if (_isPlaying) {
      _pauseAudio();
    } else {
      _playAudio();
    }
  }

  void _playAudio() {
    _tryPlayAudio(null);
  }

  void _tryPlayAudio(void Function()? onSuccess) {
    if (_audio == null) {
      print('🎵 No audio element found!');
      return;
    }

    _audio!
        .play()
        .toDart
        .then((_) {
          _isPlaying = true;
          _updateIconState();
          _fadeIn();
          onSuccess?.call();
        })
        .catchError((error) {
          print('🎵 Failed to play audio: $error');
          // Don't call onSuccess on failure
        });
  }

  void _pauseAudio() {
    if (_audio == null) return;

    _audio!.pause();
    _isPlaying = false;
    _updateIconState();
  }

  void _fadeIn() {
    if (_audio == null) return;

    const stepDuration = _kFadeDuration ~/ _kFadeSteps;
    const volumeIncrement = _kTargetVolume / _kFadeSteps;
    var currentStep = 0;

    _audio!.volume = 0;

    Timer.periodic(const Duration(milliseconds: stepDuration), (timer) {
      currentStep++;

      final audio = _audio;
      if (audio != null) {
        audio.volume = (volumeIncrement * currentStep).clamp(0.0, _kTargetVolume);
      }

      if (currentStep >= _kFadeSteps || audio == null) {
        timer.cancel();
      }
    });
  }

  void _updateIconState() {
    if (_audioToggle == null) return;

    if (_isPlaying) {
      _audioToggle!.classList.add('is-playing');
      _audioToggle!.classList.remove('is-paused');
    } else {
      _audioToggle!.classList.remove('is-playing');
      _audioToggle!.classList.add('is-paused');
    }
  }
}
