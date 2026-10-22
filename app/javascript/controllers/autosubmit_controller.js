import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    this.element.requestSubmit()
  }

  debounced() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.submit(), 300)
  }
}