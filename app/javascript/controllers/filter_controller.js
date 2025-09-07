import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  
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
      
      // Create a new FormData object with the search parameter
      const formData = new FormData(this.element)
      const searchValue = this.inputTarget.value
      
      // Build the URL with search parameters
      const url = new URL(this.element.action)
      url.searchParams.set('search', searchValue)
      
      // Make a Turbo Stream request
      fetch(url, {
        method: 'GET',
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'Turbo-Frame': 'posts_list'
        }
      }).then(response => response.text())
        .then(html => {
          // Let Turbo handle the response
          Turbo.renderStreamMessage(html)
        })
        .catch(error => {
          console.error('Search request failed:', error)
        })
        
    }, 300) // 300ms delay
  }
  
  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
}