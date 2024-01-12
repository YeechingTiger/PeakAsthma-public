angular.module('asthmaZone').controller('HowareyoufeelingCtrl', function ($scope, symptomService, $rootScope, asthmaZoneModalManager) {

  $scope.reportSymptoms = function() {
    $rootScope.spinner.style.display = '';
    symptomService.reportSymptoms().finally(function() {
      $rootScope.spinner.style.display = 'none';
      $scope.$dismiss();
    });
  };

  $scope.openDetermineAsthmaZoneModal = function (zone) {
    symptomService.zone = zone;
    asthmaZoneModalManager.determineAsthmaZone();
  };

});