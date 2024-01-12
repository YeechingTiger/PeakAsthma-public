angular.module('dashboard').controller('DashboardMedicationsCtrl',function($scope, prescriptionService){

  $scope.shownPrescriptions = 3;
  $scope.prescriptions = prescriptionService.prescriptions;
  console.log($scope.prescriptions);
  $scope.showMorePrescriptions = function() {
    if ($scope.shownPrescriptions < 10) {
      $scope.shownPrescriptions = 10;
      return;
    }

    $scope.shownPrescriptions += 10;
  };

});