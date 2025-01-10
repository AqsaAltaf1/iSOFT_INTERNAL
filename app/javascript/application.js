// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require cocoon
//= require jquery_ujs
//= require select2
//= require select2-full
import "@hotwired/turbo-rails";
import "controllers";
import "@popperjs/core";
import "bootstrap";
import "jquery";
import { far } from "@fortawesome/free-regular-svg-icons";
import { fas } from "@fortawesome/free-solid-svg-icons";
import { fab } from "@fortawesome/free-brands-svg-icons";
import { library } from "@fortawesome/fontawesome-svg-core";
import "@fortawesome/fontawesome-free";
import "channels";
library.add(far, fas, fab);

import "channels";
// application.js
import "trix";
import "@rails/actiontext";

(function ($) {
  "use strict";

  var fullHeight = function () {
    $(".js-fullheight").css("height", $(window).height());
    $(window).resize(function () {
      $(".js-fullheight").css("height", $(window).height());
    });
  };
  fullHeight();
  $(".side_text").hide();
  $("#sidebarCollapse").on("click", function () {
    $("#sidebar").toggleClass("active");
    if ($("#sidebar").hasClass("active")) {
      $(".side_text").hide();
    } else {
      $(".side_text").show();
    }
  });
})(jQuery);
function startTime() {
  const today = new Date();
  let h = today.getHours();
  let ms = "";
  if (h >= 12) {
    h = h - 12;
    ms = "PM";
  } else {
    ms = "AM";
  }
  let m = today.getMinutes();
  let s = today.getSeconds();
  m = checkTime(m);
  s = checkTime(s);
  document.getElementById("txt").innerHTML = h + ":" + m + ":" + s + "  " + ms;
  setTimeout(startTime, 1000);
}

function checkTime(i) {
  if (i < 10) {
    i = "0" + i;
  } // add zero in front of numbers < 10
  return i;
}
(function () {
  if (document.getElementsByClassName("js-simplebar")[0]) {
    var e = new Ja(document.getElementsByClassName("js-simplebar")[0]);
    document
      .querySelectorAll(".js-sidebar [data-bs-parent]")
      .forEach(function (t) {
        t.addEventListener("shown.bs.collapse", function () {
          e.recalculate();
        }),
          t.addEventListener("hidden.bs.collapse", function () {
            e.recalculate();
          });
      });
  }
}),
  function () {
    var e = document.getElementsByClassName("js-sidebar")[0],
      t = document.getElementsByClassName("js-sidebar-toggle")[0];
    e &&
      t &&
      t.addEventListener("click", function () {
        e.classList.toggle("collapsed"),
          e.addEventListener("transitionend", function () {
            window.dispatchEvent(new Event("resize"));
          });
      });
  };
$(".sidebar-toggle").click(function () {
  $("#sidebar").toggleClass("collapsed");
});

$(".password, .password-confirmation").on("keyup", function () {
  if ($(".password").val() == $(".password-confirmation").val()) {
    $(".password-message").html("Password Matched").css("color", "green");
    $(".register-button").prop("disabled", false);
  } else {
    $(".password-message").html("Password Not Matching").css("color", "red");
    $(".register-button").prop("disabled", true);
  }
});

window.addEventListener('popstate', function(event) {
  // Reload the page when browser back arrow is clicked
  location.reload();
});
