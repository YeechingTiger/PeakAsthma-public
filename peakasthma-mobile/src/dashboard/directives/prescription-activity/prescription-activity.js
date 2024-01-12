angular.module('dashboard').directive('prescriptionActivity', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
          activity: '=',
          colorMap: '='
        },
        templateUrl: 'src/dashboard/directives/prescription-activity/prescription-activity.html'
    };
});
