import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="time-policy-rules"
export default class extends Controller {
  connect() {
    console.log("time_policy")
    this.hideAllPolicies();
    this.showElementById("employee_group_employees_form");
  }

  employeeGroup(event){
    event.preventDefault();
    this.hideAllPolicies();
    this.showElementById("employee_group_employees_form");
  }

  timePolicy(event){
    event.preventDefault();
    console.log("time")
    this.hideAllPolicies();
    this.showElementById("employees_time_policy_form");
    $("#missing_attendance_leaves").hide()
  }

  time(event){
    event.preventDefault();
    var a = event.target.getAttribute('data-value')
    if (a == "true"){
      $("#missing_attendance_leaves").show()
    }
    else{
      $("#missing_attendance_leaves").hide()
    }
  }
  
  lateArrival(event){
    event.preventDefault();
    this.hideAllPolicies();
    this.showElementById("late_arrival_time_policy");
    $("#late_arrival_deduction_first").hide()
    $("#late_arrival_deduct_leave_type").hide()
    $("#employee_group_time_policy_attributes_late_arrival_after_time").attr("readonly","true");
    var a = event.target.getAttribute('data-value')
    var deduction = event.target.getAttribute('data-type')
    if (a == "true"){
      $("#late_arrival_deduction_first").show()
      $("#employee_group_time_policy_attributes_late_arrival_after_time").removeAttr("readonly");
    }
    if(a == "false"){
      $("#late_arrival_deduction_first").hide()
      $("#late_arrival_deduct_leave_type").hide()
    }
    
    if (deduction == "include"){
      $("#late_arrival_deduct_leave_type").show()
      $("#late_arrival_deduction_first").show()
      $("#employee_group_time_policy_attributes_late_arrival_after_time").removeAttr("readonly");
    }
    if(deduction == "exclude"){
      $("#late_arrival_deduct_leave_type").hide()
      $("#late_arrival_deduction_first").show()
      $("#employee_group_time_policy_attributes_late_arrival_after_time").removeAttr("readonly");
    }
  }

  earlyOut(event){
    event.preventDefault();
    this.hideAllPolicies();
    this.showElementById("early_out_time_policy");
    $("#early_out_deduction_first").hide()
    $("#early_out_deduct_leave_type").hide()
    $("#employee_group_time_policy_attributes_early_out_after_time").attr("readonly","true");
    var a = event.target.getAttribute('data-value')
    var deduction = event.target.getAttribute('data-type')
    if (a == "true"){
      $("#early_out_deduction_first").show()
      $("#employee_group_time_policy_attributes_early_out_after_time").removeAttr("readonly");
    }
    if(a == "false"){
      $("#early_out_deduction_first").hide()
      $("#early_out_deduct_leave_type").hide()
    }
    
    if (deduction == "include"){
      $("#early_out_deduct_leave_type").show()
      $("#early_out_deduction_first").show()
      $("#employee_group_time_policy_attributes_early_out_after_time").removeAttr("readonly");
    }
    if(deduction == "exclude"){
      $("#early_out_deduct_leave_type").hide()
      $("#early_out_deduction_first").show()
      $("#employee_group_time_policy_attributes_early_out_after_time").removeAttr("readonly");
    }
  }

  hoursInDay(event){
    console.log("hours")
    event.preventDefault();
    this.hideAllPolicies();
    this.showElementById("hours_per_day_time_policy");
    $("#employee_group_time_policy_attributes_hours_per_day_deduct_days").attr("readonly","true");
    $("#employee_group_time_policy_attributes_hours_per_day_working_hours").attr("readonly","true");
    var a = event.target.getAttribute('data-value')
    if (a == "true"){
      $("#employee_group_time_policy_attributes_hours_per_day_deduct_days").removeAttr("readonly");
      $("#employee_group_time_policy_attributes_hours_per_day_working_hours").removeAttr("readonly");
    }
    if(a == "false"){
      $("#employee_group_time_policy_attributes_hours_per_day_deduct_days").attr("readonly","true");
      $("#employee_group_time_policy_attributes_hours_per_day_working_hours").attr("readonly","true");
    }
  }

  missingSwipe(event){
    event.preventDefault();
    this.hideAllPolicies();
    this.showElementById("missing_swipe_time_policy");
    $("#missing_swipe_leaves").hide()
    $("#missing_swipe_deduction_first").hide()
    var a = event.target.getAttribute('data-value')
    console.log(a)
    if (a == "true"){
      $("#missing_swipe_leaves").show()
    $("#missing_swipe_deduction_first").show()
    }
    if(a == "false"){
      $("#missing_swipe_leaves").hide()
    $("#missing_swipe_deduction_first").hide()
    }
  }

  overTimePolicy(event){
    event.preventDefault();
    this.hideAllPolicies();
    this.showElementById("overtime_time_policy");
  }

  hideAllPolicies() {
    const policies = [
      "employees_time_policy_form",
      "late_arrival_time_policy",
      "early_out_time_policy",
      "hours_per_day_time_policy",
      "missing_swipe_time_policy",
      "overtime_time_policy",
      "employee_group_employees_form"
    ];
    policies.forEach(id => {
      const element = document.getElementById(id);
      if (element) element.style.display = "none";
    });
  }

  showElementById(id) {
    const element = document.getElementById(id);
    if (element) element.style.display = "block";
  }
}
