import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["collapseContent", "expandIcon"];

  connect() {
    this.collapseContentTarget.classList.add("collapse");
  }

  toggle() {
    this.collapseContentTarget.classList.toggle("show");
    this.expandIconTarget.innerHTML = this.collapseContentTarget.classList.contains("show") ? "expand_less" : "expand_more";
  }
  toggleControllerPermissions(event) {
    const controllerName = event.target.id;
    const permissionCheckboxes = document.querySelectorAll(`[data-controller="${controllerName}"]`);
    permissionCheckboxes.forEach((checkbox) => {
      checkbox.checked = !checkbox.checked;
    });
  }
}