(function() {
  $(document).on('turbolinks:load', function() {
    $(function () {
      $('[data-toggle="popover"]').popover();
    });
  });
})();
