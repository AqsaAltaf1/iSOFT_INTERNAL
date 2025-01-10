import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password-toggle"
export default class extends Controller {
  connect() {
    $("#visi--off").show();
    $("#visi--off").click(function () {
      $("#visi--on").show();
      $("#visi--off").hide();
      $("#user_password").attr("type", "text");
    });
    $("#visi--on").click(function () {
      $("#visi--off").show();
      $("#visi--on").hide();
      $("#user_password").attr("type", "password");
    });
    $("#con-visi--off").show();
    $("#con-visi--off").click(function () {
      $("#con-visi--on").show();
      $("#con-visi--off").hide();
      $("#user_password_confirmation").attr("type", "text");
    });
    $("#con-visi--on").click(function () {
      $("#con-visi--on").hide();
      $("#con-visi--off").show();
      $("#user_password_confirmation").attr("type", "password");
    });
   
  }
  
  password(e) {
    var password_field = $(e.currentTarget).prev("input")[0];
    var icon = $(e.currentTarget).closest("svg")[0];

    if (password_field.type === "password") {
      icon.classList.remove('fa-eye-slash');
      icon.classList.add('fa-eye');
      password_field.type = "text";
    } else {
      icon.classList.remove('fa-eye');
      icon.classList.add('fa-eye-slash');
      password_field.type = "password";
    }
  }
}
