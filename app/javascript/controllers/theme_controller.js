import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "imageboard-theme"
const DARK_THEME = "imageboard"
const LIGHT_THEME = "imageboard-light"
const LEGACY_THEMES = { dark: DARK_THEME, light: LIGHT_THEME }

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.colorScheme = window.matchMedia("(prefers-color-scheme: light)")
    this.apply(this.storedTheme() || this.systemTheme(), { persist: false })
    this.colorScheme.addEventListener("change", this.handleSystemChange)
  }

  disconnect() {
    this.colorScheme?.removeEventListener("change", this.handleSystemChange)
  }

  toggle() {
    const current = document.documentElement.dataset.theme
    this.apply(current === LIGHT_THEME ? DARK_THEME : LIGHT_THEME)
  }

  handleSystemChange = (event) => {
    if (!this.storedTheme()) this.apply(event.matches ? LIGHT_THEME : DARK_THEME, { persist: false })
  }

  systemTheme() {
    return this.colorScheme.matches ? LIGHT_THEME : DARK_THEME
  }

  apply(theme, { persist = true } = {}) {
    const normalized = this.normalizeTheme(theme)
    document.documentElement.dataset.theme = normalized
    if (persist) this.storeTheme(normalized)

    const meta = document.querySelector('meta[name="theme-color"]')
    if (meta) meta.content = normalized === LIGHT_THEME ? "#f6f8fb" : "#0b0f14"

    if (this.hasButtonTarget) {
      const nextTheme = normalized === LIGHT_THEME ? "dark" : "light"
      this.buttonTarget.setAttribute("aria-label", `Switch to ${nextTheme} theme`)
    }
  }

  normalizeTheme(theme) {
    const normalized = LEGACY_THEMES[theme] || theme
    return normalized === LIGHT_THEME ? LIGHT_THEME : DARK_THEME
  }

  storedTheme() {
    try {
      const stored = localStorage.getItem(STORAGE_KEY)
      return stored ? this.normalizeTheme(stored) : null
    } catch {
      return null
    }
  }

  storeTheme(theme) {
    try {
      localStorage.setItem(STORAGE_KEY, theme)
    } catch {
      // Local storage can be unavailable in private browsing; the toggle still works for this visit.
    }
  }
}
