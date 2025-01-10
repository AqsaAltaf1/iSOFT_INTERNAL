import { Controller } from "@hotwired/stimulus"
import $ from 'jquery';
// Connects to data-controller="leave-actions"
export default class extends Controller {
  static targets = ['notes','add_notes'];

  connect() {
    this.notesElement = document.getElementById('notes');
    this.addNotesButton = document.getElementById('add__notes');
    this.hideNotes();
  }

  showNotes() {
    this.notesElement.style.display = 'block';
    this.addNotesButton.style.display = 'none';
  }

  hideNotes() {
    this.notesElement.style.display = 'none';
    this.addNotesButton.style.display = 'block';
  }
}
