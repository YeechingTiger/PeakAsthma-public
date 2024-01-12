describe('DashboardRootCtrl', function() {

    beforeEach(module('dashboard'));

    var scope,ctrl;
    var _peakFlowService, _asthmaZoneModalManager;

    beforeEach(inject(function($rootScope, $controller, peakFlowService, asthmaZoneModalManager) {
      scope = $rootScope.$new();
      ctrl = $controller('DashboardRootCtrl', {$scope: scope});
      _peakFlowService = peakFlowService;
      _asthmaZoneModalManager = asthmaZoneModalManager;

      spyOn(_peakFlowService, 'getPeakFlowReports').and.returnValue([]);
      spyOn(_asthmaZoneModalManager, 'recordPeakFlow');
    }));

    describe('#getPeakFlows', function() {
      it ('should call the peakFlowService getPeakFlowReports function and return it\'s result', function() {
        var result = scope.getPeakFlows();
        expect(_peakFlowService.getPeakFlowReports).toHaveBeenCalled();
        expect(result).toEqual([]);
      });
    });

    describe('#recordNewPeakFlow', function() {
      it ('should call the asthmaZoneModalManager recordPeakFlow function to show the recordPeakFlow modal', function() {
        scope.recordNewPeakFlow();
        expect(_asthmaZoneModalManager.recordPeakFlow).toHaveBeenCalled();
      });
    });

});
