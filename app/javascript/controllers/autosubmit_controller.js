import { Controller } from "@hotwired/stimulus"

// Submit the form as soon as a field changes (checkbox toggles, selects).
export default class extends Controller {
  submit() {
    this.element.requestSubmit()
  }
}
