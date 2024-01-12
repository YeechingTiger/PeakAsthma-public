angular.module('asthmaZone').controller('RedzonemodalCtrl',function($scope, asthmaZoneModalManager, prescription){

  $scope.openInstructionModal = function() {
    asthmaZoneModalManager.redZoneMedicationInstructionsModal({
      prescription: prescription
    });
    $scope.$dismiss();
  };

});