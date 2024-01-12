describe('HowareyoufeelingCtrl', function() {

    beforeEach(module('asthmaZone'));

    var scope,modal,_symptomService,defer;

    beforeEach(inject(function($rootScope, $uibModal, $controller, symptomService, $q) {
      scope = $rootScope.$new();
      modal = $controller('HowareyoufeelingCtrl', {$scope: scope});
      _symptomService = symptomService;

      scope.$dismiss = function() { return; };
      defer = $q.defer();

      spyOn(symptomService, 'reportSymptoms').and.callFake(function() {
        return defer.promise;
      });
      spyOn(scope, '$dismiss');
    }));

    describe('#reportSymptoms', function() {
      it('closes the modal, and calls the asthmaZoneModalManager', function() {
          scope.reportSymptoms();
          defer.resolve();
          scope.$apply();

          expect(_symptomService.reportSymptoms).toHaveBeenCalled();
          expect(scope.$dismiss).toHaveBeenCalled();
      });
    });

});
