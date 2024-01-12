angular.module('asthmaZone').controller('DetermineasthmazoneCtrl',function($scope, asthmaZoneModalManager){

  $scope.recordSymptoms = function() {
    asthmaZoneModalManager.howAreYouFeeling();
    $scope.$dismiss();
  };

  $scope.recordPeakFlow = function() {
    asthmaZoneModalManager.recordPeakFlow();
    $scope.$dismiss();
  };

});