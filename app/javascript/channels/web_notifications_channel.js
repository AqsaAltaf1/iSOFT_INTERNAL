import consumer from "channels/consumer"

consumer.subscriptions.create("WebNotificationsChannel", {
  connected() {
    console.log("WebNotificationsChannel connected Successfully");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data);
    // Called when there's incoming data on the websocket for this channel
    const contentContainer = document.getElementById("notification_data");
    contentContainer.innerHTML = data.html + contentContainer.innerHTML;
    var unread_count = parseInt($('.value').html()) + 1;
    $('.value').show();
    $('.dropdown-menu-footer').show();
    // $('#mark-all-as-read-button').show();
    // $('.see-all').show();
    if (unread_count > 9) {
      $(".value").html("9+");

    }else{
      $(".value").html(unread_count);
    }
    if (unread_count > 0) {
      $("#alertsDropdown").addClass("has_notification");
    }
    const element = document.getElementById("all_notify_count");
    const allNotifyCount = Number(element.getAttribute("data_read_count"));
    if(allNotifyCount >= 9) {
      $('.dropdown-menu-header').show();
    } else {
        $('.dropdown-menu-header').hide();
    }
    $(".no_notifications").html("");
  }
});