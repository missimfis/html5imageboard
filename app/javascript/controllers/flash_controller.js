import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => this.element.classList.add("hidden"), 7000)
  }
}