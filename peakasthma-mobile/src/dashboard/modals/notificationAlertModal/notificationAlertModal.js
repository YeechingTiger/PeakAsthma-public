angular.module('dashboard').controller('NotificationalertmodalCtrl',function($scope, notification){

  $scope.notification = notification;
  
  $scope.ems_flag = function(notification) {
    type = notification.alert;
    if (type == 2 && notification.message.includes("emergency")) {
      return true;
    } else {
      return false;
    }
  }
});
