/**
 * Minimal theme switcher
 *
 * Pico.css - https://picocss.com
 * Copyright 2019-2023 - Licensed under MIT
 */

/**
 * Minimal theme switcher
 *
 * @namespace
 */
export const ThemeSwitcher = {
    // Config
    _scheme: 'auto',
    menuTarget: "details[role='list']",
    buttonsTarget: 'a[data-theme-switcher]',
    buttonAttribute: 'data-theme-switcher',
    rootAttribute: 'data-theme',
    localStorageKey: 'picoPreferredColorScheme',

    /**
     * Initialize the theme switcher.
     */
    init() {
        this.scheme = this.schemeFromLocalStorage || this.preferredColorScheme;
        this.initSwitchers();
    },

    /**
     * Get the color scheme from local storage or use the preferred color scheme.
     */
    get schemeFromLocalStorage(): string | null {
        if (typeof window.localStorage !== 'undefined') {
            if (window.localStorage.getItem(this.localStorageKey) !== null) {
                return window.localStorage.getItem(this.localStorageKey);
            }
        }
        return this._scheme;
    },

    /**
     * Get the preferred color scheme based on user preferences.
     */
    get preferredColorScheme(): string {
        return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    },

    /**
     * Initialize the theme switcher buttons and their click events.
     */
    initSwitchers() {
        const buttons = document.querySelectorAll(this.buttonsTarget);
        buttons.forEach((button: HTMLElement) => {
            button.addEventListener(
                'click',
                (event) => {
                    event.preventDefault();
                    // Set scheme
                    this.scheme = button.getAttribute(this.buttonAttribute) || 'auto';
                    // Close dropdown
                    document.querySelector(this.menuTarget)?.removeAttribute('open');
                },
                false
            );
        });
    },

    /**
     * Set the selected color scheme and update the UI.
     *
     * @param {string} scheme - The color scheme to set ("auto", "light", or "dark").
     */
    set scheme(scheme: string) {
        if (scheme === 'auto') {
            this.preferredColorScheme === 'dark' ? (this._scheme = 'dark') : (this._scheme = 'light');
        } else if (scheme === 'dark' || scheme === 'light') {
            this._scheme = scheme;
        }
        this.applyScheme();
        this.schemeToLocalStorage();
    },

    /**
     * Get the current color scheme.
     */
    get scheme(): string {
        return this._scheme;
    },

    /**
     * Apply the selected color scheme to the HTML root element.
     */
    applyScheme() {
        document.querySelector('html')?.setAttribute(this.rootAttribute, this.scheme);
    },

    /**
     * Store the selected color scheme in local storage.
     */
    schemeToLocalStorage() {
        if (typeof window.localStorage !== 'undefined') {
            window.localStorage.setItem(this.localStorageKey, this.scheme);
        }
    },
};
