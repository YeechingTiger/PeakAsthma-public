describe('RedzonemodalCtrl', function() {

    beforeEach(module('asthmaZone'));

    var scope,modal,_asthmaZoneModalManager,defer,prescriptionLocal;

    beforeEach(inject(function($rootScope, $controller, asthmaZoneModalManager) {
      scope = $rootScope.$new();
      prescriptionLocal = {};
      modal = $controller('RedzonemodalCtrl', {$scope: scope, prescription: prescriptionLocal});
      _asthmaZoneModalManager = asthmaZoneModalManager;

      scope.$dismiss = function() { return; };

      spyOn(_asthmaZoneModalManager, 'redZoneMedicationInstructionsModal');
      spyOn(scope, '$dismiss');
    }));

    describe('#openInstructionModal', function() {
      it('closes the modal, and calls the asthmaZoneModalManager', function() {
          scope.openInstructionModal();
          
          expect(_asthmaZoneModalManager.redZoneMedicationInstructionsModal).toHaveBeenCalledWith({
            prescription: prescriptionLocal
          });
          expect(scope.$dismiss).toHaveBeenCalled();
      });
    });

});
