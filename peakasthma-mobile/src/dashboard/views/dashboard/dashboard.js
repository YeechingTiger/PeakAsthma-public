angular.module('dashboard').controller('DashboardCtrl',function($scope, $rootScope, $transitions, $interval, $state, asthmaZoneModalManager, notificationService, $uibModalStack, activityHistoryService, mapService){
  $scope.header = selectHeader($state.current.name);
  
  $transitions.onSuccess({}, function(trans) {
    console.log("statechange start");
    var state =  $state.current.name;
    $scope.header = selectHeader(state);
  });

  $scope.showBtn = function() {
    return $state.current.name === "dashboard.medications";
  }

  $scope.errors = function() {
    return $rootScope.errors;
  }

  $scope.closeError = function() {
    $rootScope.errors = null;
  }

  function selectHeader(state) {
    switch(state) {
      case "dashboard.education":
          return "Education";
      case "dashboard.root":
          return "Welcome to Peak Asthma!";
      case "dashboard.map":
          return "Medical Help Near You";
      case "dashboard.medications":
          return "My Action Plan";
      case "dashboard.notifications":
          return "Notifications";
      case "dashboard.patientProfile":
          return "Patient Information";
      case "dashboard":
          return "Dashboard";
      default:
          return "Welcome to Peak Asthma!";
    }
  }

  $scope.highlightPersonalProfile = function () {
    return $state.includes('dashboard.medications') || $state.includes('dashboard.patientProfile');
  };

  $scope.openHowAreYouFeelingModal = function () {
    asthmaZoneModalManager.howAreYouFeeling();
  };

  mapService.getLocation();
  
  var pollingNotification = notificationService.beginPollingNotifications();
  

  $scope.$on("$destroy", function () {
    if (pollingNotification) {
      $interval.cancel(pollingNotification);
    }
    notificationService.unreadNotifications = [];
    $uibModalStack.dismissAll();
  });
});