angular.module('asthmaZone').controller('YellowzonemedicationinstructionsmodalCtrl',function($scope,loginService, peakFlowService,apiEndpoints,prescription, $http,$rootScope, prescriptionService){
  $scope.model_state = prescription;
  $scope.prescription;
  remind_later_time = processTimeId(loginService.currentUser.remindLaterTime);

  $rootScope.spinner.style.display = '';
  
  prescriptionService.getPrescriptions().then( function(response) {
    prescription = prescriptionService.prescriptions[0];
    for (var index in prescriptionService.prescriptions) {
      prescription = prescriptionService.prescriptions[index]
      if (prescription.levels.includes('Yellow')) {
          console.log(prescription);
          $scope.prescription = prescription;
          break;
      }
    }
  }).finally(function() {
    $rootScope.spinner.style.display = 'none';
  });


  $scope.complete = function() {
    peakFlowService.reportPrescriptionTaken($scope.prescription).finally(function() {
      $scope.$dismiss();
    });
  }

  $scope.remindLater = function() {
    return $http({
      method: 'GET',
      // url: apiEndpoints.medication.reminder_later + remind_later_time+"/yellow"
      url: apiEndpoints.medication.reminder_later + 5 + "/yellow"
    }).then(function successfulRemindLater(response) {
      $scope.$dismiss();
      return response.data;
    }, function failedRemindLater(response) {
      $scope.$dismiss();
      return response.data;
    });
  }
  
  function processTimeId(id) {
    console.log(id);
    switch(id) {
      case 0:
        return 30;
      case 1:
        return 60;
      case 2:
        return 120;
      case 3:
        return 360;
      default:
        return 30;
    }
  }

});