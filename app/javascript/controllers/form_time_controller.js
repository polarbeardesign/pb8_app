// app/javascript/controllers/form_time_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startTime", "endTime"]

  connect() {
    // No need to initialize here — we handle it all on submission
    this.element.addEventListener("submit", () => {
      const now = new Date().toISOString()

      // If start_time is blank, it's the first submission
      if (!this.startTimeTarget.value) {
        this.startTimeTarget.value = now
        this.endTimeTarget.value = now
      } else {
        this.endTimeTarget.value = now
      }
    })
  }
}
