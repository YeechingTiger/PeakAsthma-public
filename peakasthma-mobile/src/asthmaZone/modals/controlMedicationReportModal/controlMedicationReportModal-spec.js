describe('YellowzonemedicationinstructionsmodalCtrl', function() {

    beforeEach(module('asthmaZone'));

    var scope,modal,_peakFlowService,_asthmaZoneModalManager,defer,prescriptionLocal;

    beforeEach(inject(function($rootScope, $uibModal, $controller, peakFlowService, asthmaZoneModalManager, $q) {
      scope = $rootScope.$new();
      prescriptionLocal = {};
      modal = $controller('YellowzonemedicationinstructionsmodalCtrl', {$scope: scope, prescription: prescriptionLocal});
      _peakFlowService = peakFlowService;
      _asthmaZoneModalManager = asthmaZoneModalManager;

      scope.$dismiss = function() { return; };
      defer = $q.defer();

      spyOn(_peakFlowService, 'reportPrescriptionTaken').and.callFake(function() {
        return defer.promise;
      });
      spyOn(_asthmaZoneModalManager, 'updateHowIFeel');
      spyOn(scope, '$dismiss');
    }));

    describe('init', function() {
      it('sets the scope prescription value to the passed in prescription local', function() {
        expect(scope.prescription).toEqual(prescriptionLocal);
      });
    });

    describe('#complete', function() {
      it('closes the modal, and calls the asthmaZoneModalManager', function() {
          scope.complete();
          defer.resolve();
          scope.$apply();

          expect(_asthmaZoneModalManager.updateHowIFeel).toHaveBeenCalled();
          expect(scope.$dismiss).toHaveBeenCalled();
      });
    });

});
