angular.module('asthmaZone').service('peakFlowService',function($http, $q, apiEndpoints, asthmaZoneModalManager, symptomService) {

  var _this = this;
  this.latestPeakFlowReports = [];
  
  this.getPeakFlowReports = function() {
    return _this.latestPeakFlowReports;
  };

  this.listPeakFlows = function() {
    return $http({
      method: 'GET',
      url: apiEndpoints.peakFlow.index
    }).then(function successfulFlowReport(response) {
      _this.latestPeakFlowReports = response.data.peakFlows.sort(function (a, b) {
        return new Date(a.created) - new Date(b.created);
      });

      for (var index in _this.latestPeakFlowReports) {
        var peakflow = _this.latestPeakFlowReports[index];
        if (peakflow.level == "green") {
          peakflow.color = "#4BD97A";
          peakflow.score = 3;
        } else if (peakflow.level == "yellow") {
          peakflow.score = 2;
          peakflow.color = "#F7AA20"
        } else {
          peakflow.score = 1;
          peakflow.color = "#EE2F58"
        }
      }
      return response.data;
    }, function failedFlowReport(response) {
      return response.data;
    });
  };

  this.reportPeakFlow = function(peakFlowScore) {
    return $http({
      method: 'POST',
      url: apiEndpoints.peakFlow.create,
      data: {
        score: peakFlowScore,
        feeling: symptomService.zone
      }
    }).then(function successfulFlowReport(response) {
      var peakFlowLevel = response.data.peakFlow.level;
      var prescription = response.data.prescription;
      asthmaZoneModalManager.reportLevel(peakFlowLevel, prescription);
      _this.listPeakFlows();
    }, function failedFlowReport(response) {
      return response.data;
    });
  };

  this.reportPrescriptionTaken = function(prescription) {
    if (!prescription) {
      return $q.resolve();
    }

    return $http({
      method: 'POST',
      url: apiEndpoints.prescriptions.takenPrescription,
      data: {
        id: prescription.id
      }
    }).then(function successfulUserRegistration(response) {
      return response.data;
    }, function failedUserRegistration(response) {
      return response.data;
    });
  };

});
