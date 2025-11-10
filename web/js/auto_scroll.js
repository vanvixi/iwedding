/**
 * Auto Scroll Feature
 *
 * Automatically scrolls the page slowly after initial delay
 * Supports both window scroll and container scroll (for mobile frames)
 */

(function() {

  // Configuration
  const INITIAL_DELAY = 4000; // 4 seconds before starting auto-scroll (give time for content to render)
  const SCROLL_SPEED = 1; // pixels per frame (lower = slower, smoother)
  const SCROLL_INTERVAL = 30; // milliseconds between each scroll step
  const MAX_CONTENT_WAIT = 8000; // Maximum 8 seconds to wait for content to be scrollable
  const RETRY_INTERVAL = 500; // Check every 500ms if content is ready

  let autoScrollInterval = null;
  let isAutoScrolling = false;
  let userHasInteracted = false;
  let scrollContainer = null; // Will store the actual scroll container

  // Function to find the scroll container
  function findScrollContainer() {
    // Priority 1: Check the main app view content container (inside mobile-frame)
    const wdContainer = document.querySelector('#wedding-page-container');
    if (wdContainer) {
      // The scrollable container is the first child div inside wedding-page-container
      const contentContainer = wdContainer.querySelector('div.custom-scroll');
      if (contentContainer) {
        const hasScroll = contentContainer.scrollHeight > contentContainer.clientHeight;
        if (hasScroll) return contentContainer;
      }

      // If custom-scroll div not found, try the wedding-page-container itself
      const hasScroll = wdContainer.scrollHeight > wdContainer.clientHeight;

      if (hasScroll) return wdContainer;
    }

    // Priority 2: Try to find mobile frame container
    const mobileFrame = document.querySelector('.mobile-frame');
    if (mobileFrame) {
      const hasScroll = mobileFrame.scrollHeight > mobileFrame.clientHeight;

      if (hasScroll) return mobileFrame;
    }

    // Priority 3: Try wedding container
    const weddingContainer = document.querySelector('.wedding-page');
    if (weddingContainer) {
      const hasScroll = weddingContainer.scrollHeight > weddingContainer.clientHeight;

      if (hasScroll) return weddingContainer;
    }

    return window;
  }

  // Function to start auto-scrolling
  function startAutoScroll() {
    if (isAutoScrolling || userHasInteracted) {
      return;
    }

    // Find the scroll container
    scrollContainer = findScrollContainer();

    isAutoScrolling = true;

    autoScrollInterval = setInterval(() => {
      let currentScroll, scrollHeight, clientHeight, maxScroll;

      if (scrollContainer === window) {
        // Window scroll
        currentScroll = window.pageYOffset || document.documentElement.scrollTop;
        scrollHeight = document.documentElement.scrollHeight;
        clientHeight = window.innerHeight;
      } else {
        // Container scroll
        currentScroll = scrollContainer.scrollTop;
        scrollHeight = scrollContainer.scrollHeight;
        clientHeight = scrollContainer.clientHeight;
      }

      maxScroll = scrollHeight - clientHeight;

      // If reached bottom, stop auto-scroll
      if (currentScroll >= maxScroll - 10) {
        stopAutoScroll();
        return;
      }

      // Scroll down smoothly
      if (scrollContainer === window) {
        window.scrollBy(0, SCROLL_SPEED);
      } else {
        scrollContainer.scrollBy(0, SCROLL_SPEED);
      }
    }, SCROLL_INTERVAL);
  }

  // Function to stop auto-scrolling
  function stopAutoScroll() {
    if (autoScrollInterval) {
      clearInterval(autoScrollInterval);
      autoScrollInterval = null;
      isAutoScrolling = false;
    }
  }

  // Stop auto-scroll on user interaction
  function handleUserInteraction(event) {
    if (!userHasInteracted) {
      userHasInteracted = true;
      stopAutoScroll();
    }
  }

  // Function to check if content is scrollable and start auto-scroll
  function checkAndStartAutoScroll(attempt = 1) {
    let hasScrollableContent = false;

    // Priority 1: Check wedding-page-container content
    const wdContainer = document.querySelector('#wedding-page-container');
    if (wdContainer) {
      const contentContainer = wdContainer.querySelector('div.custom-scroll');
      if (contentContainer) {
        const scrollable = contentContainer.scrollHeight > contentContainer.clientHeight + 10;
        if (scrollable) {
          hasScrollableContent = true;
        }
      }

      // Try wedding-page-container itself
      if (!hasScrollableContent) {
        const scrollable = wdContainer.scrollHeight > wdContainer.clientHeight + 10;

        if (scrollable) {
          hasScrollableContent = true;
        }
      }
    }

    // Priority 2: Check mobile frame
    if (!hasScrollableContent) {
      const mobileFrame = document.querySelector('.mobile-frame');
      if (mobileFrame) {
        const frameScrollable = mobileFrame.scrollHeight > mobileFrame.clientHeight + 10;

        if (frameScrollable) {
          hasScrollableContent = true;
        }
      }
    }

    // Priority 3: Check wedding container
    if (!hasScrollableContent) {
      const weddingContainer = document.querySelector('.wedding-page');
      if (weddingContainer) {
        const containerScrollable = weddingContainer.scrollHeight > weddingContainer.clientHeight + 10;

        if (containerScrollable) {
          hasScrollableContent = true;
        }
      }
    }

    // Fallback to window scroll
    if (!hasScrollableContent) {
      const windowScrollable = document.documentElement.scrollHeight > window.innerHeight + 10;

      hasScrollableContent = windowScrollable;
    }

    if (hasScrollableContent && !userHasInteracted) {
      startAutoScroll();
    } else if (!hasScrollableContent && attempt * RETRY_INTERVAL < MAX_CONTENT_WAIT) {
      // Content might still be loading, try again after RETRY_INTERVAL
      setTimeout(() => checkAndStartAutoScroll(attempt + 1), RETRY_INTERVAL);
    } 
  }

  // Initialize function
  function init() {
    // Listen for user interactions on both window and potential scroll containers
    const interactionEvents = [
      'wheel',        // Mouse wheel
      'touchstart',   // Touch
      'touchmove',    // Touch drag
      'keydown',      // Keyboard
      'mousedown',    // Mouse click
    ];

    // Add listeners to window
    interactionEvents.forEach(eventType => {
      window.addEventListener(eventType, handleUserInteraction, { passive: true });
    });

    // Also add listeners to potential scroll containers
    const addContainerListeners = () => {
      const container = document.querySelector('#wedding-page-container');
      const mobileFrame = document.querySelector('.mobile-frame');
      const weddingContainer = document.querySelector('.wedding-page');

      if (container) {
        interactionEvents.forEach(eventType => {
          container.addEventListener(eventType, handleUserInteraction, { passive: true });
        });

        const contentContainer = container.querySelector('div.custom-scroll');
        if (contentContainer) {
          interactionEvents.forEach(eventType => {
            contentContainer.addEventListener(eventType, handleUserInteraction, { passive: true });
          });
        }
      }

      if (mobileFrame) {
        interactionEvents.forEach(eventType => {
          mobileFrame.addEventListener(eventType, handleUserInteraction, { passive: true });
        });
      }

      if (weddingContainer) {
        interactionEvents.forEach(eventType => {
          weddingContainer.addEventListener(eventType, handleUserInteraction, { passive: true });
        });
      }
    };

    // Add container listeners immediately and after a short delay (in case DOM not ready)
    addContainerListeners();
    setTimeout(addContainerListeners, 1000);

    // Start checking for scrollable content after initial delay
    setTimeout(() => {
      checkAndStartAutoScroll();
    }, INITIAL_DELAY);
  }

  // Wait for DOM to be ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    // DOM is already ready
    init();
  }

})();
