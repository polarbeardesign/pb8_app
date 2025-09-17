import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  // Toggles the 'open' state of a details element and closes all others.
  toggle(event) {
    const isOpening = event.target.closest("details").open

    // If an item is opening, close all other open items.
    if (!isOpening) {
      this.itemTargets.forEach((item) => {
        if (item !== event.target.closest("details")) {
          item.removeAttribute("open")
        }
      })
    }
  }
}