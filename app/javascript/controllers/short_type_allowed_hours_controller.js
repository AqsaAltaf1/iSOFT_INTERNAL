import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="short-type-allowed-hours"
export default class extends Controller {
  connect() {
   this.hoursfield();
  }

  hoursfield(){
    const leaveType = $("#apply_leave_allowed_leave_type").val().toLowerCase();
    $(".shorttime").toggle(leaveType === "short");
    $(".shorttime").toggle(leaveType !== "short" || leaveType == null);
    $(".allowedhours").toggle(leaveType === "short");
    $(".alloweddays").toggle(leaveType !== "short" || leaveType == null);
  }
}
