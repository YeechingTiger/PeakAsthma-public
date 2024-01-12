angular.module('dashboard').directive('surveyLink', function (notificationService) {
  return {
    restrict: 'E',
    replace: true,
    scope: {
      notification: '=',
      text: '=',
      link: '=',
      unread: '@?'
    },
    templateUrl: 'src/dashboard/directives/survey-link/survey-link.html',
    link: function (scope, element, attrs, fn) {
      element.click(function() {
        window.open(scope.link, '_system');
      });

      if (scope.unread) {
        element.click(function () {
          notificationService.reportNotificationAsRead(scope.notification);
          console.log("Clicked");
        });
      }
    }
  };
});
