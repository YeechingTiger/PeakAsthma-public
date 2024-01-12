angular.module('dashboard').service('userService', function ($http, apiEndpoints, $uibModal, loginService) {

  this.openPolicyModal = function (accepted) {
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
  };

  this.acceptPolicy = function() {
    return $http({
      method: 'POST',
      url: apiEndpoints.user.acceptPolicy,
      data: {
        accept: true
      }
    }).then(function successfulAcceptPolicy(response) {
      loginService.currentUser.acceptPolicy = true;
      return response.data;
    }, function failedAcceptPolicy(response) {
      return response.data;
    });
  };

  this.openClincardBalanceModal = function (requestStatus) {
    // $("<style type='text/css'> .modal{ display: block !important; } </style>").appendTo("head");
    // $("<div/>").addClass("modal").appendTo("modal-open");
    
    $uibModal.open({
      templateUrl: 'src/dashboard/modals/clincardBalanceRequestModal/clincardBalanceRequestModal.html',
      controller: 'ClincardbalancerequestmodalCtrl',
      backdrop: 'static',
      keyboard: false,
      resolve: {
        requestStatus: requestStatus
      }
    });
  };

  this.requestClincardBalance = function() {
    return $http({
      method: 'POST',
      url: apiEndpoints.user.clincardBalance,
      data: {}
    }).then(function successfulRequestClincardBalance(response) {
      console.log(true);
      return {requestStatus: true};
    }, function failedAcceptRequestClincardBalance(response) {
      console.log(false);
      return {requestStatus: false};
    });
  };

  

});
