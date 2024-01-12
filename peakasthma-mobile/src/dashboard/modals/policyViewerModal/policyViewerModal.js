angular.module('dashboard').controller('PolicyViewerModalCtrl', function ($scope, $rootScope, $state, $http, $window, apiEndpoints, userService, loginService, accepted) {
  $scope.accepted = accepted;
  $scope.termOfService = false;

  $scope.showTermOfService = function() {
    $scope.termOfService = true;
  }

  $scope.showPolicy = function() {
    $scope.termOfService = false;
  }

  $scope.acceptPolicy = function() {
    $rootScope.spinner.style.display = '';
    userService.acceptPolicy().then(function() {
      $scope.$dismiss();
    }).finally(function() {
      $rootScope.spinner.style.display = 'none';

      $("<style type='text/css'> .modal{ display: flex !important; } </style>").appendTo("head");
      $("<div/>").addClass("modal").appendTo("modal-open");

      if (loginService.currentUser.firstTimeLogin)
        $state.go('walkthrough');
      else
        $state.go('dashboard.root');
    });
  };

  $scope.declinePolicy = function() {
    var login_scope = angular.element('div[ng-controller="LoginCtrl"]').scope();
    login_scope.errors = ['Please accept the privacy policy and terms of service to login.'];
    clearTokens();
    $scope.$dismiss();
    $("<style type='text/css'> .modal{ display: flex !important; } </style>").appendTo("head");
    $("<div/>").addClass("modal").appendTo("modal-open");
  };

  $scope.donePolicy = function() {
    $scope.$dismiss();
    $("<style type='text/css'> .modal{ display: flex !important; } </style>").appendTo("head");
    $("<div/>").addClass("modal").appendTo("modal-open");
  };

  function clearTokens() {
    $http({
      method: 'GET',
      url: apiEndpoints.user.logout,
    }).then(function successfulLogOut(response) {
      console.log(response);
      console.log("Session cleared!");
      $window.localStorage.removeItem('authToken');
      $window.localStorage.removeItem('userId');
      backTransitionService.goBack();
      $state.go('login');
    }, function failedLogOut(response) {
      console.log("Session not cleared!");
    });
  }

});
