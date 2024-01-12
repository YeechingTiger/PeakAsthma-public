describe('noticeBox', function() {

  // Have to pull in the whole module to test the template.
  // Def not ideal - but the fix will require some build process changes.

  // Consider this a TODO. :)
  beforeEach(module('willowPeakAsthmaHyrbid'));

  var scope,element,compile,_notificationService;

  beforeEach(inject(function($rootScope,$compile, notificationService) {
    scope = $rootScope.$new();
    compile = $compile;
    _notificationService = notificationService;

    spyOn(_notificationService, 'markNotificationAsRead');
    spyOn(_notificationService, 'reportNotificationAsRead');

    scope.notification = {
      id: 0,
      message: 'test'
    };
    scope.unread = true;

    element = compile(angular.element('<notice-box notification="notification" unread="true"></notice-box>'))(scope);
    scope.$digest();
  }));

  describe('init', function() {
    it('when the notification is unread, we report to the API that we\'ve read it.', function() {
      expect(_notificationService.reportNotificationAsRead).toHaveBeenCalledWith(scope.notification);
    });
  });

  describe('element#click', function() {
    it('when clicking on the element, we call the markNotificationAsRead function.', function() {
      element.click();
      expect(_notificationService.markNotificationAsRead).toHaveBeenCalledWith(scope.notification);
    });
  });

});