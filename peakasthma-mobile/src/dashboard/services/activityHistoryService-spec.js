describe('activityHistoryService', function() {

  beforeEach(module('dashboard'));

  var _activityHistoryService, willowApiEndpoints, httpBackend, request;

  var mockActivityFeed = [
    {
      peakFlow: {
        score: 0,
        level: 'red'
      }
    },
    {
      peakFlow: {
        score: 300,
        level: 'green'
      }
    }
  ];

  beforeEach(inject(function(activityHistoryService, $httpBackend, apiEndpoints) {
    _activityHistoryService = activityHistoryService;
    httpBackend = $httpBackend;
    willowApiEndpoints = apiEndpoints;
  }));

  describe('#getHistory', function() {
    beforeEach(function() {
      request = httpBackend.when('GET', willowApiEndpoints.activityHistory.index)
        .respond({ activities: mockActivityFeed });
    });

    it('sets the service\'s activities to the returned API values', function() {
      httpBackend.expectGET(willowApiEndpoints.activityHistory.index);
      
      _activityHistoryService.getHistory();
      httpBackend.flush();

      expect(_activityHistoryService.history).toEqual(mockActivityFeed);
    });

    it('should not call a state transition after a failed call, and return the response', function() {
      var responseFromApi;
      request.respond(401, { errors: ['There aren\'t enough varieties of yogurt.'] });
      httpBackend.expectGET(willowApiEndpoints.activityHistory.index);

      _activityHistoryService.getHistory();
      httpBackend.flush();

      expect(_activityHistoryService.history).toEqual([]);
    });
  });

});
