/**
 * Scroll Animation Observer
 *
 * Detects when elements with class 'scroll-animated' enter the viewport
 * and adds 'is-visible' class to trigger animations
 */

document.addEventListener('DOMContentLoaded', function() {
  // Configuration for the observer
  const observerOptions = {
    root: null, // viewport
    rootMargin: '0px',
    threshold: 0.1 // trigger when 10% of element is visible
  };

  // Callback when elements enter/exit viewport
  const observerCallback = (entries, observer) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        // Element is now visible
        entry.target.classList.add('is-visible');

        // Stop observing after animation (one-time animation)
        // This prevents the animation from reversing when layout changes
        observer.unobserve(entry.target);
      }
    });
  };

  // Create the observer
  const observer = new IntersectionObserver(observerCallback, observerOptions);

  // Observe all elements with 'scroll-animated' class
  const animatedElements = document.querySelectorAll('.scroll-animated');
  animatedElements.forEach(element => {
    // Read custom threshold if provided
    const customThreshold = element.getAttribute('data-threshold');
    if (customThreshold) {
      const customOptions = {
        ...observerOptions,
        threshold: parseFloat(customThreshold)
      };
      const customObserver = new IntersectionObserver(observerCallback, customOptions);
      customObserver.observe(element);
    } else {
      observer.observe(element);
    }
  });

  // Watch for dynamically added elements (for client-side routing)
  const mutationObserver = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      mutation.addedNodes.forEach((node) => {
        if (node.nodeType === 1 && node.classList.contains('scroll-animated')) {
          // Only observe if not already visible
          if (!node.classList.contains('is-visible')) {
            observer.observe(node);
          }
        }
        // Check children
        if (node.nodeType === 1 && node.querySelectorAll) {
          const newElements = node.querySelectorAll('.scroll-animated');
          newElements.forEach(element => {
            // Only observe if not already visible
            if (!element.classList.contains('is-visible')) {
              observer.observe(element);
            }
          });
        }
      });
    });
  });

  mutationObserver.observe(document.body, {
    childList: true,
    subtree: true
  });
});
