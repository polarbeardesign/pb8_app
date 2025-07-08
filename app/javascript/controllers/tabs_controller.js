import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "content"]

  connect() {
    this.show(this.tabTargets[0]) // Show first tab (Now) by default
  }

  switch(event) {
    const clickedTab = event.currentTarget
    const targetId = clickedTab.id.replace("Tab", "Content")

    // Hide all content panels
    this.contentTargets.forEach((content) => content.classList.add("hidden"))

    // Remove active style from all tabs
    this.tabTargets.forEach((tab) => tab.classList.remove("bg-slate-700"))

    // Show the selected content panel
    document.getElementById(targetId)?.classList.remove("hidden")

    // Add active style to clicked tab
    clickedTab.classList.add("bg-slate-700")


  }

  show(tab) {
    const event = { currentTarget: tab }
    this.switch(event)
  }
}
