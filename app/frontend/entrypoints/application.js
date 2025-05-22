// app/frontend/entrypoints/application.js

// Import our custom CSS first
import "../styles/application.css";

// Import Tabler CSS and JS
import "@tabler/core/dist/css/tabler.min.css";
import "@tabler/core/dist/css/tabler-flags.min.css";
import "@tabler/core/dist/css/tabler-payments.min.css";
import "@tabler/core/dist/css/tabler-vendors.min.css";
import "@tabler/core/dist/css/tabler-themes.min.css";
import "@tabler/core/dist/js/tabler.min.js";

// Import and initialize Turbo
import * as Turbo from "@hotwired/turbo"
Turbo.session.drive = true; // Enable Turbo Drive

// Theme initialization - works with both initial page load and Turbo navigation
document.addEventListener('turbo:load', function() {
  // Initialize Tabler
  console.log('Tabler initialized');
  
  // Dark mode functionality
  initDarkMode();
});

// Fallback for the first page load
document.addEventListener('DOMContentLoaded', function() {
  if (!window.initialPageLoaded) {
    console.log('Initial page loaded via DOMContentLoaded');
    initDarkMode();
    window.initialPageLoaded = true;
  }
});

/**
 * Initialize dark mode functionality
 */
function initDarkMode() {
  // Clean up previous event listeners to prevent duplicates
  cleanupThemeEventListeners();
  
  const storedTheme = localStorage.getItem('theme') || 
                     (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
  
  // Set initial theme
  setTheme(storedTheme);
  
  // Set up event listeners for theme toggle links
  document.querySelectorAll('[data-bs-toggle="theme"]').forEach(toggle => {
    toggle.themeClickHandler = (e) => {
      e.preventDefault();
      const theme = e.currentTarget.getAttribute('data-bs-theme-value');
      setTheme(theme);
      localStorage.setItem('theme', theme);
    };
    
    toggle.addEventListener('click', toggle.themeClickHandler);
  });
  
  // Listen for system preference changes
  const prefersColorScheme = window.matchMedia('(prefers-color-scheme: dark)');
  
  // Store reference to the handler for later cleanup
  window.themePreferenceHandler = (e) => {
    if (!localStorage.getItem('theme')) {
      setTheme(e.matches ? 'dark' : 'light');
    }
  };
  
  prefersColorScheme.addEventListener('change', window.themePreferenceHandler);
}

/**
 * Clean up theme-related event listeners to prevent duplicates during Turbo navigation
 */
function cleanupThemeEventListeners() {
  // Remove click event listeners from theme toggles
  document.querySelectorAll('[data-bs-toggle="theme"]').forEach(toggle => {
    if (toggle.themeClickHandler) {
      toggle.removeEventListener('click', toggle.themeClickHandler);
      delete toggle.themeClickHandler;
    }
  });
  
  // Remove media query listener if it exists
  if (window.themePreferenceHandler) {
    window.matchMedia('(prefers-color-scheme: dark)')
      .removeEventListener('change', window.themePreferenceHandler);
    delete window.themePreferenceHandler;
  }
}

/**
 * Apply the selected theme to the document
 * @param {string} theme - 'dark' or 'light'
 */
function setTheme(theme) {
  if (theme === 'auto' && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    document.documentElement.setAttribute('data-bs-theme', 'dark');
  } else {
    document.documentElement.setAttribute('data-bs-theme', theme);
  }
  
  // Update visibility of theme toggles
  document.querySelectorAll('[data-bs-toggle="theme"]').forEach(toggle => {
    toggle.classList.remove('active');
    if (toggle.getAttribute('data-bs-theme-value') === theme) {
      toggle.classList.add('active');
    }
  });
  
  // Update theme-specific elements visibility
  document.querySelectorAll('.hide-theme-dark').forEach(el => {
    el.style.display = theme === 'dark' ? 'none' : '';
  });
  
  document.querySelectorAll('.hide-theme-light').forEach(el => {
    el.style.display = theme === 'light' ? 'none' : '';
  });
}

