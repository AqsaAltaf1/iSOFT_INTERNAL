import { Controller } from "@hotwired/stimulus"
import { Tooltip } from "bootstrap"
// Connects to data-controller="toltip"
export default class extends Controller {
  connect() {
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new Tooltip(tooltipTriggerEl))
  }
}
