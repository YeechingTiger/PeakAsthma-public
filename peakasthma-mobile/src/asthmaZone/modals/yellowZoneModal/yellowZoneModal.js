angular.module('asthmaZone').controller('YellowzonemodalCtrl',function($scope, asthmaZoneModalManager, prescription){

  $scope.prescription = prescription;

  $scope.openInstructionModal = function() {
    asthmaZoneModalManager.yellowZoneMedicationInstructionsModal({
      prescription: prescription
    });
    $scope.$dismiss();
  };

});