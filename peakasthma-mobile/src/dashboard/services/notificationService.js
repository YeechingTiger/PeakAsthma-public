angular.module('dashboard').service('notificationService', function ($http, $rootScope ,$window, apiEndpoints, $interval, $uibModal, $state, activityHistoryService, asthmaZoneModalManager) {

  var NOTIFICATION_POLLING_INTERVAL = 5000;

  var _this = this;
  this.notifications = [];
  this.unreadNotifications = [];

  function filterNotifications(notifications) {
    var knownNotifications = knownNotificationIds();
    return notifications.filter(function (notification) {
      return knownNotifications.indexOf(notification.id) < 0;
    });
  }

  function process_time(row) {
    if (row.peakFlow) {
      row.sendAt = row.peakFlow.created;
    } else if (row.takenPrescriptionRecord) {
      row.sendAt = row.takenPrescriptionRecord.created;
    }
    return row;
  }

  this.mergeNotifications = function (newNotifications, currentNotifications) {
    var filteredNotifications = filterNotifications(newNotifications);
    currentNotifications = currentNotifications.concat(filteredNotifications);
    currentNotifications.sort(function (a, b) {
      a = process_time(a);
      b = process_time(b);

      if (a.sendAt > b.sendAt) {
        return -1;
      }

      if (a.sendAt < b.sendAt) {
        return 1;
      }

      return 0;
    });

    return currentNotifications;
  }

  function knownNotificationIds() {
    var allKnownNotifications = _this.notifications.concat(_this.unreadNotifications);

    return allKnownNotifications.map(function (notification) {
      // console.log(notification.id);
      return notification.id;
    });
  }

  function moveReadNotification(notification) {
    _this.unreadNotifications = _this.unreadNotifications.filter(function (testedNotification) {
      return testedNotification.id !== notification.id;
    });

    _this.notifications = _this.mergeNotifications([notification], _this.notifications);
  }

  function generateModals(unreadNotifications) {
    var newNotifications = filterNotifications(unreadNotifications);

    newNotifications.forEach(function (notification) {
      if (notification.alert == 1) {
        openFeelingModal(notification);
      } else if (notification.alert == 2) {
        openModal(notification);
      } else if (notification.alert == 3) {
        _this.openTakeMedicineModal(notification);
      } else if (notification.alert == 5) {
        openTakeYellowMedicineModal(notification);
      }
    });
  }

  function openModal(notification) {
    $uibModal.open({
      templateUrl: 'src/dashboard/modals/notificationAlertModal/notificationAlertModal.html',
      controller: 'NotificationalertmodalCtrl',
      backdrop: 'static',
      keyboard: false,
      resolve: {
        notification: notification
      }
    }).result.finally(function () {
      _this.reportNotificationAsRead(notification);
    });
  }

  function openFeelingModal(notification) {
    asthmaZoneModalManager.modelList.forEach(function(el) {
      console.log("should be closed");
      el.close();
    });
    $uibModal.open({
      templateUrl: 'src/asthmaZone/modals/updateHowIFeel/updateHowIFeel.html',
      controller: 'HowareyoufeelingCtrl',
      backdrop: 'static',
      keyboard: false,
      resolve: {
        notification: notification
      }
    }).result.finally(function () {
      _this.reportNotificationAsRead(notification);
    });
  }

  this.openTakeMedicineModal = function(notification) {
    $uibModal.open({
      templateUrl: 'src/asthmaZone/modals/controlMedicationReportModal/controlMedicationReportModal.html',
      controller: 'ControlMedicationReportModalCtrl',
      backdrop: 'static',
      keyboard: false,
      resolve: {
        notification: notification
      }
    }).result.finally(function () {
      _this.reportNotificationAsRead(notification);
    });
  }

  function openTakeYellowMedicineModal(notification) {
    $uibModal.open({
      templateUrl: 'src/asthmaZone/modals/yellowZoneMedicationInstructionsModal/yellowZoneMedicationInstructionsModal.html',
      controller: 'YellowzonemedicationinstructionsmodalCtrl',
      backdrop: 'static',
      keyboard: false,
      resolve: {
        prescription: null
      }
    }).result.finally(function () {
      _this.reportNotificationAsRead(notification);
    });
  }

  this.getReadNotifications = function () {
    return $http({
      method: 'GET',
      params: {
        read: true
      },
      url: apiEndpoints.notifications.index
    }).then(function successfulUnreadNotification(rn_response) {
      activityHistoryService.getHistory().then(function (ac_response) {
        _this.notifications = _this.mergeNotifications(rn_response.data.notifications, _this.notifications);
        _this.notifications = _this.mergeNotifications(ac_response, _this.notifications);
      })
      return _this.notifications;
    }, function failedUnreadNotification(response) {
      return _this.notifications;
    });
  };

  this.getUnreadNotifications = function () {
    if ($state.current.name != "login") {
      return $http({
        method: 'GET',
        params: {
          unread: true
        },
        url: apiEndpoints.notifications.index
      }).then(function successfulUnreadNotification(response) {
        if (response.status == -1) {
          $rootScope.errors = ["Please check your internet connection!"];
        }
        generateModals(response.data.notifications);
        _this.unreadNotifications = _this.mergeNotifications(response.data.notifications, _this.unreadNotifications);
        return response.data;
      }, function failedUnreadNotification(response) {
        if (response.status == -1) {
          $rootScope.errors = ["Please check your internet connection!"];
        }
        return response.data;
      });
    }
    else {
      return {}
    }
  };

  this.reportNotificationAsRead = function (notification) {
    return $http({
      method: 'POST',
      url: apiEndpoints.notifications.markAsRead,
      data: {
        id: notification.id
      }
    }).then(function successfulUnreadNotification(response) {
      _this.markNotificationAsRead(notification);

    }, function failedUnreadNotification(response) {
      return response;
    });
  };

  this.markNotificationAsRead = function (notification) {
    moveReadNotification(notification);
  };

  this.beginPollingNotifications = function () {
    return $interval(_this.getUnreadNotifications, NOTIFICATION_POLLING_INTERVAL);
  }
});
