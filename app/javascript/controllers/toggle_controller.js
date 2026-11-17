import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "content", "label"]
  static values = { hiddenText: String, shownText: String }

  connect() {
    this.sync()
  }

  toggle() {
    this.setExpanded(this.contentTarget.hidden)
  }

  close() {
    this.setExpanded(false)
  }

  setExpanded(expanded) {
    this.contentTarget.hidden = !expanded
    this.sync()

    if (expanded) {
      const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches
      requestAnimationFrame(() => {
        this.contentTarget.scrollIntoView({
          behavior: reduceMotion ? "auto" : "smooth",
          block: "nearest"
        })
      })
      this.contentTarget
        .querySelector("input:not([type='hidden']):not([type='submit']), textarea, select")
        ?.focus()
    } else {
      this.buttonTarget.focus()
    }
  }

  sync() {
    const expanded = !this.contentTarget.hidden
    this.buttonTarget.setAttribute("aria-expanded", String(expanded))
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = expanded ? this.shownTextValue : this.hiddenTextValue
    }
  }
}
