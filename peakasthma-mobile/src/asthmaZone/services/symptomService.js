angular.module('asthmaZone').service('symptomService',function($http, apiEndpoints, asthmaZoneModalManager) {

  var _this = this;
  this.symptoms = {};
  this.zone = '';

  this.getSymptoms = function() {
    return $http({
      method: 'GET',
      url: apiEndpoints.symptoms.index,
      params: {
        
      }
    }).then(function successfulSymptomGet(response) {
      var symptoms = response.data.symptoms;
      var categories = {};
      for (var index in symptoms) {
        if (!(symptoms[index].category in categories)) {
          categories[symptoms[index].category] = [symptoms[index]];
        } else {
          categories[symptoms[index].category].push(symptoms[index]);
        }
      }
      console.log(categories);
      _this.symptoms = categories;
      return response.data;
    }, function failedSymptomGet(response) {
      return response.data;
    });
  };

  this.reportSymptoms = function(symptoms) {
    return $http({
      method: 'POST',
      url: apiEndpoints.peakFlow.create,
      data: {
        symptoms: symptoms,
        feeling: this.zone
      }
    }).then(function successfulSymptomReport(response) {
        var symptomLevel = response.data.peakFlow.level;
        var prescription = response.data.prescription;
        asthmaZoneModalManager.reportLevel(symptomLevel, prescription);
        return response.data;
    }, function failedSymptomReport(response) {
      return response.data;
    });
  };

});
