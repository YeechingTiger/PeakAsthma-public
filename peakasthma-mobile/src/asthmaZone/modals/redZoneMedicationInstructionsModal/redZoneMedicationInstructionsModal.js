angular.module('asthmaZone').controller('RedzonemedicationinstructionsmodalCtrl',function($scope,$rootScope,peakFlowService, asthmaZoneModalManager, prescription){
  flag = false;
  $scope.prescription = prescription;

  $scope.complete = function() {
    $rootScope.spinner.style.display = '';
    peakFlowService.reportPrescriptionTaken(prescription).finally(function() {
      // asthmaZoneModalManager.updateHowIFeel();
      $rootScope.spinner.style.display = 'none';
      $scope.$dismiss();
    });
  };

});