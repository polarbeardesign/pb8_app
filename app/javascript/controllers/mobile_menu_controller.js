// app/javascript/controllers/mobile_menu_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("mobile-menu controller connected", this.element)
  }

  toggle(event) {
    console.log("mobile-menu.toggle invoked", event)
    // toggle open state for hamburger animation
    this.element.classList.toggle("open")

    // find panel by id or data attribute — safe query, won't throw
    const panel = document.querySelector("#mobile-menu-panel") || document.querySelector("[data-mobile-menu-panel]")
    if (!panel) {
      console.log("mobile-menu: no panel found (ok if you don't use a panel)")
      return
    }

    // slide open/close via max-height classes
    const isClosed = panel.classList.contains("max-h-0")
    if (isClosed) {
      panel.classList.remove("max-h-0", "opacity-0")
      panel.classList.add("max-h-96", "opacity-100")
    } else {
      panel.classList.remove("max-h-96", "opacity-100")
      panel.classList.add("max-h-0", "opacity-0")
    }
  }
}
