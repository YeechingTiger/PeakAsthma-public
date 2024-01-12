describe('peakFlowService', function() {

  var _peakFlowService, _apiEndpoints, _asthmaZoneModalManager, httpBackend, request, rootScope;

  var mockPrescription = {
    id: 0
  };

  beforeEach(module('asthmaZone'));
  beforeEach(inject(function(peakFlowService, $httpBackend, apiEndpoints, asthmaZoneModalManager) {
    _peakFlowService = peakFlowService;
    httpBackend = $httpBackend;
    _apiEndpoints = apiEndpoints;
    _asthmaZoneModalManager = asthmaZoneModalManager;
  }));

  describe('#reportPeakFlow', function() {
    var symptoms = ['Bad case of the voodoo.'];
    beforeEach(function() {
      request = httpBackend.when('POST', _apiEndpoints.peakFlow.create);
      spyOn(_asthmaZoneModalManager, 'greenZoneModal');
      spyOn(_asthmaZoneModalManager, 'yellowZoneModal');
      spyOn(_asthmaZoneModalManager, 'redZoneModal');
    });

    it('calls the green modal after the report determines the user is in the green zone', function() {
      request.respond(200, { peakFlow: { level: 'green' } });
      httpBackend.expectPOST(_apiEndpoints.peakFlow.create);
      _peakFlowService.reportPeakFlow(300);
      httpBackend.flush();
      expect(_asthmaZoneModalManager.greenZoneModal).toHaveBeenCalled();
      expect(_asthmaZoneModalManager.yellowZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.redZoneModal).not.toHaveBeenCalled();
    });

    it('calls the yellow modal after the report determines the user is in the yellow zone', function() {
      request.respond(200, { peakFlow: { level: 'yellow' } });
      httpBackend.expectPOST(_apiEndpoints.peakFlow.create);
      _peakFlowService.reportPeakFlow(200);
      httpBackend.flush();
      expect(_asthmaZoneModalManager.greenZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.yellowZoneModal).toHaveBeenCalled();
      expect(_asthmaZoneModalManager.redZoneModal).not.toHaveBeenCalled();
    });

    it('calls the red modal after the report determines the user is in the red zone', function() {
      request.respond(200, { peakFlow: { level: 'red' } });
      httpBackend.expectPOST(_apiEndpoints.peakFlow.create);
      _peakFlowService.reportPeakFlow(100);
      httpBackend.flush();
      expect(_asthmaZoneModalManager.greenZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.yellowZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.redZoneModal).toHaveBeenCalled();
    });

    it('does not call any modals when the call fails', function() {
      request.respond(401, {});
      httpBackend.expectPOST(_apiEndpoints.peakFlow.create);
      _peakFlowService.reportPeakFlow([]);
      httpBackend.flush();

      expect(_asthmaZoneModalManager.greenZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.yellowZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.redZoneModal).not.toHaveBeenCalled();
    });
  });

  describe('#reportPrescriptionTaken', function() {
    beforeEach(function() {
      request = httpBackend.when('POST', _apiEndpoints.prescriptions.takenPrescription)
        .respond({ prescription: mockPrescription });
    });

    it('sets the service\'s prescriptions to the returned API values', function() {
      httpBackend.expectPOST(_apiEndpoints.prescriptions.takenPrescription);
      
      _peakFlowService.reportPrescriptionTaken(mockPrescription);
      httpBackend.flush();
    });

    it('should not call a state transition after a failed call, and return the response', function() {
      var responseFromApi;
      request.respond(401, { errors: ['There aren\'t enough varieties of yogurt.'] });
      httpBackend.expectPOST(_apiEndpoints.prescriptions.takenPrescription);

      _peakFlowService.reportPrescriptionTaken(mockPrescription);
      httpBackend.flush();
    });
  });

});
