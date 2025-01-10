// Probably in app/javascript/controllers/extended_character_counter_controller.js

import CharacterCounter from "stimulus-character-counter";

export default class extends CharacterCounter {
  connect() {
    super.connect();
    setTimeout(() => {
      this.textarea = this.element.querySelector("#description-textarea");
      this.submitButton = this.element.querySelector("#submit-button");

      this.toggleSubmitButton();
      this.textarea.addEventListener("input", () => this.toggleSubmitButton());
    }, 0);
  }

  toggleSubmitButton() {
    if (!this.textarea || !this.submitButton) return;

    if (this.count >= 50) {
      this.submitButton.removeAttribute("disabled");
    } else {
      this.submitButton.setAttribute("disabled", "disabled");
    }
  }
}
