angular.module('dashboard').directive('unreadNotificationBadge', function(notificationService) {
    return {
        restrict: 'E',
        replace: true,
        scope: {},
        templateUrl: 'src/dashboard/directives/unread-notification-badge/unread-notification-badge.html',
        link: function(scope, element, attrs, fn) {

          scope.unreadNotificationsCount = function() {
            return notificationService.unreadNotifications.length;
          };

        }
    };
});
