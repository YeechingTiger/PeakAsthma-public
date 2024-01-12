angular.module('dashboard').service('activityHistoryService',function($http,$rootScope, apiEndpoints) {

  this.getHistory = function() {
    return $http({
      method: 'GET',
      url: apiEndpoints.activityHistory.index
    }).then(function successfulUserRegistration(response) {
      // console.log(response);
      var act =  response.data.activities;
      for (var index in act) {
        if (act[index].peakFlow) {
          act[index].peakFlow.feeling = chooseFeeling(act[index].peakFlow.feeling);
        }
      }
      return act;
    }, function failedUserRegistration(response) {
      return response.data;
    });
  };

   function chooseFeeling(color) {
    if (color == "green") {
        return "good";
    } else if (color == "yellow") {
        return "ok";
    } else {
        return "horrible";
    }
}
});
