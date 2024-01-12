describe('symptomService', function() {

  var _symptomService, _apiEndpoints, _asthmaZoneModalManager, httpBackend, request, rootScope;

  beforeEach(module('asthmaZone'));
  beforeEach(inject(function(symptomService, $httpBackend, apiEndpoints, asthmaZoneModalManager) {
    _symptomService = symptomService;
    httpBackend = $httpBackend;
    _apiEndpoints = apiEndpoints;
    _asthmaZoneModalManager = asthmaZoneModalManager;
  }));

  describe('#getSymptoms', function() {
    var symptoms = ['Bad case of the voodoo.'];
    beforeEach(function() {
      request = httpBackend.when('GET', _apiEndpoints.symptoms.index + "?level=green");
    });

    it('sets the array of symptoms keyed by the level upon a success.', function() {
      request.respond(200, { symptoms: symptoms });
      httpBackend.expectGET(_apiEndpoints.symptoms.index + "?level=green");
      _symptomService.getSymptoms('green');
      httpBackend.flush();

      expect(_symptomService.symptoms.green).toEqual(symptoms);
    });

    it('does not set the array of symptoms on a failure', function() {
      request.respond(401, { symptoms: symptoms });
      httpBackend.expectGET(_apiEndpoints.symptoms.index + "?level=green");
      _symptomService.getSymptoms('green');
      httpBackend.flush();

      expect(_symptomService.symptoms.green).toEqual(undefined);
    });
  });

  describe('#reportSymptoms', function() {
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
      _symptomService.reportSymptoms([]);
      httpBackend.flush();
      expect(_asthmaZoneModalManager.greenZoneModal).toHaveBeenCalled();
      expect(_asthmaZoneModalManager.yellowZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.redZoneModal).not.toHaveBeenCalled();
    });

    it('calls the yellow modal after the report determines the user is in the yellow zone', function() {
      request.respond(200, { peakFlow: { level: 'yellow' } });
      httpBackend.expectPOST(_apiEndpoints.peakFlow.create);
      _symptomService.reportSymptoms([]);
      httpBackend.flush();
      expect(_asthmaZoneModalManager.greenZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.yellowZoneModal).toHaveBeenCalled();
      expect(_asthmaZoneModalManager.redZoneModal).not.toHaveBeenCalled();
    });

    it('calls the red modal after the report determines the user is in the red zone', function() {
      request.respond(200, { peakFlow: { level: 'red' } });
      httpBackend.expectPOST(_apiEndpoints.peakFlow.create);
      _symptomService.reportSymptoms([]);
      httpBackend.flush();
      expect(_asthmaZoneModalManager.greenZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.yellowZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.redZoneModal).toHaveBeenCalled();
    });

    it('does not call any modals when the call fails', function() {
      request.respond(401, {});
      httpBackend.expectPOST(_apiEndpoints.peakFlow.create);
      _symptomService.reportSymptoms([]);
      httpBackend.flush();

      expect(_asthmaZoneModalManager.greenZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.yellowZoneModal).not.toHaveBeenCalled();
      expect(_asthmaZoneModalManager.redZoneModal).not.toHaveBeenCalled();
    });
  });

});
