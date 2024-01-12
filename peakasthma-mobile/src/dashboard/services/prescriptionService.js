angular.module('dashboard').service('prescriptionService',function($http, $rootScope, apiEndpoints, loginService) {

  var _this = this;
  this.prescriptions = [];

  this.getPrescriptions = function() {
    $rootScope.spinner.style.display = '';
    return $http({
      method: 'GET',
      url: apiEndpoints.prescriptions.index
    }).then(function successfulGetPrescriptions(response) {
      _this.prescriptions = response.data.prescriptions.sort(function (a, b) {
        return level_code(a.levels.split(',')[0]) - level_code(b.levels.split(',')[0]);
      });
      console.log(response.data);
      return response.data;
    }, function failedGetPrescriptions(response) {
      return response.data;
    }).finally(function() {
      $rootScope.spinner.style.display = 'none';
    });
  };

  this.updatePrescriptionReminderPreference = function(remindPatient, time) {
    return $http({
      method: 'POST',
      url: apiEndpoints.prescriptions.notifications,
      data: {
        medicationReminders: remindPatient,
        medicationReminderTime: time
      }
    }).then(function successfulReminderUpdate(response) {
      console.log(response);
      loginService.currentUser = response.data;
      return response.data;
    },
    function failedReminderUpdate(response) {
      return response.data;
    });
  };

  this.updateReportReminderPreference = function(remindPatient, time) {
    return $http({
      method: 'POST',
      url: apiEndpoints.prescriptions.reportNotifications,
      data: {
        medicationReminders: remindPatient,
        reportReminderTime: time
      }
    }).then(function successfulReminderUpdate(response) {
      console.log(response);
      loginService.currentUser = response.data;
      return response.data;
    },
    function failedReminderUpdate(response) {
      return response.data;
    });
  };

  this.updateRemindMeLaterTime = function(id) {
    return $http({
      method: 'POST',
      url: apiEndpoints.prescriptions.remindMeLater,
      data: {
        remind_later_time: id,
      }
    }).then(function successfulRemindMeLaterUpdate(response) {
      console.log(response);
      loginService.currentUser = response.data;
      return response.data;
    },
    function failedremindMeLaterUpdate(response) {
      return response.data;
    });
  }

});

function level_code(level) {
  switch(level) {
    case 'Green':
      return 1;
    case 'Yellow':
      return 2;
    case 'Red':
      return 3;
  }
}