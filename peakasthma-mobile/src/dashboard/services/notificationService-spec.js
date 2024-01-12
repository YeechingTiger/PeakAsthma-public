describe('notificationService', function() {

  beforeEach(module('dashboard'));

  var _notiicationService, willowApiEndpoints, httpBackend, request, uibModal, readNotificationRequest;

  var mockNotificationList = [
    {
      id: 0,
      message: 'Get gabbin or get goin.'
    },
    {
      id: 1,
      message: 'Do not loiter.'
    },
    {
      id: 2,
      message: 'Keep your feet on the ground.',
      alert: true
    }
  ];

  beforeEach(inject(function(notificationService, $httpBackend, apiEndpoints, $uibModal) {
    _notiicationService = notificationService;
    httpBackend = $httpBackend;
    willowApiEndpoints = apiEndpoints;
    uibModal = $uibModal;
  }));

  describe('#getReadNotifications', function() {
    beforeEach(function() {
      request = httpBackend.when('GET', willowApiEndpoints.notifications.index + '?read=true')
        .respond({ notifications: mockNotificationList });
    });

    it('sets the service\'s read notifications to the returned API values', function() {
      httpBackend.expectGET(willowApiEndpoints.notifications.index + '?read=true');
      
      _notiicationService.getReadNotifications();
      httpBackend.flush();

      expect(_notiicationService.notifications).toEqual(mockNotificationList);
    });

    it('receiving duplicate notifications does not cause them to populate twice.', function() {
      httpBackend.expectGET(willowApiEndpoints.notifications.index + '?read=true');

      _notiicationService.unreadNotifications = mockNotificationList;
      
      _notiicationService.getReadNotifications();
      httpBackend.flush();

      expect(_notiicationService.notifications).toEqual([]);
    });

    it('should not update the notifications list after a failed call', function() {
      var responseFromApi;
      request.respond(401, { errors: ['There aren\'t enough varieties of yogurt.'] });
      httpBackend.expectGET(willowApiEndpoints.notifications.index + '?read=true');

      _notiicationService.getReadNotifications();
      httpBackend.flush();

      expect(_notiicationService.notifications).toEqual([]);
    });
  });

  describe('#getUnreadNotifications', function() {
    beforeEach(function() {
      request = httpBackend.when('GET', willowApiEndpoints.notifications.index + '?unread=true')
        .respond({ notifications: mockNotificationList });

      readNotificationRequest = httpBackend.when('POST', willowApiEndpoints.notifications.markAsRead)
        .respond({ notification: mockNotificationList[0] });

        spyOn(uibModal, 'open').and.returnValue({
          result: {
            finally: function(callback) {
              callback();
            }
          }
        });
    });

    it('sets the service\'s unread notifications to the returned API values, and opens modals for alert notifications', function() {
      httpBackend.expectGET(willowApiEndpoints.notifications.index + '?unread=true');

      // In this test, we will immediatly call the modal callback function
      // to ensure we are informing the API we have read notifications when we
      // open the alert modal.
      httpBackend.expectPOST(willowApiEndpoints.notifications.markAsRead);
      
      _notiicationService.getUnreadNotifications();
      httpBackend.flush();

      expect(_notiicationService.unreadNotifications).toEqual(mockNotificationList);
      expect(uibModal.open).toHaveBeenCalledWith({
        templateUrl: 'src/dashboard/modals/notificationAlertModal/notificationAlertModal.html',
        controller: 'NotificationalertmodalCtrl',
        resolve: {
          notification: mockNotificationList[2]
        }
      });
    });

    it('receiving duplicate notifications does not cause them to populate twice.', function() {
      httpBackend.expectGET(willowApiEndpoints.notifications.index + '?unread=true');

      _notiicationService.notifications = mockNotificationList;
      
      _notiicationService.getUnreadNotifications();
      httpBackend.flush();

      expect(_notiicationService.unreadNotifications).toEqual([]);
    });

    it('should not update the notifications list after a failed call', function() {
      var responseFromApi;
      request.respond(401, { errors: ['There aren\'t enough varieties of yogurt.'] });
      httpBackend.expectGET(willowApiEndpoints.notifications.index + '?unread=true');

      _notiicationService.getUnreadNotifications();
      httpBackend.flush();

      expect(_notiicationService.unreadNotifications).toEqual([]);
    });
  });

  describe('#reportNotificationAsRead', function() {
    beforeEach(function() {
      request = httpBackend.when('POST', willowApiEndpoints.notifications.markAsRead)
        .respond({ notification: mockNotificationList[0] });
      _notiicationService.unreadNotifications = mockNotificationList;
    });

    it('reports the notification as having been read', function() {
      httpBackend.expectPOST(willowApiEndpoints.notifications.markAsRead);
      
      _notiicationService.reportNotificationAsRead(mockNotificationList[0]);
      httpBackend.flush();

      expect(_notiicationService.notifications).toEqual([]);
    });
  });

  describe('#markNotificationAsRead', function() {
    beforeEach(function() {
      _notiicationService.unreadNotifications = mockNotificationList;
    });

    it('moves the notification from unread to read', function() {
      expect(_notiicationService.notifications.length).toEqual(0);
      expect(_notiicationService.unreadNotifications.length).toEqual(3);

      _notiicationService.markNotificationAsRead(mockNotificationList[0]);

      expect(_notiicationService.notifications.length).toEqual(1);
      expect(_notiicationService.unreadNotifications.length).toEqual(2);
      expect(_notiicationService.notifications[0]).toEqual(mockNotificationList[0]);
    });
  });

});
