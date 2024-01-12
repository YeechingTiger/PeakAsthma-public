angular.module('authentication').service('loginService', function ($window, $http, apiEndpoints, $state, pushNotificationService, $rootScope, backTransitionService, $uibModal) {

  var _this = this;
  this.currentUser = {};

  this.createSession = function(userCredentials) {
    return $http({
      method: 'POST',
      url: apiEndpoints.user.signIn,
      data: {
        user: userCredentials
      }
    }).then(function successfulLogIn(response) {
      if (response.data.user.patientType === 'patient' && !response.data.user.accountDisabled) {
        _this.currentUser = response.data.user;
        console.log(response.data.user);
        apiEndpoints.setAuthTokens(_this.currentUser.authenticationToken, _this.currentUser.id);
      }
      return response;
    }, function failedLogIn(response) {
      return response;
    }).then(function(response) {
      if (response.data.user && response.data.user.accountDisabled) {
        return {
          errors: ['This account has been disabled.']
        };
      }
      else if (response.data.user && response.data.user.patientType === 'patient') {
        if (!response.data.user.acceptPolicy)
          openPolicyModal(false);
        else {
          if (response.data.user.firstTimeLogin)
            $state.go('walkthrough');
          else
            $state.go('dashboard.root');
        }
        return response.data;
      }
      else if (response.data.user) {
        return {
          errors: ['This is a NutriMap account.']
        };
      } 
      else
        return response.data;
    }, function(response) {
      backTransitionService.goBack();
      $state.go('login');
      return response.data;
    });
  };

  this.getCurrentUser = function() {
    return $http({
      method: 'GET',
      url: apiEndpoints.user.current
    }).then(function successfulUserRegistration(response) {
      _this.currentUser = response.data.user;
      return response.data;
    }, function failedUserRegistration(response) {
      backTransitionService.goBack();      
      $state.go('login');
      return response.data;
    });
  };
  

  this.getCookie = function() {
    cookie_value = null;
    $window.cookieMaster.getCookieValue("http://18.144.5.42/", "_rails_app_session", 
      function(data) {
          console.log('Cookies have been found');
          cookie_value = data.cookieValue;
          console.log(cookie_value);
      },
      function(error) {
          console.log('Cookies could not be found');
      });
    return cookie_value;
  }

  this.clearCookies = function() {
    $window.cookieMaster.clearCookies(
    function() {
      console.log('Cookies have been cleared');
    },
    function() {
      console.log('Cookies could not be cleared');
    });
  }

  function openPolicyModal(accepted) {
    $("<style type='text/css'> .modal{ display: block !important; } </style>").appendTo("head");
    $("<div/>").addClass("modal").appendTo("modal-open");

    $uibModal.open({
      templateUrl: 'src/dashboard/modals/policyViewerModal/policyViewerModal.html',
      controller: 'PolicyViewerModalCtrl',
      backdrop: 'static',
      keyboard: false,
      resolve: {
        accepted: accepted
      }
    });
  }

});
