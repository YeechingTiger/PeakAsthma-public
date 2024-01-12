angular.module('dashboard').directive('noticeBox', function(notificationService) {
    return {
        restrict: 'E',
        replace: true,
        scope: {
          notification: '=',
          unread: '@?'
        },
        templateUrl: 'src/dashboard/directives/notice-box/notice-box.html',
        link: function(scope, element, attrs, fn) {
          if (scope.unread) {
            element.click(function() {
              notificationService.reportNotificationAsRead(scope.notification);
              console.log("Clicked");
            });            
          }
        }
    };
});
