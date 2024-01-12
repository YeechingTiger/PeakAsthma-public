angular.module('mobileComponents').directive('mobileUiViewBackTransition', function($animate, backTransitionService) {
  return {
    restrict: 'A',
    link: function(scope, element) {
      scope.getTransitionServiceStatus = function() {
        return backTransitionService.backTransition;
      };

      scope.$watch('getTransitionServiceStatus()', function(isBackTransition) {
        if (isBackTransition) {
          element.addClass('back-transition');
        }
        else {
          element.removeClass('back-transition');
        }
      });

      function checkTransition(transitionElement, phase) {
        if (phase === 'start' || !transitionElement.is(element)) {
          return;
        }

        backTransitionService.clearBackTransition();
      }

      $animate.on('leave', element, checkTransition);
      scope.$on('$destroy', function() {
        if (backTransitionService.backTransition) {
          element.addClass('back-transition');
        }
        else {
          element.removeClass('back-transition');
        }
      });
    }
  };
});