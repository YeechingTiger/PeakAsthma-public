describe('NotificationalertmodalCtrl', function() {

    beforeEach(module('dashboard'));

    var scope,ctrl,mockNotification;

    mockNotification = {
      id: 2,
      message: 'Keep your feet on the ground.',
      alert: true
    };

    beforeEach(inject(function($rootScope, $controller) {
      scope = $rootScope.$new();
      ctrl = $controller('NotificationalertmodalCtrl', {$scope: scope, notification: mockNotification});
    }));

    describe('init', function() {
      it('sets the passed in notification to scope', function() {
          expect(scope.notification).toEqual(mockNotification);
      });
    });

});
