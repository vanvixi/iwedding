/**
 * Wedding Audio Control
 *
 * Controls the audio element and music icon in the Wedding component
 */

(function() {
  'use strict';

  let audio = null;
  let audioWrapper = null;
  let musicIcon = null;
  let iconCancel = null;
  let isPlaying = false;

  /**
   * Initialize audio control
   */
  function init() {
    // Wait for DOM to be ready
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', setup);
    } else {
      setup();
    }
  }

  /**
   * Setup audio controls
   */
  function setup() {
    // Get elements
    audio = document.querySelector('audio');
    audioWrapper = document.getElementById('audio-control-wrapper');
    musicIcon = document.querySelector('.music-icon');
    iconCancel = document.querySelector('.icon-cancel');

    if (!audio || !audioWrapper || !musicIcon) {
      setTimeout(setup, 500);
      return;
    }

    // Set initial volume
    audio.volume = 0.5;

    // Add click handler to toggle audio
    audioWrapper.addEventListener('click', toggleAudio);
    // Auto-play on first user interaction
    setupAutoPlay();

    // Update icon state
    updateIconState();
  }

  /**
   * Setup auto-play on first user interaction
   * Triggers on ANY user interaction: touch, scroll, click, swipe, keyboard, etc.
   */
  function setupAutoPlay() {
    // Only use "active" user interactions that browsers allow for autoplay
    // DO NOT use: mousemove, pointermove, touchmove (passive events)
    const events = [
      'click',
      'touchstart',
      'touchend',
      'scroll',
      'wheel',
      'keydown',
      'keyup',
      'mousedown',
      'pointerdown'
    ];

    let hasPlayed = false;

    const playOnce = (event) => {

      if (hasPlayed || isPlaying) {
        return;
      }


      // Try to play audio
      playAudioWithCallback(() => {
        // Only mark as played and remove listeners if audio actually started
        hasPlayed = true;
        events.forEach(eventType => {
          document.removeEventListener(eventType, playOnce);
        });
      });
    };

    events.forEach(eventType => {
      document.addEventListener(eventType, playOnce, {
        passive: true
      });
    });
  }

  /**
   * Toggle audio play/pause
   */
  function toggleAudio(e) {
    e.preventDefault();
    e.stopPropagation();

    if (!audio) return;

    if (isPlaying) {
      pauseAudio();
    } else {
      playAudio();
    }
  }

  /**
   * Play audio with fade in
   */
  function playAudio() {
    if (!audio) {
      console.error('🎵 No audio element found!');
      return;
    }

    audio.play()
      .then(() => {
        isPlaying = true;
        updateIconState();
        fadeIn();
      })
      .catch((error) => {
        console.error('🎵 Failed to play audio:', error);
        console.error('🎵 Error details:', error.message, error.name);
      });
  }

  /**
   * Play audio with callback on success
   */
  function playAudioWithCallback(onSuccess) {
    if (!audio) {
      console.error('🎵 No audio element found!');
      return;
    }

    audio.play()
      .then(() => {
        isPlaying = true;
        updateIconState();
        fadeIn();

        // Call success callback
        if (onSuccess) {
          onSuccess();
        }
      })
      .catch((error) => {
        console.error('🎵 Failed to play audio:', error);
        console.error('🎵 Error details:', error.message, error.name);
        // Do NOT call callback on failure - let user try again
      });
  }

  /**
   * Pause audio
   */
  function pauseAudio() {
    if (!audio) return;

    audio.pause();
    isPlaying = false;
    updateIconState();
  }

  /**
   * Fade in audio volume
   */
  function fadeIn() {
    if (!audio) return;

    const targetVolume = 0.5;
    const steps = 20;
    const stepDuration = 2000 / steps; // 2 seconds total
    const volumeIncrement = targetVolume / steps;
    let currentStep = 0;

    audio.volume = 0;

    const fadeInterval = setInterval(() => {
      currentStep++;
      audio.volume = Math.min(volumeIncrement * currentStep, targetVolume);

      if (currentStep >= steps) {
        clearInterval(fadeInterval);
      }
    }, stepDuration);
  }

  /**
   * Update icon state based on playing status
   */
  function updateIconState() {
    if (!musicIcon || !iconCancel) return;

    const audioToggle = musicIcon.closest('.audio-toggle');
    if (!audioToggle) return;

    if (isPlaying) {
      // Playing state: rotate icon, hide cancel line
      audioToggle.classList.add('is-playing');
      audioToggle.classList.remove('is-paused');
    } else {
      // Paused state: stop rotation, show cancel line
      audioToggle.classList.remove('is-playing');
      audioToggle.classList.add('is-paused');
    }
  }

  // Start initialization
  init();

})();
