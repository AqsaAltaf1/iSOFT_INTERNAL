import { Controller } from "@hotwired/stimulus"
import $ from 'jquery';
// Connects to data-controller="short-type-field"
export default class extends Controller {
  static targets = ["allowedLeaveType"]
  connect() {
    $("#shorttime").hide();
    this.handleLeaveTypeChange();
  }

  selectChange(event) {
    this.handleLeaveTypeChange();
  }

  handleLeaveTypeChange() {
    const selectedValue = $("#leave_apply_leave_id").find(":selected").text().toLowerCase();
    $("#shorttime").toggle(selectedValue == "short");
    $(".hours").toggle(selectedValue === 'short');
    $(".shorttype").toggle(selectedValue === "casual" || selectedValue === "sick");
  }
}

