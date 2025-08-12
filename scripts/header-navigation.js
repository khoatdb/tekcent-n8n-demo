/**
 * Header Navigation Component
 * Follows Helix principles: Performance-first, Accessible, Progressive Enhancement
 */

class HeaderNavigation {
    constructor() {
        this.header = document.querySelector('.header');
        this.dropdownButton = document.querySelector('.nav-link--dropdown');
        this.dropdownMenu = document.querySelector('.dropdown-menu');
        this.dropdownItem = document.querySelector('.nav-item--dropdown');
        this.mobileToggle = document.querySelector('.mobile-menu-toggle');
        this.navMenu = document.querySelector('.nav-menu');
        
        this.isDropdownOpen = false;
        this.isMobileMenuOpen = false;
        
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.setupA11y();
        this.handleScrollBehavior();
    }

    setupEventListeners() {
        // Dropdown functionality
        if (this.dropdownButton) {
            this.dropdownButton.addEventListener('click', this.toggleDropdown.bind(this));
            this.dropdownButton.addEventListener('keydown', this.handleDropdownKeydown.bind(this));
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', this.handleOutsideClick.bind(this));

        // Keyboard navigation
        document.addEventListener('keydown', this.handleGlobalKeydown.bind(this));

        // Mobile menu toggle
        if (this.mobileToggle) {
            this.mobileToggle.addEventListener('click', this.toggleMobileMenu.bind(this));
        }

        // Window resize handler
        window.addEventListener('resize', this.handleResize.bind(this));

        // Intersection Observer for header background opacity
        if ('IntersectionObserver' in window) {
            this.setupScrollObserver();
        }
    }

    toggleDropdown(event) {
        event.preventDefault();
        event.stopPropagation();
        
        this.isDropdownOpen = !this.isDropdownOpen;
        
        // Update ARIA attributes
        this.dropdownButton.setAttribute('aria-expanded', this.isDropdownOpen.toString());
        this.dropdownItem.setAttribute('data-expanded', this.isDropdownOpen.toString());
        
        if (this.isDropdownOpen) {
            // Focus management - focus first link in dropdown
            setTimeout(() => {
                const firstLink = this.dropdownMenu.querySelector('.dropdown-link');
                if (firstLink) {
                    firstLink.focus();
                }
            }, 100);
        }

        // Analytics tracking
        this.trackEvent('dropdown_toggle', {
            action: this.isDropdownOpen ? 'open' : 'close',
            menu: 'insights'
        });
    }

    closeDropdown() {
        if (!this.isDropdownOpen) return;
        
        this.isDropdownOpen = false;
        this.dropdownButton.setAttribute('aria-expanded', 'false');
        this.dropdownItem.setAttribute('data-expanded', 'false');
        
        // Return focus to dropdown button
        this.dropdownButton.focus();
    }

    handleDropdownKeydown(event) {
        switch (event.key) {
            case 'Escape':
                this.closeDropdown();
                break;
            case 'ArrowDown':
                event.preventDefault();
                if (!this.isDropdownOpen) {
                    this.toggleDropdown(event);
                } else {
                    this.focusNextDropdownItem();
                }
                break;
            case 'ArrowUp':
                event.preventDefault();
                if (this.isDropdownOpen) {
                    this.focusPreviousDropdownItem();
                }
                break;
        }
    }

    handleGlobalKeydown(event) {
        if (event.key === 'Escape' && this.isDropdownOpen) {
            this.closeDropdown();
        }
    }

    handleOutsideClick(event) {
        if (this.isDropdownOpen && this.dropdownItem && !this.dropdownItem.contains(event.target)) {
            this.closeDropdown();
        }
    }

    focusNextDropdownItem() {
        const links = this.dropdownMenu.querySelectorAll('.dropdown-link');
        const currentIndex = Array.from(links).indexOf(document.activeElement);
        const nextIndex = (currentIndex + 1) % links.length;
        links[nextIndex].focus();
    }

    focusPreviousDropdownItem() {
        const links = this.dropdownMenu.querySelectorAll('.dropdown-link');
        const currentIndex = Array.from(links).indexOf(document.activeElement);
        const prevIndex = currentIndex <= 0 ? links.length - 1 : currentIndex - 1;
        links[prevIndex].focus();
    }

    toggleMobileMenu() {
        this.isMobileMenuOpen = !this.isMobileMenuOpen;
        
        // Update ARIA attributes
        this.mobileToggle.setAttribute('aria-expanded', this.isMobileMenuOpen.toString());
        
        // Add/remove mobile menu open class
        document.body.classList.toggle('mobile-menu-open', this.isMobileMenuOpen);
        
        // Prevent body scroll when mobile menu is open
        document.body.style.overflow = this.isMobileMenuOpen ? 'hidden' : '';
        
        this.trackEvent('mobile_menu_toggle', {
            action: this.isMobileMenuOpen ? 'open' : 'close'
        });
    }

    handleResize() {
        // Close mobile menu on desktop
        if (window.innerWidth > 768 && this.isMobileMenuOpen) {
            this.toggleMobileMenu();
        }
        
        // Close dropdown on mobile
        if (window.innerWidth <= 768 && this.isDropdownOpen) {
            this.closeDropdown();
        }
    }

    setupA11y() {
        // Ensure all interactive elements are keyboard accessible
        const interactiveElements = this.header.querySelectorAll('a, button');
        
        interactiveElements.forEach(element => {
            if (!element.hasAttribute('tabindex')) {
                element.setAttribute('tabindex', '0');
            }
        });

        // Add skip link for keyboard users
        this.createSkipLink();
    }

    createSkipLink() {
        const skipLink = document.createElement('a');
        skipLink.href = '#main-content';
        skipLink.textContent = 'Skip to main content';
        skipLink.className = 'skip-link';
        skipLink.style.cssText = `
            position: absolute;
            top: -40px;
            left: 6px;
            background: var(--color-accent);
            color: white;
            padding: 8px;
            text-decoration: none;
            border-radius: 4px;
            z-index: 10000;
            transition: top 0.3s;
        `;
        
        skipLink.addEventListener('focus', () => {
            skipLink.style.top = '6px';
        });
        
        skipLink.addEventListener('blur', () => {
            skipLink.style.top = '-40px';
        });
        
        document.body.insertBefore(skipLink, document.body.firstChild);
    }

    setupScrollObserver() {
        // Create a sentinel element at the top of the page
        const sentinel = document.createElement('div');
        sentinel.style.height = '1px';
        sentinel.style.position = 'absolute';
        sentinel.style.top = '100px';
        document.body.appendChild(sentinel);

        const observer = new IntersectionObserver(
            (entries) => {
                const entry = entries[0];
                if (entry.isIntersecting) {
                    this.header.classList.remove('header--scrolled');
                } else {
                    this.header.classList.add('header--scrolled');
                }
            },
            { threshold: 0 }
        );

        observer.observe(sentinel);
    }

    handleScrollBehavior() {
        let lastScrollY = window.scrollY;
        let ticking = false;

        const updateHeader = () => {
            const currentScrollY = window.scrollY;
            
            if (currentScrollY > 100) {
                this.header.classList.add('header--scrolled');
            } else {
                this.header.classList.remove('header--scrolled');
            }

            // Hide header on scroll down, show on scroll up
            if (currentScrollY > lastScrollY && currentScrollY > 200) {
                this.header.classList.add('header--hidden');
            } else {
                this.header.classList.remove('header--hidden');
            }

            lastScrollY = currentScrollY;
            ticking = false;
        };

        const requestTick = () => {
            if (!ticking) {
                requestAnimationFrame(updateHeader);
                ticking = true;
            }
        };

        window.addEventListener('scroll', requestTick, { passive: true });
    }

    trackEvent(eventName, properties = {}) {
        // Analytics tracking - can be integrated with Google Analytics, Adobe Analytics, etc.
        if (typeof gtag !== 'undefined') {
            gtag('event', eventName, {
                event_category: 'header_navigation',
                ...properties
            });
        }
        
        // Console logging for development
        if (typeof process !== 'undefined' && process.env && process.env.NODE_ENV === 'development') {
            console.log('Header Navigation Event:', eventName, properties);
        }
    }

    // Public API methods for external integration
    openDropdown() {
        if (!this.isDropdownOpen) {
            this.toggleDropdown(new Event('click'));
        }
    }

    closeDropdownPublic() {
        this.closeDropdown();
    }

    getDropdownState() {
        return {
            isOpen: this.isDropdownOpen,
            isMobileMenuOpen: this.isMobileMenuOpen
        };
    }
}

// Enhanced CSS for scroll behaviors
const scrollStyles = `
.header--scrolled {
    background: rgba(30, 41, 59, 0.98);
    backdrop-filter: blur(20px);
    box-shadow: var(--shadow-md);
}

.header--hidden {
    transform: translateY(-100%);
}

.header {
    transition: all 0.3s ease;
}

.skip-link:focus {
    top: 6px !important;
}

@media (max-width: 768px) {
    .mobile-menu-open .nav-menu {
        display: flex;
        flex-direction: column;
        position: fixed;
        top: var(--header-height);
        left: 0;
        right: 0;
        background: rgba(30, 41, 59, 0.98);
        backdrop-filter: blur(20px);
        padding: var(--spacing-lg);
        gap: var(--spacing-md);
        box-shadow: var(--shadow-lg);
        animation: slideDown 0.3s ease;
    }
    
    .mobile-menu-open .nav-cta {
        display: block;
        position: fixed;
        bottom: var(--spacing-lg);
        left: var(--spacing-lg);
        right: var(--spacing-lg);
    }
    
    .mobile-menu-open .cta-button {
        width: 100%;
        justify-content: center;
    }
}

@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
`;

// Inject additional styles
const styleElement = document.createElement('style');
styleElement.textContent = scrollStyles;
document.head.appendChild(styleElement);

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        new HeaderNavigation();
    });
} else {
    new HeaderNavigation();
}

// Export for module systems
if (typeof module !== 'undefined' && module.exports) {
    module.exports = HeaderNavigation;
}

// Add to global scope for direct usage
window.HeaderNavigation = HeaderNavigation;