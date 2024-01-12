describe('DashboardNotificationsCtrl', function() {

    beforeEach(module('dashboard'));

    var scope,ctrl,_notificationService;

    beforeEach(inject(function($rootScope, $controller, notificationService) {
      scope = $rootScope.$new();
      ctrl = $controller('DashboardNotificationsCtrl', {$scope: scope});
      _notificationService = notificationService;
    }));

    describe('#notifications', function() {
      it('returns the notifications from the notificationService', function() {
        expect(scope.notifications()).toEqual([]);
      });
    });

    describe('#unreadNotifications', function() {
      it('returns the unread notifications from the notificationService', function() {
        expect(scope.unreadNotifications()).toEqual([]);
      });
    });

    describe('#showMoreNotifications', function() {
      it('returns the unread notifications from the notificationService', function() {
        expect(scope.notificationsToShow).toEqual(5);
        scope.showMoreNotifications();
        expect(scope.notificationsToShow).toEqual(10);
      });
    });

});
