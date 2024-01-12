describe('RecordpeakflowCtrl', function() {

    beforeEach(module('asthmaZone'));

    var scope,ctrl,_peakFlowService,q,defered;

    beforeEach(inject(function($rootScope, $controller, peakFlowService, $q) {
      scope = $rootScope.$new();
      ctrl = $controller('RecordpeakflowCtrl', {$scope: scope});
      _peakFlowService = peakFlowService;
      q = $q;

      scope.$dismiss = function() { return; };
    }));

    beforeEach(function() {
      spyOn(_peakFlowService, 'reportPeakFlow').and.callFake(function() {
        return q.resolve(null);
      });
      spyOn(scope, '$dismiss');
    });

    it('creates the initial peak flow value', function() {
      expect(scope.peakFlow.score).toEqual(270);
    });

    describe('#reportPeakFlow', function() {
      it('calls the peakFlowService and reports the current peak flow', function() {
        scope.reportPeakFlow();
        scope.$apply();

        expect(_peakFlowService.reportPeakFlow).toHaveBeenCalledWith(scope.peakFlow.score);
        expect(scope.$dismiss).toHaveBeenCalled();
      });
    });

});
