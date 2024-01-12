describe('DashboardCtrl', function() {

  beforeEach(module('dashboard'));

  var scope,ctrl,state,_asthmaZoneModalManager;

  beforeEach(inject(function($rootScope, $controller, $state, asthmaZoneModalManager) {
    scope = $rootScope.$new();
    ctrl = $controller('DashboardCtrl', {$scope: scope});
    state = $state;
    _asthmaZoneModalManager = asthmaZoneModalManager;
  }));

  describe('#highlightPersonalProfile', function() {
    it('checks for both the dashboard.medications and dashboard.patientProfile states', function() {
      spyOn(state, 'includes');

      scope.highlightPersonalProfile();
      expect(state.includes).toHaveBeenCalledWith('dashboard.medications');
      expect(state.includes).toHaveBeenCalledWith('dashboard.patientProfile');
    });

    it('returns true when the proper states are', function() {
      spyOn(state, 'includes').and.returnValue(true);

      expect(scope.highlightPersonalProfile()).toEqual(true);
    });

    it('returns false when the proper states are not active', function() {
      spyOn(state, 'includes').and.returnValue(false);

      expect(scope.highlightPersonalProfile()).toEqual(false);
    });
  });

  describe('#openDetermineAsthmaZoneModal', function() {
    it('calls the asthmaZoneModalManager\'s function to open the determineAsthmaZone modal.', function() {
      spyOn(_asthmaZoneModalManager, 'determineAsthmaZone').and.returnValue(false);

      scope.openDetermineAsthmaZoneModal();
      expect(_asthmaZoneModalManager.determineAsthmaZone).toHaveBeenCalled();
    });
  });

});
