(function() {

  $(document).on('turbolinks:load', function() {
    $('.asthma-page-header .asthma-page-header__button').click(function() {
      var pageWrapper = $('#wrapper');
      var navDrawer = $('.nav-drawer');

      if (navDrawer.css('display') !== 'none') {
        navDrawer.toggleClass('opened');
      }
      else {
        pageWrapper.toggleClass('toggled');
      }
    });
  });

})();
