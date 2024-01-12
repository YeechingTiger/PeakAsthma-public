angular.module('asthmaZone').controller('ControlMedicationReportModalCtrl',function($scope, $http,apiEndpoints, loginService,$rootScope, peakFlowService, notification, prescriptionService){
  flag = false;
  $scope.notification = notification;
  remind_later_time = processTimeId(loginService.currentUser.remindLaterTime);
  
  $scope.complete = function() {
    $rootScope.spinner.style.display = '';
    prescriptionService.getPrescriptions().then( function(response) {
      console.log(prescriptionService.prescriptions);
      var prescription = prescriptionService.prescriptions[0];
      for (var index in prescriptionService.prescriptions) {
        prescription = prescriptionService.prescriptions[index]
        if (prescription.levels.includes('Green')) {
            peakFlowService.reportPrescriptionTaken(prescription).finally(function() {
              $scope.$dismiss();
            });
            break;
        }
      }
      $scope.$dismiss();
    }).finally(function() {
      $rootScope.spinner.style.display = 'none';
    });
  };
  
  function processTimeId(id) {
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

  $scope.remindLater = function() {
    return $http({
      method: 'GET',
      url: apiEndpoints.medication.reminder_later + remind_later_time+"/green"
    }).then(function successfulRemindLater(response) {
      $scope.$dismiss();
      return response.data;
    }, function failedRemindLater(response) {
      $scope.$dismiss();
      return response.data;
    });
  }
});