import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loan-type"
export default class extends Controller {
  
  connect() {
    $(".fund-loan-type").hide();
    $(".loan-recovery").show();
  }

  selectChange(event){
    const selectedValue = $("#request_details_loan_type").find(":selected").text()
    if (selectedValue == 'Provident Fund') {
      $(".fund-loan-type").show();
    } else {
      $(".fund-loan-type").hide();
    }
  }

  loanChange(event){
    if ($('#request_details_fund_loan_type_true').is(':checked')) {
      $(".loan-recovery").hide();
      $(".recovery_loan_amount").hide();
      $(".payment_start_date").hide();
      $("#request_details_payment_start_date").prop("required", false)
      $("#request_details_installment_amount").prop("required", false)
      $("#request_details_recovery_method").prop("required", false)
      $("#request_details_recovery_loan_amount").prop("required", false)
    } else {
      $(".loan-recovery").show();
      $(".recovery_loan_amount").show();
      $(".payment_start_date").show();
    }
  }

}
