describe('DashboardMedicationsCtrl', function() {

    beforeEach(module('dashboard'));

    var scope,ctrl,_prescriptionService;

    beforeEach(inject(function($rootScope, $controller, prescriptionService) {
      scope = $rootScope.$new();
      ctrl = $controller('DashboardMedicationsCtrl', {$scope: scope});
      _prescriptionService = prescriptionService;

      _prescriptionService.prescriptions = [];
    }));

    it('sets up the initial scope to only display 3 medications at once', function() {
      expect(scope.shownPrescriptions).toEqual(3);
    });

    describe('#showMorePrescriptions', function() {
      it('sets the shownPrescriptions value to 10 on first click', inject(function() {
        scope.showMorePrescriptions();
        expect(scope.shownPrescriptions).toEqual(10);
      }));

      it('adds 10 on subsequent clicks, showing 10 more items', inject(function() {
        scope.showMorePrescriptions();
        expect(scope.shownPrescriptions).toEqual(10);
        scope.showMorePrescriptions();
        expect(scope.shownPrescriptions).toEqual(20);
        scope.showMorePrescriptions();
        expect(scope.shownPrescriptions).toEqual(30);
      }));
    });

});
