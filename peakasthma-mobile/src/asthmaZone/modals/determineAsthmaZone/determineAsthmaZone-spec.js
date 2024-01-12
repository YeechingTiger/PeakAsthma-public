describe('DetermineasthmazoneCtrl', function() {

    beforeEach(module('asthmaZone'));

    var scope,modal,_asthmaZoneModalManager;

    beforeEach(inject(function($rootScope, $uibModal, $controller, asthmaZoneModalManager) {
      scope = $rootScope.$new();
      modal = $uibModal.open({
        controller: $controller('DetermineasthmazoneCtrl', {$scope: scope}),
        template: '<div></div>',
        scope: scope
      });
      _asthmaZoneModalManager = asthmaZoneModalManager;

      scope.$dismiss = function() { return; };

      spyOn(_asthmaZoneModalManager, 'howAreYouFeeling');
      spyOn(_asthmaZoneModalManager, 'recordPeakFlow');
      spyOn(scope, '$dismiss');
    }));

    describe('#recordSymptoms', function() {
      it('closes the modal, and calls the asthmaZoneModalManager', function() {
          scope.recordSymptoms();
          expect(_asthmaZoneModalManager.howAreYouFeeling).toHaveBeenCalled();
          expect(scope.$dismiss).toHaveBeenCalled();
      });
    });

    describe('#recordPeakFlow', function() {
      it('closes the modal, and calls the asthmaZoneModalManager', function() {
          scope.recordPeakFlow();
          expect(_asthmaZoneModalManager.recordPeakFlow).toHaveBeenCalled();
          expect(scope.$dismiss).toHaveBeenCalled();
      });
    });

});
