import { Controller } from "@hotwired/stimulus"

const DEFAULT_DELAY = 7000
const LEAVE_DURATION = 180

export default class extends Controller {
  static values = { delay: { type: Number, default: DEFAULT_DELAY } }

  connect() {
    this.schedule()
  }

  disconnect() {
    this.clearTimers()
  }

  pause() {
    clearTimeout(this.hideTimer)
  }

  resume() {
    this.schedule()
  }

  dismiss() {
    this.clearTimers()
    this.element.classList.add("flash--leaving")
    this.removeTimer = setTimeout(() => this.element.remove(), LEAVE_DURATION)
  }

  schedule() {
    clearTimeout(this.hideTimer)
    this.hideTimer = setTimeout(() => this.dismiss(), this.delayValue)
  }

  clearTimers() {
    clearTimeout(this.hideTimer)
    clearTimeout(this.removeTimer)
  }
}
