describe('asthmaZoneModalManager', function() {

  var _asthmaZoneModalManager, _$uibModal, _$rootScope, mockModalDefer;

  beforeEach(module('asthmaZone'));
  beforeEach(inject(function(asthmaZoneModalManager, $uibModal, $rootScope, $q) {
    _asthmaZoneModalManager = asthmaZoneModalManager;
    _$uibModal = $uibModal;
    _$rootScope = $rootScope;

    mockModalDefer = $q.defer();
    spyOn(_$uibModal, 'open').and.returnValue({ result: mockModalDefer.promise });
  }));

  describe('determineAsthmaZone', function() {
    it('provides the $uibModal service with the correct template and controller details', function() {
      _asthmaZoneModalManager.determineAsthmaZone();
      mockModalDefer.resolve(true);
      _$rootScope.$apply();
      expect(_$uibModal.open).toHaveBeenCalledWith(_asthmaZoneModalManager.MODAL_TYPES.determineAsthmaZone);
    });

    it('calls a callback function when provided, and passes the results of the promise down', function() {
      var called = false;
      _asthmaZoneModalManager.determineAsthmaZone(function(calledValue) {
        called = calledValue;
      });
      mockModalDefer.resolve(true);
      _$rootScope.$apply();

      expect(called).toEqual(true);
    });
  });

  describe('greenZoneModal', function() {
    it('provides the $uibModal service with the correct template and controller details', function() {
      _asthmaZoneModalManager.greenZoneModal();
      expect(_$uibModal.open).toHaveBeenCalledWith(_asthmaZoneModalManager.MODAL_TYPES.greenZoneModal);
    });

    it('calls a callback function when provided, and passes the results of the promise down', function() {
      var called = false;
      _asthmaZoneModalManager.greenZoneModal(function(calledValue) {
        called = calledValue;
      });
      mockModalDefer.resolve(true);
      _$rootScope.$apply();

      expect(called).toEqual(true);
    });
  });

  describe('howAreYouFeeling', function() {
    it('provides the $uibModal service with the correct template and controller details', function() {
      _asthmaZoneModalManager.howAreYouFeeling();
      mockModalDefer.resolve(true);
      _$rootScope.$apply();
      expect(_$uibModal.open).toHaveBeenCalledWith(_asthmaZoneModalManager.MODAL_TYPES.howAreYouFeeling);
    });

    it('calls a callback function when provided, and passes the results of the promise down', function() {
      var called = false;
      _asthmaZoneModalManager.howAreYouFeeling(function(calledValue) {
        called = calledValue;
      });
      mockModalDefer.resolve(true);
      _$rootScope.$apply();

      expect(called).toEqual(true);
    });
  });

  describe('yellowZoneModal', function() {
    it('provides the $uibModal service with the correct template and controller details', function() {
      _asthmaZoneModalManager.yellowZoneModal();
      expect(_$uibModal.open).toHaveBeenCalledWith(_asthmaZoneModalManager.MODAL_TYPES.yellowZoneModal);
    });

    it('calls a callback function when provided, and passes the results of the promise down', function() {
      var called = false;
      _asthmaZoneModalManager.yellowZoneModal(null, function(calledValue) {
        called = calledValue;
      });
      mockModalDefer.resolve(true);
      _$rootScope.$apply();

      expect(called).toEqual(true);
    });
  });

  describe('redZoneModal', function() {
    it('provides the $uibModal service with the correct template and controller details', function() {
      _asthmaZoneModalManager.redZoneModal();
      expect(_$uibModal.open).toHaveBeenCalledWith(_asthmaZoneModalManager.MODAL_TYPES.redZoneModal);
    });

    it('calls a callback function when provided, and passes the results of the promise down', function() {
      var called = false;
      _asthmaZoneModalManager.redZoneModal(null, function(calledValue) {
        called = calledValue;
      });
      mockModalDefer.resolve(true);
      _$rootScope.$apply();

      expect(called).toEqual(true);
    });
  });

});
