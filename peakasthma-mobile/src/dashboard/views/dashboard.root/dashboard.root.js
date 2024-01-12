angular.module('dashboard').controller('DashboardRootCtrl',function($scope,$rootScope, peakFlowService, asthmaZoneModalManager, $http, apiEndpoints ){
  flag = false;
  reward = false;
  $scope.current_week_days = 0;
  $scope.month_reward = 0;
  $scope.survey_data = {};

  $scope.week_reward = function() {
    if ($scope.current_week_days <=5) return $scope.current_week_days * 0.75;
    return 5 * 0.75;
  };
  $scope.barStyle = function() {
    return {
      "width":  $scope.percentage() + "%",
      "background-color": colorMap($scope.percentage())
    }
  };

  function colorMap(value) {
    var color = "#EE2F58";
    if (value == 100) {
      color = "#4BD97A";
    } else if (value >= 50){
      color = "#ffc800"
    }
    return color;
  }

  $scope.percentage = function() {
    if ($scope.current_week_days <=5) return $scope.current_week_days / 5 * 100;
    return 100;
  }

  $scope.getPeakFlows = function() {
    // console.log(peakFlowService.getPeakFlowReports());
    return peakFlowService.getPeakFlowReports();
  }

  $scope.showSvg = function() {
    // return peakFlowService.getPeakFlowReports().length == 0? false : true;
    return flag;
  }

  $scope.toggle = function() {
    flag = !flag;
  }

  $scope.openHowAreYouFeelingModal = function () {
    asthmaZoneModalManager.howAreYouFeeling();
  };

  $scope.week_incentives = function() {
    $rootScope.spinner.style.display = '';
    return $http({
      method: 'GET',
      url: apiEndpoints.incentive.incentive
    }).then(function successfulGetPrescriptions(response) {
      console.log(response.data);
      $scope.month_reward = response.data.monthDays * 0.75;
      $scope.current_week_days = response.data.weekDays;
      return response.data;
    }, function failedGetPrescriptions(response) {
      return response.data;
    }).finally(function() {
      $rootScope.spinner.style.display = 'none';
    })
  }

  $scope.week_incentives();

  $scope.get_survey = function() {
    $rootScope.spinner.style.display = '';
    return $http({
      method: 'GET',
      url: apiEndpoints.survey
    }).then(function successfulGetPrescriptions(response) {
      console.log(response.data);
      $scope.survey_data = response.data;
      return response.data;
    }, function failedGetPrescriptions(response) {
      return response.data;
    }).finally(function() {
      $rootScope.spinner.style.display = 'none';
    })
  }
  $scope.get_survey();

  $scope.link = function () {
      window.open($scope.survey_data.surveyLink, '_system');
  }

  $scope.remain_date = function () {
    var start_date = new Date($scope.survey_data.surveyStartDate);
    var current_date = new Date();
    var Difference_In_Time = current_date.getTime() - start_date.getTime();
    var Difference_In_Days = Math.floor(Difference_In_Time / (1000 * 3600 * 24));
    return 7 - Difference_In_Days;
  }

  $scope.next_survey_countdown = function () {
    var start_date = new Date($scope.survey_data.surveyStartDate);
    var current_date = new Date();
    var Difference_In_Time = current_date.getTime() - start_date.getTime();
    var Difference_In_Days = Math.floor(Difference_In_Time / (1000 * 3600 * 24));
    return 30 - Difference_In_Days;
  }
});
