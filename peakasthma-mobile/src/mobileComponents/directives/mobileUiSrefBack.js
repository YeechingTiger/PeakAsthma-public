angular.module('mobileComponents').directive('mobileUiSrefBack', function(backTransitionService) {
  return {
    priority: 1000,
    restrict: 'A',
    link: function(scope, element, attrs, fn) {
      angular.element(element).on('click touchstart', function() {
        backTransitionService.goBack();
      });
    }
  };
});