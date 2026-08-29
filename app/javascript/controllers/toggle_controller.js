import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "content"]
  static values = { hiddenText: String, shownText: String }

  toggle() {
    const isHidden = this.contentTarget.classList.toggle("hidden")
    this.buttonTarget.textContent = isHidden ? this.hiddenTextValue : this.shownTextValue
  }
}