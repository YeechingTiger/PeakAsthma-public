describe('unreadNotificationBadge', function() {

  // Have to pull in the whole module to test the template.
  // Def not ideal - but the fix will require some build process changes.

  // Consider this a TODO. :)
  beforeEach(module('willowPeakAsthmaHyrbid'));

  var scope,element,compile,_notificationService;

  beforeEach(inject(function($rootScope,$compile, notificationService) {
    scope = $rootScope.$new();
    compile = $compile;
    _notificationService = notificationService;

    element = compile(angular.element('<unread-notification-badge></unread-notification-badge>'))(scope);
    scope.$digest();
  }));

  describe('scope#unreadNotificationsCount', function() {
    it('gets the count of the notificationService\'s unread notification', function() {
      expect(element.isolateScope().unreadNotificationsCount()).toEqual(0);

      _notificationService.unreadNotifications = [0, 1, 2];
      scope.$digest();
      expect(element.isolateScope().unreadNotificationsCount()).toEqual(3);
    });
  });

});