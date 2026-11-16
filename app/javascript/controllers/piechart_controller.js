import { Controller } from "@hotwired/stimulus"

// Renders a Google Charts pie chart from [[label, hours], ...] rows.
export default class extends Controller {
  static values = { rows: Array }

  connect() {
    this.load().then(() => this.draw())
  }

  load() {
    if (window.google?.visualization?.PieChart) return Promise.resolve()
    return new Promise((resolve) => {
      const done = () => {
        google.charts.load("current", { packages: ["corechart"] })
        google.charts.setOnLoadCallback(resolve)
      }
      if (window.google?.charts) return done()
      const script = document.createElement("script")
      script.src = "https://www.gstatic.com/charts/loader.js"
      script.onload = done
      document.head.appendChild(script)
    })
  }

  draw() {
    if (!this.element.isConnected) return
    const data = new google.visualization.DataTable()
    data.addColumn("string", "Task")
    data.addColumn("number", "Hours")
    data.addRows(this.rowsValue)
    const options = {
      colors: ["#ceeffa", "#9dd9ed", "#71bfd9", "#4a9fbb", "#2c85a2", "#0e7395"],
      chartArea: { width: "95%", height: "90%" }
    }
    new google.visualization.PieChart(this.element).draw(data, options)
  }
}
