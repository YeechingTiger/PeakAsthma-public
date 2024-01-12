angular.module('willowApi').factory('apiEndpoints',function(apiConfig, $window) {

    var parentUrl = apiConfig.baseUrl;
    var apiEndpoints = {
      activityHistory: {
        index: parentUrl + '/api/activities'
      },
      user: {
        current: parentUrl + '/api/users/current',
        signUp: parentUrl + '/api/users',
        signIn: parentUrl + '/api/users/login',
        logout: parentUrl + '/api/users/logout',
        acceptPolicy: parentUrl + '/api/users/accept_policy',
        clincardBalance: parentUrl + '/api/clincard_balance_request'
      },
      notifications: {
        index: parentUrl + '/api/notifications',
        markAsRead: parentUrl + '/api/read_notification_records'
      },
      peakFlow: {
        create: parentUrl + '/api/peak_flows',
        index: parentUrl + '/api/peak_flows'
      },
      prescriptions: {
        index: parentUrl + '/api/prescriptions',
        takenPrescription: parentUrl + '/api/taken_prescription_records',
        notifications: parentUrl + '/api/prescriptions/notifications',
        reportNotifications: parentUrl + '/api/prescriptions/reports',
        remindMeLater: parentUrl + '/api/prescriptions/remindmelater'
      },
      symptoms: {
        index: parentUrl + '/api/symptoms'
      },
      symptom_reports: {
        create: parentUrl + '/api/symptom_reports'
      },
      tips: {
        get: parentUrl + '/api/tip'
      },
      videos: {
        like: parentUrl + '/api/video',
        index: parentUrl + '/api/video'
      },
      medication: {
        reminder_later:  parentUrl + '/api/medicationreminder/'
      },
      incentive: {
        incentive: parentUrl + "/api/incentive"
      },
      weather: parentUrl + "/api/weather/",
      survey: parentUrl + "/api/survey"
    
    };

    apiEndpoints.setAuthTokens = function(authToken, userId) {
      $window.localStorage.setItem('authToken', authToken);
      $window.localStorage.setItem('userId', userId);
    };

    return apiEndpoints;
});