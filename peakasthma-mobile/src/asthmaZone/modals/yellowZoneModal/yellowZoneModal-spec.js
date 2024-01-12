describe('YellowzonemodalCtrl', function() {

    beforeEach(module('asthmaZone'));

    var scope,modal,_asthmaZoneModalManager,defer,prescriptionLocal;

    beforeEach(inject(function($rootScope, $controller, asthmaZoneModalManager) {
      scope = $rootScope.$new();
      prescriptionLocal = {};
      modal = $controller('YellowzonemodalCtrl', {$scope: scope, prescription: prescriptionLocal});
      _asthmaZoneModalManager = asthmaZoneModalManager;

      scope.$dismiss = function() { return; };

      spyOn(_asthmaZoneModalManager, 'yellowZoneMedicationInstructionsModal');
      spyOn(scope, '$dismiss');
    }));

    describe('#openInstructionModal', function() {
      it('closes the modal, and calls the asthmaZoneModalManager', function() {
          scope.openInstructionModal();
          
          expect(_asthmaZoneModalManager.yellowZoneMedicationInstructionsModal).toHaveBeenCalledWith({
            prescription: prescriptionLocal
          });
          expect(scope.$dismiss).toHaveBeenCalled();
      });
    });

});
