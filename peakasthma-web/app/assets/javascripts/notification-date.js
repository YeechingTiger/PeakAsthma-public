(function() {
  $(document).on('turbolinks:load', function() {
    var hiddenNode = $('#notification_send_at');
    var datetimeNode = $('#notification_datetime_send_at');
    var initialDate = new Date(hiddenNode.val());

    if (initialDate) {
      datetimeNode.val(formatDate(initialDate));
    }
    
    datetimeNode.change(setHiddenValue);

    function setHiddenValue() {
      var newDateTime = new Date(datetimeNode.val());
      hiddenNode.val(newDateTime);
    }

    function formatDate(date) {
      var month = date.getMonth() + 1;
      month = month < 10 ? '0' + month : month;
      var day = date.getDate() < 10 ? '0' + date.getDate() : date.getDate();
      var calendar_date = date.getFullYear() + '-' + month + '-' + day;
      var hour = date.getHours() < 10 ? '0' + date.getHours() : date.getHours();
      var minutes = date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes();
      var time = hour + ':' + minutes;

      return calendar_date + 'T' + time;
    }

  });

  $(document).on('turbolinks:load', function() {
    var hiddenNode = $('#patient_medication_reminder_time');
    var datetimeNode = $('#patient_time_medication_reminder_time');
    var initialDate = new Date(hiddenNode.val());
    var current_time = new Date();
    var calendar_date;


    if (initialDate) {
      datetimeNode.val(formatDate(current_time, initialDate));
    }
    
    datetimeNode.change(setHiddenValue);

    function setHiddenValue() {
      var newDateTime = new Date(calendar_date + "T" + datetimeNode.val());
      hiddenNode.val(newDateTime);
    }

    function formatDate(current_time, date) {
      var month = current_time.getMonth() + 1;
      month = month < 10 ? '0' + month : month;
      var day = current_time.getDate() < 10 ? '0' + current_time.getDate() : current_time.getDate();
      calendar_date = current_time.getFullYear() + '-' + month + '-' + day;
      var hour = date.getHours() < 10 ? '0' + date.getHours() : date.getHours();
      var minutes = date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes();
      var time = hour + ':' + minutes;
      // return calendar_date + 'T' + time;
      return time;
    }

  });

  $(document).on('turbolinks:load', function() {
    var hiddenNode = $('#patient_report_reminder_time');
    var datetimeNode = $('#patient_time_report_reminder_time');
    var initialDate = new Date(hiddenNode.val());
    var current_time = new Date();
    var calendar_date;


    if (initialDate) {
      datetimeNode.val(formatDate(current_time, initialDate));
    }
    
    datetimeNode.change(setHiddenValue);

    function setHiddenValue() {
      var newDateTime = new Date(calendar_date + "T" + datetimeNode.val());
      hiddenNode.val(newDateTime);
    }

    function formatDate(current_time, date) {
      var month = current_time.getMonth() + 1;
      month = month < 10 ? '0' + month : month;
      var day = current_time.getDate() < 10 ? '0' + current_time.getDate() : current_time.getDate();
      calendar_date = current_time.getFullYear() + '-' + month + '-' + day;
      var hour = date.getHours() < 10 ? '0' + date.getHours() : date.getHours();
      var minutes = date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes();
      var time = hour + ':' + minutes;
      // return calendar_date + 'T' + time;
      return time;
    }

  });

  $(document).on('turbolinks:load', function () {
    var hiddenNode = $('#control_notification_send_at');
    var datetimeNode = $('#control_notification_datetime_send_at');
    var initialDate = new Date(hiddenNode.val());

    if (initialDate)
      datetimeNode.val(formatDate(initialDate));

    datetimeNode.change(setHiddenValue);

    function setHiddenValue() {
      var newDateTime = new Date(datetimeNode.val());
      hiddenNode.val(newDateTime);
    }

    function formatDate(date) {
      var month = date.getMonth() + 1;
      month = month < 10 ? '0' + month : month;
      var day = date.getDate() < 10 ? '0' + date.getDate() : date.getDate();
      var calendar_date = date.getFullYear() + '-' + month + '-' + day;
      var hour = date.getHours() < 10 ? '0' + date.getHours() : date.getHours();
      var minutes = date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes();
      var time = hour + ':' + minutes;

      return calendar_date + 'T' + time;
    }
  });

  $(document).on('turbolinks:load', function () {
    var hiddenNode = $('#control_patient_daily_reminder_time');
    var datetimeNode = $('#control_patient_time_daily_reminder_time');
    var initialDate = new Date(hiddenNode.val());
    var current_time = new Date();
    var calendar_date;

    if (initialDate) {
      datetimeNode.val(formatDate(current_time, initialDate));
    }

    datetimeNode.change(setHiddenValue);

    function setHiddenValue() {
      var newDateTime = new Date(calendar_date + "T" + datetimeNode.val());
      hiddenNode.val(newDateTime);
    }

    function formatDate(current_time, date) {
      var month = current_time.getMonth() + 1;
      month = month < 10 ? '0' + month : month;
      var day = current_time.getDate() < 10 ? '0' + current_time.getDate() : current_time.getDate();
      calendar_date = current_time.getFullYear() + '-' + month + '-' + day;
      var hour = date.getHours() < 10 ? '0' + date.getHours() : date.getHours();
      var minutes = date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes();
      var time = hour + ':' + minutes;
      // return calendar_date + 'T' + time;
      return time;
    }

  });

})();


