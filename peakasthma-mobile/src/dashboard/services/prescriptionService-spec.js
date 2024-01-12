describe('prescriptionService', function() {

  beforeEach(module('dashboard'));

  var _prescriptionService, willowApiEndpoints, httpBackend, request, _loginService;

  var mockPrescriptionList = [
    {
      id: 0,
      name: 'Zeus-1'
    },
    {
      id: 1,
      name: 'Odin-5'
    }
  ];

  beforeEach(inject(function(prescriptionService, loginService, $httpBackend, apiEndpoints) {
    _prescriptionService = prescriptionService;
    _loginService = loginService;
    httpBackend = $httpBackend;
    willowApiEndpoints = apiEndpoints;

    _loginService.currentUser = {
      id: 0
    };
  }));

  describe('#getPrescriptions', function() {
    beforeEach(function() {
      request = httpBackend.when('GET', willowApiEndpoints.prescriptions.index)
        .respond({ prescriptions: mockPrescriptionList });
    });

    it('sets the service\'s prescriptions to the returned API values', function() {
      httpBackend.expectGET(willowApiEndpoints.prescriptions.index);
      
      _prescriptionService.getPrescriptions();
      httpBackend.flush();

      expect(_prescriptionService.prescriptions).toEqual(mockPrescriptionList);
    });

    it('should not call a state transition after a failed call, and return the response', function() {
      var responseFromApi;
      request.respond(401, { errors: ['There aren\'t enough varieties of yogurt.'] });
      httpBackend.expectGET(willowApiEndpoints.prescriptions.index);

      _prescriptionService.getPrescriptions();
      httpBackend.flush();

      expect(_prescriptionService.prescriptions).toEqual([]);
    });
  });

  describe('#updatePrescriptionReminderPreference', function() {
    beforeEach(function() {
      request = httpBackend.when('POST', willowApiEndpoints.prescriptions.notifications)
        .respond({ id: 1 });
    });

    it('sets the service\'s prescriptions to the returned API values', function() {
      httpBackend.expectPOST(willowApiEndpoints.prescriptions.notifications);
      
      _prescriptionService.updatePrescriptionReminderPreference(true, new Date());
      httpBackend.flush();

      expect(_loginService.currentUser).toEqual({ id: 1 });
    });

    it('should not call a state transition after a failed call, and return the response', function() {
      var responseFromApi;
      request.respond(401, { errors: ['There aren\'t enough varieties of yogurt.'] });
      httpBackend.expectPOST(willowApiEndpoints.prescriptions.notifications);

      _prescriptionService.updatePrescriptionReminderPreference(true, new Date());
      httpBackend.flush();

      expect(_loginService.currentUser).toEqual({ id: 0 });
    });
  });

});
