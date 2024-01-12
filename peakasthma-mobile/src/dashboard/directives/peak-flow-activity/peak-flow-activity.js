angular.module('dashboard').directive('peakFlowActivity', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
          peakFlow: '=',
          colorMap: '='
        },
        templateUrl: 'src/dashboard/directives/peak-flow-activity/peak-flow-activity.html'
    };
});
