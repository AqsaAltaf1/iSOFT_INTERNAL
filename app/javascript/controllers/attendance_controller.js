import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("attendance");
  }
  submit(event){
    event.target.form.requestSubmit();
  }
}