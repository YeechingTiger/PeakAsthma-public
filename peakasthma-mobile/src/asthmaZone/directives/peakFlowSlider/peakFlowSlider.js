angular.module('asthmaZone').directive('peakFlowSlider', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
          peakFlow: '='
        },
        templateUrl: 'src/asthmaZone/directives/peakFlowSlider/peakFlowSlider.html',
        link: function(scope, element, attrs, fn) {
          var previousTouchX = null;
          var dampening = attrs.dampening || 0.5;
          var maxValue = attrs.max || 700;
          var minValue = attrs.min || 0;

          element.on('touchmove', function(e) {
            var newTouchX = Math.round(e.originalEvent.targetTouches[0].screenX * dampening);

            if (previousTouchX !== null) {
              scope.$apply(function() {
                scope.peakFlow.score += newTouchX - previousTouchX;

                if (scope.peakFlow.score < minValue) {
                  scope.peakFlow.score = parseInt(minValue, 10);
                }

                if (scope.peakFlow.score > maxValue) {
                  scope.peakFlow.score = parseInt(maxValue, 10);
                }
              });
            }

            previousTouchX = newTouchX;
          });

          element.on('touchstart', function(e) {
            previousTouchX = Math.round(e.originalEvent.targetTouches[0].screenX * dampening);
          });

          element.on('touchend', function() {
            previousTouchX = null;
          });

        }
    };
});
