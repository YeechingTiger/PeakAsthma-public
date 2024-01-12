angular.module('dashboard').controller('DashboardNotificationsCtrl',function($scope, $rootScope, notificationService){
  var NOTIFICATIONS_PER_PAGE = 5;
  
  $scope.notificationsToShow = NOTIFICATIONS_PER_PAGE;
  
  
  function getReadNotifications() {
    $rootScope.spinner.style.display = '';
    notificationService.getReadNotifications().finally(function() {
      $rootScope.spinner.style.display = 'none';
    });
  }
  
  getReadNotifications();

  $scope.mergeResults = function() {
    notificationService.notifications.forEach(function(elem) {
      if (elem.alert == 11) {
        linkStartIndex = elem.message.search(/https/);
        elem.text = elem.message.substring(0, linkStartIndex);
        elem.link = elem.message.substring(linkStartIndex);
      }
    });

    return notificationService.notifications;
  };

  $scope.unreadNotifications = function() {
    notificationService.unreadNotifications.forEach(function (elem) {
      if (elem.alert == 11) {
        linkStartIndex = elem.message.search(/https/);
        elem.text = elem.message.substring(0, linkStartIndex);
        elem.link = elem.message.substring(linkStartIndex);
      }
    });

    return notificationService.unreadNotifications;
  };

  $scope.showMoreNotifications = function() {
    $scope.notificationsToShow += NOTIFICATIONS_PER_PAGE;
  };

  $scope.colorMap = {
    green: 'activity-history-record__icon--green',
    yellow: 'activity-history-record__icon--yellow',
    red: 'activity-history-record__icon--red',
    red_now: 'activity-history-record__icon--red'
  };
  
  
  notificationService.getUnreadNotifications();

});