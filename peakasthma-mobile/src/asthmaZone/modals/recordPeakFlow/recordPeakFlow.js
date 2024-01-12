angular.module('asthmaZone').controller('RecordpeakflowCtrl',function($scope, peakFlowService, loginService, $rootScope){

  $scope.peakFlow = {
    score: 270,
    minimum: loginService.currentUser.peakFlowLow,
    maximum: loginService.currentUser.peakFlowHigh
  };

  $scope.reportPeakFlow = function() {
    $rootScope.spinner.style.display = '';
    console.log($rootScope.spinner);
    peakFlowService.reportPeakFlow($scope.peakFlow.score).then(function() {
      $scope.$dismiss();
    }).finally(function() {
      $rootScope.spinner.style.display = 'none';
    });
  }

});