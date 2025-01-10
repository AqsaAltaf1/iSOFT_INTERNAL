import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview"
export default class extends Controller {
  connect() {
    console.log('image')
  }

  preview(event) {
    const input = event.target;
    const preview = document.getElementById('image-preview');
    const file = input.files[0];
    const reader = new FileReader();

    reader.onloadend = () => {
      preview.src = reader.result;
      preview.style.display = 'block';
    };

    if (file) {
      reader.readAsDataURL(file);
    } else {
      preview.src = '#';
    }
  }
}
