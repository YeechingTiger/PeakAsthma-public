angular.module('authentication').controller('LoginCtrl',function($scope, loginService, $uibModalStack, $rootScope, $window,  $http, apiEndpoints){

  $scope.user = {};
  $uibModalStack.dismissAll();
  clearTokens();
  $scope.logIn = function() {
    $rootScope.spinner.style.display = '';
    loginService.createSession($scope.user)
      .then(function checkResponse(response) {
        if (response.errors) {
          $scope.errors = response.errors;
        }
      }).finally(function() {
        $rootScope.spinner.style.display = 'none';
      });
  };

  function clearTokens() {
    $http({
          method: 'GET',
          url:  apiEndpoints.user.logout,
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

  $scope.closeError = function closeError() {
    $scope.errors = null;
    console.log("Close errors");
  }
});