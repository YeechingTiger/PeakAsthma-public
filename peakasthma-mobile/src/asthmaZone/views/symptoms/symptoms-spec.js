describe('SymptomsCtrl', function() {

    beforeEach(module('asthmaZone'));

    var scope,ctrl,_symptomService;

    beforeEach(inject(function($rootScope, $controller, symptomService) {
      scope = $rootScope.$new();
      ctrl = $controller('SymptomsCtrl', {$scope: scope});
      _symptomService = symptomService;
    }));

    describe('#toggleSelect', function() {
      it('should add non-existing items to the list', function() {
        scope.symptoms = [1, 2, 3, 4];
        scope.selectedSymptoms = [];

        scope.toggleSelect(4);
        expect(scope.selectedSymptoms.indexOf(4)).toEqual(0);
      });

      it('should remove existing items to the list', function() {
        scope.symptoms = [1, 2, 3, 4];
        scope.selectedSymptoms = [4];

        scope.toggleSelect(4);
        expect(scope.selectedSymptoms.indexOf(4)).toEqual(-1);
      });
    });

    describe('#reportSymptoms', function() {
      beforeEach(function() {
        spyOn(_symptomService, 'reportSymptoms');
      });

      it('calls the reportSymptoms function on the symptomService with the scope\'s selected symptoms', function() {
        scope.selectedSymptoms = [0, 1, 2];
        scope.reportSymptoms();
        expect(_symptomService.reportSymptoms).toHaveBeenCalledWith(scope.selectedSymptoms);
      });
    });

});
