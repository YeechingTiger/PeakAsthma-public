(function() {
  $(document).on('turbolinks:load', function() {

    $('[data-dynamic-view-control]').change(function(e) {
      var targetView = $($(e.target).data('dynamic-view-control')).filter('[data-dynamic-view="true"]');
      if (!targetView) {
        return;
      }

      $.get(targetView.data('dynamic-view-url'), {
          dynamic_view: {
            id: e.target.value,
          },
          turbolinks: false
        }).done(function success(layout) {
          if (layout.indexOf('<html>') >= 0) {
            return window.location.reload();
          }

          targetView.html(layout);
        });
    });

  });
})();
