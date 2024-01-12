angular.module('asthmaZone').controller('SymptomsCtrl',function($scope, $state, symptomService, $rootScope){

  $scope.level = $state.params.level;
  $scope.symptoms = symptomService.symptoms;
  $scope.selectedSymptoms = [];
  $scope.zone = symptomService.zone;
  $scope.slected_category = [];
  $scope.toggleCategory = function(category) {
    if ($scope.slected_category.indexOf(category) >= 0) {
      return $scope.slected_category.splice($scope.slected_category.indexOf(category), 1);
    }
    $scope.slected_category.push(category);
  }

  $scope.expansion_btn = function(category) {
    if ($scope.slected_category.indexOf(category) >= 0) {
      return false;
    } else {
      return true;
    }
  }

  $scope.toggleSelect = function(symptom) {
    if ($scope.selectedSymptoms.indexOf(symptom) >= 0) {
      return $scope.selectedSymptoms.splice($scope.selectedSymptoms.indexOf(symptom), 1);
    }
    symptom.emergency = symptom.emergency + "";
    $scope.selectedSymptoms.push(symptom);
    console.log($scope.selectedSymptoms);
  };

  $scope.reportSymptoms = function() {
    $rootScope.spinner.style.display = '';
    console.log($scope.selectedSymptoms);
    symptomService.reportSymptoms($scope.selectedSymptoms).finally(function() {
      $rootScope.spinner.style.display = 'none';
    });
  };

});