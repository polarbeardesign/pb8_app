import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  static values = { 
    turboFrame: String,
    debounceDelay: { type: Number, default: 300 }
  }
  
  connect() {
    this.timeout = null
    console.log("Filter controller connected")
  }
  
  search() {
    console.log("Search triggered")
    
    // Clear existing timeout to avoid multiple requests
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
    
    // Debounce the search to avoid too many requests
    this.timeout = setTimeout(() => {
      console.log("Submitting form")
      
      const searchValue = this.inputTarget.value
      
      // Build the URL with search parameters
      const url = new URL(this.element.action || window.location.href)
      url.searchParams.set('search', searchValue)
      
      // Get the turbo frame name from data attribute or default
      const turboFrame = this.turboFrameValue || 'list'
      
      // Make a Turbo Stream request
      fetch(url, {
        method: 'GET',
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'Turbo-Frame': turboFrame
        }
      }).then(response => response.text())
        .then(html => {
          // Let Turbo handle the response
          Turbo.renderStreamMessage(html)
        })
        .catch(error => {
          console.error('Search request failed:', error)
        })
        
    }, this.debounceDelayValue)
  }
  
  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
}